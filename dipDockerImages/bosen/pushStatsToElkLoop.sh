#! /bin/bash

#
# the file format is the following
#
# <prefix><UTC timestamp with 6 ending digits for microseconds>_<thread id int>
#
# example: /tmp/zz_00001566205429617756_00000140431159338752
#


COMMAND=$( basename "$0" )
HERE=$( dirname "$0" )

: ${_do_unit_test:=''}

_elasticsearch_diplog_url=''
_stat_file_prefix=''
_elasticsearch_server_operational=true
: ${_timeout_before_considering_elasticsearch_KO:=10s}
_es_index=''

_do_log=true

: ${STATS_WORKER_NAME:="$( uname -n )"}

if [ -n "${_do_unit_test}" ]
then
    # preset some defaults
    if [ -z "${STATS_ELASTICSEARCH_URL}" ]
    then
	_els_url_arg_value="http://s-eunuc:9200"
    else
	_els_url_arg_value="${STATS_ELASTICSEARCH_URL}"
    fi

    _unit_test_tmp_dir=/tmp/_unit_test

    set -- --elasticsearch_url="${_els_url_arg_value}" --stat_file_prefix="${_unit_test_tmp_dir}/test_weitghs_" "$@"
fi

while [ -n "$1" ]
do
    case "$1" in

	--elasticsearch_url=* )
	    _elasticsearch_diplog_url="${1#--elasticsearch_url=}"
	    ;;

	--stat_file_prefix=* )
	    _stat_file_prefix="${1#--stat_file_prefix=}"
	    ;;
	*)
	    ;;
    esac

    shift
done



if [ -z "${_elasticsearch_diplog_url}" -o -z "${_stat_file_prefix}" ]
then
    echo "USAGE: $0 --elasticsearch_url=<elastic search url> --stat_file_prefix=<prefix of weight files>" 1>&2
    exit 1
fi


#
# search for python binary file
#

if [ -z "${PYTHON}" ]
then
    for p in "${HERE}/misc/pushToElastic/.venv/Scripts/python" "${HERE}/misc/pushToElastic/.venv/bin/python"
    do
	if [ -x "${p}" ]
	then
	    PYTHON="${p}"
	    break
	fi
    done
fi

: ${PYTHON_MAIN:="${HERE}/misc/pushToElastic/src/dipElasticClient.py"}

: ${MAX_WAIT_DELAY_FOR_FILES:=60}
: ${END_TAG_SUFFIX:='__END__'}

: ${ELASTICSEARCH_INDEX_PREFIX:="dip-stat-weight-distance-"}

_not_ended=true
_nb_sleep_done=0

_correctCygwinVar ()
{
    varValue="${1}"

    echo "${varValue}" | sed -e 's|^\$||' -e 's|\r$||'
}

getFieldValueOnLine ()
{
    field_line_number=$1
    bosen_weight_file_content="$2"

    field_value=$(
	sed -n ${field_line_number}p <<< "${bosen_weight_file_content}" | \
	    cut --delimiter=':' --fields=2 | \
	    tr -d '[:space:]'
    )

    echo "${field_value}"
}

getDenseRawMatrix ()
{
    bosen_weight_file_content="$1"

    matrix_with_features=$(
	sed -n '3,$p' <<< "${bosen_weight_file_content}"
    )

    matrix_without_features=$(
	sed -e 's/[0-9][0-9]*://g' <<< "${matrix_with_features}"
    )

    echo "${matrix_without_features}"
}


#
# main
#

postStatFilesMainLoop ()
{

    if [ -z "${STATS_TARGET_BOSEN_WEIGHTS}" ]
    then
	echo "ERROR: no content provided for var \"STATS_TARGET_BOSEN_WEIGHTS\"" 1>&2
	exit 1
    fi

    _target_weight_matrix="$( getDenseRawMatrix "${STATS_TARGET_BOSEN_WEIGHTS}" )"

    

    while ${_not_ended}
    do

	# get all files, except the one called "${_stat_file_prefix}${END_TAG_SUFFIX}"
	stat_file_list=$(
	    ls \
		-1 \
		-f \
		"${_stat_file_prefix}"* 2>/dev/null \
		| \
		grep -v "${_stat_file_prefix}${END_TAG_SUFFIX}"
	)
	if [ -z "${stat_file_list}" ]
	then

	    # No stat files have been found

	    if [ -f "${_stat_file_prefix}${END_TAG_SUFFIX}" ]
	    then
		# if we fould no stat files, but "${_stat_file_prefix}"${END_TAG_SUFFIX}"", we terminate the infinite loop
		rm "${_stat_file_prefix}${END_TAG_SUFFIX}"
		exit 0
	    else
		if [ ${_nb_sleep_done} -ge "${MAX_WAIT_DELAY_FOR_FILES}" ]
		then
		    # if we did not find stat files for more than ${MAX_WAIT_DELAY_FOR_FILES}
		    # we abandon, but it's an error
		    exit 1
		else
		    # if we are still in reasonnable delays, we keep on waiting for new stat files
		    sleep 1s
		    _nb_sleep_done=$(( ${_nb_sleep_done} + 1 ))
		fi
	    fi

	else

	    # we got a list of stat files

	    # we reorder the list, based on a subpart containing the timestamp of the file
	    ordered_stat_file_list=$(
		prefix_len=${#_stat_file_prefix}
		sort_match_position=$(( ${prefix_len} + 1 ))
		sort -t '_' --key=1.${sort_match_position}n <<< "${stat_file_list}"

	    )


	    #
	    # insert all available files
	    #

	    _es_bulk_data=''
	    
	    if ${_do_log}
	    then
		_nb_remaining_stat_files=$( wc -l <<< "${ordered_stat_file_list}" )
		echo -n "[Stat files subset: "
		echo -n ${_nb_remaining_stat_files}
		echo -n "]"
	    fi


	    for stat_file in ${ordered_stat_file_list}
	    do

		stat_file_content=$( cat "${stat_file}" )

		#
		# prepare input for stat post pgm
		#
		num_labels=$( getFieldValueOnLine 1 "${stat_file_content}" )
		feature_dim=$( getFieldValueOnLine 2 "${stat_file_content}" )
		matrix="$( getDenseRawMatrix "${stat_file_content}" )"

		# get timestamp from file name
		stat_file_suffix="${stat_file#${_stat_file_prefix}}"
		
		file_timestamp_from_epoch_ns="${stat_file_suffix%_*}"
		thread_id="${stat_file_suffix#*_}"

		#
		# convert timestamp to suitable string
		#
		s_part="${file_timestamp_from_epoch_ns::-6}"
		ns_part="${file_timestamp_from_epoch_ns: -6}"
		utc_timestamp_since_epoch="${s_part}.${ns_part}"

		#
		# generated dummy var to check (during debugging) the retrieved timestamp
		#
		hm_timestamp=$(
		    date "--date=@${utc_timestamp_since_epoch}" --utc '+%Y-%m-%dT%H:%M:%S.%NZZ'
		)

		elastic_timestamp=${utc_timestamp_since_epoch}


		#
		# compute a new ES record
		#

		#
		# TODO: add thread id field
		#

		if ${_elasticsearch_server_operational}
		then
		    new_es_record_json_format=$(
			${PYTHON} ${PYTHON_MAIN} \
			       --action=make_es_record_body \
			       --utc_timestamp_since_epoch="${elastic_timestamp}" \
			       --worker_name="${STATS_WORKER_NAME}" \
			       \
			       --num_labels="${num_labels}" \
			       --feature_dim="${feature_dim}" \
			       --minibatch_weight_matrix="${matrix}" \
			       --target_weight_matrix="${_target_weight_matrix}"
		    )

		    python_status=$?

		    case ${python_status} in
			0)
			    #OK
			    ;;
			*)
			    #TODO: check for other exit codes generated by python script
			    echo "${COMMAND} WARNING. Elasticsearch push client exited with code ${python_status}." 1>&2
			    ;;
		    esac
		fi

		new_record_body_as_single_line=$(
		    # take in account ^M for Windows/Cygwin configurations
		    echo "${new_es_record_json_format}" | \
			 tr -d '\n' | \
			 tr -d ''
		)
		_es_bulk_data="${_es_bulk_data}{ \"index\": {} }
${new_record_body_as_single_line}
"

		#
		# file processed => rm
		#
		rm "${stat_file}"

		if ${_do_log}
		then
		    echo -n "(${_nb_remaining_stat_files})"
		    _nb_remaining_stat_files=$(( ${_nb_remaining_stat_files} - 1 ))
		fi


	    done

	    #
	    # create once ES index in it does not exist
	    #
	    if [ -z "${_es_index}" ]
	    then

		_es_index=$( \
		    timeout ${_timeout_before_considering_elasticsearch_KO} \
			 ${PYTHON} ${PYTHON_MAIN} \
			    --action=create_index \
			    --elasticsearch_url="${_elasticsearch_diplog_url}" \
			    --index_prefix="${ELASTICSEARCH_INDEX_PREFIX}" \
			    --utc_timestamp_since_epoch="${elastic_timestamp}" \
			 )

		if [ $( uname -o ) == "Cygwin" ]
		then
		    _es_index=$( _correctCygwinVar "${_es_index}" )
		fi

		python_status=$?
		case ${python_status} in
		    124)
			# we got a timeout
			# => we consider Elasticsearch server to slow and we give up
			#
			# NOTE:
			#   we do not exit this process to continue remover generated stat_file.
			#   this prevents possible filesystem growth problems

			echo "${COMMAND} FATAL ERROR. Timeout reach while running elasticsearch push client. Skip future calls." 1>&2
			_elasticsearch_server_operational=false
			;;
		    0)
			#OK
			;;
		    *)
			#TODO: check for other exit codes generated by python script
			echo "${COMMAND} WARNING. Elasticsearch push client exited with code ${python_status}." 1>&2
			;;
		esac

	    fi


	    #
	    # push bulk records
	    #

	    # FIXME: add timeout

	    if [ -n "${_es_index}" ]
	    then
		# we where able to create the index => post to it
		es_push_result=$(
		    curl --silent -X POST "${_elasticsearch_diplog_url}/${_es_index}/_doc/_bulk" -H 'Content-Type: application/x-ndjson' --data-binary "${_es_bulk_data}"
		)
	    else
		echo "${COMMAND} WARNING. Not Elasticsearch index could be created. Not data are pushed." 1>&2
	    fi
	    
	    if ${_do_log}
	    then
		echo "[Pushed]"
	    fi
	fi
    done
}




if [ -n "${_do_unit_test}" ]
then

    _unit_test_tmp_dir=/tmp/_unit_test
    mkdir -p "${_unit_test_tmp_dir}"
    rm -f "${_unit_test_tmp_dir}"/*
    cp "${HERE}/misc/pushToElastic/test/test_weitghs"* "${_unit_test_tmp_dir}"

    MAX_WAIT_DELAY_FOR_FILES=2
    STATS_TARGET_BOSEN_WEIGHTS=$( cat "${HERE}/misc/pushToElastic/test/final_learning_test_weitghs" )

fi

if false && [ -n "${_do_unit_test}" ]
then

    timestamp_suffix="$( date --utc '+%s' )123456"

    unit_test_file_name="${_stat_file_prefix}${timestamp_suffix}_$$"

    cat <<< "${m_string_for_unit_test}" > "${unit_test_file_name}"
    touch "${_stat_file_prefix}${END_TAG_SUFFIX}"
    
    MAX_WAIT_DELAY_FOR_FILES=2
    STATS_TARGET_BOSEN_WEIGHTS=$( cat "${HERE}/misc/pushToElastic/test/final_learning_test_weitghs" )

fi

postStatFilesMainLoop
