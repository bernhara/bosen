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

if [ -n "${_do_unit_test}" ]
then
    set -- --elasticsearch_url=http://s-ku2raph:9200 --stat_file_prefix=/tmp/zz_
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


: ${PYTHON="${HERE}/misc/pushToElastic/.venv/bin/python3.6"}
: ${PYTHON_MAIN:="${HERE}/misc/pushToElastic/src/dipElasticClient.py"}

: ${MAX_WAIT_DELAY_FOR_FILES:=60}
: ${END_TAG_SUFFIX:='__END__'}

: ${ELASTICSEARCH_INDEX_PREFIX:="dip-stat-weight-distance-"}

_not_ended=true
_nb_sleep_done=0

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

	# FIXME: DEBUG
	set -x

	# get all files, except the one called "${_stat_file_prefix}${END_TAG_SUFFIX}"
	stat_file_list=$(
	    ls \
		-1 \
		-f \
		"${_stat_file_prefix}"* \
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
		    echo "DEBUG: =============================== enter sleep" 1>&2

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

	    # FIXME:
	    set +x
	    for stat_file in ${ordered_stat_file_list}
	    do
		# FIXME:
		echo "ZZZZZZZZZZ=== handling ${stat_file}" 1>&2

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

		if ${_elasticsearch_server_operational}
		then
		    timeout 10s \
			${PYTHON} ${PYTHON_MAIN} \
			--elasticsearch_url=${_elasticsearch_diplog_url} \
			--index_prefix="${ELASTICSEARCH_INDEX_PREFIX}" \
			--utc_timestamp_since_epoch="${elastic_timestamp}" \
			--worker_name="thread_${thread_id}" \
			\
			--num_labels="${num_labels}" \
			--feature_dim="${feature_dim}" \
			--minibatch_weight_matrix="${matrix}" \
			--target_weight_matrix="${_target_weight_matrix}"

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


		rm "${stat_file}"

	    done
	fi
    done
}






# SAMPLE DATA FOR TEST
m_string_for_unit_test='num_labels: 7
feature_dim: 54
0:0.0186763 1:-0.0164335 2:-0.0169998 3:0.0370315 4:0.00644837 5:0.0421807 6:0.00698872 7:-0.00304337 8:-0.00585255 9:0.0935973 10:0.0493765 11:0 12:0.00329131 13:-0.0012124 14:0 15:0 16:0 17:0 18:0 19:0 20:0 21:0 22:0 23:-0.00256255 24:0 25:0.00840535 26:0 27:0 28:0 29:0 30:0 31:0 32:0 33:0 34:0 35:0 36:0.0168786 37:0 38:0 39:0 40:0 41:0 42:0.0152209 43:0.0174101 44:0 45:-0.00125008 46:-0.00264695 47:0 48:0 49:0 50:0 51:0 52:0 53:0
0:-0.00114076 1:-0.0235196 2:0.0447963 3:-0.0133807 4:0.0160463 5:0.00435073 6:-0.0176143 7:-0.0308338 8:-0.011437 9:-0.0470052 10:-5.83057e-05 11:0 12:0.0324549 13:-0.00193525 14:0 15:0 16:0 17:0 18:0 19:0 20:0 21:0 22:0 23:0.0064143 24:0 25:-0.00123802 26:0 27:0 28:0 29:0 30:0 31:0 32:0 33:0 34:0 35:0 36:-0.00289265 37:0 38:0 39:0 40:0 41:0 42:0.00594705 43:-0.00334087 44:0 45:0.00845456 46:0.0171169 47:0 48:0 49:0 50:0 51:0 52:0 53:0
0:0.00144582 1:0.00957494 2:-0.00953794 3:-0.00304181 4:-0.00462175 5:-0.00699856 6:0.000492702 7:0.0122706 8:0.00845034 9:-0.00784991 10:-0.00986364 11:0 12:-0.00714924 13:-0.00137047 14:0 15:0 16:0 17:0 18:0 19:0 20:0 21:0 22:0 23:-0.00277035 24:0 25:-0.00143347 26:0 27:0 28:0 29:0 30:0 31:0 32:0 33:0 34:0 35:0 36:-0.00279719 37:0 38:0 39:0 40:0 41:0 42:-0.00423359 43:-0.00281385 44:0 45:-0.0014409 46:-0.002894 47:0 48:0 49:0 50:0 51:0 52:0 53:0
0:0.00144582 1:0.00957494 2:-0.00953794 3:-0.00304181 4:-0.00462175 5:-0.00699856 6:0.000492702 7:0.0122706 8:0.00845034 9:-0.00784991 10:-0.00986364 11:0 12:-0.00714924 13:-0.00137047 14:0 15:0 16:0 17:0 18:0 19:0 20:0 21:0 22:0 23:-0.00277035 24:0 25:-0.00143347 26:0 27:0 28:0 29:0 30:0 31:0 32:0 33:0 34:0 35:0 36:-0.00279719 37:0 38:0 39:0 40:0 41:0 42:-0.00423359 43:-0.00281385 44:0 45:-0.0014409 46:-0.002894 47:0 48:0 49:0 50:0 51:0 52:0 53:0
0:0.00144582 1:0.00957494 2:-0.00953794 3:-0.00304181 4:-0.00462175 5:-0.00699856 6:0.000492702 7:0.0122706 8:0.00845034 9:-0.00784991 10:-0.00986364 11:0 12:-0.00714924 13:-0.00137047 14:0 15:0 16:0 17:0 18:0 19:0 20:0 21:0 22:0 23:-0.00277035 24:0 25:-0.00143347 26:0 27:0 28:0 29:0 30:0 31:0 32:0 33:0 34:0 35:0 36:-0.00279719 37:0 38:0 39:0 40:0 41:0 42:-0.00423359 43:-0.00281385 44:0 45:-0.0014409 46:-0.002894 47:0 48:0 49:0 50:0 51:0 52:0 53:0
0:-0.0233188 1:0.0016534 2:0.0103553 3:-0.0114836 4:-0.00400769 5:-0.0185372 6:0.00865482 7:-0.0152054 8:-0.0165118 9:-0.0151924 10:-0.00986364 11:0 12:-0.00714924 13:0.00862953 14:0 15:0 16:0 17:0 18:0 19:0 20:0 21:0 22:0 23:0.00722965 24:0 25:-0.00143347 26:0 27:0 28:0 29:0 30:0 31:0 32:0 33:0 34:0 35:0 36:-0.00279719 37:0 38:0 39:0 40:0 41:0 42:-0.00423359 43:-0.00281385 44:0 45:-0.0014409 46:-0.002894 47:0 48:0 49:0 50:0 51:0 52:0 53:0
0:0.00144582 1:0.00957494 2:-0.00953794 3:-0.00304181 4:-0.00462175 5:-0.00699856 6:0.000492702 7:0.0122706 8:0.00845034 9:-0.00784991 10:-0.00986364 11:0 12:-0.00714924 13:-0.00137047 14:0 15:0 16:0 17:0 18:0 19:0 20:0 21:0 22:0 23:-0.00277035 24:0 25:-0.00143347 26:0 27:0 28:0 29:0 30:0 31:0 32:0 33:0 34:0 35:0 36:-0.00279719 37:0 38:0 39:0 40:0 41:0 42:-0.00423359 43:-0.00281385 44:0 45:-0.0014409 46:-0.002894 47:0 48:0 49:0 50:0 51:0 52:0 53:0'

m_final_learning_string_for_unit_test='num_labels: 7
feature_dim: 54
0:1.47151 1:0.0871438 2:-0.214651 3:-0.110342 4:-0.229398 5:-0.245189 6:-0.180576 7:-0.320589 8:0.074992 9:0.131998 10:1.93473 11:0.403259 12:1.55033 13:-0.0273264 14:-0.00154609 15:-0.0535776 16:-0.0053314 17:-0.0578093 18:-0.000108347 19:-0.00979735 20:-0.0530444 21:0 22:0.146045 23:0.0357319 24:-0.0444385 25:-0.0074418 26:0.168712 27:0 28:0 29:-0.00298374 30:-0.0301326 31:-0.0139281 32:-0.0251108 33:0.406429 34:0 35:0.801176 36:1.15034 37:0.051819 38:0 39:-0.0700538 40:0 41:0 42:0.707208 43:0.216414 44:0.876815 45:0.285871 46:0.503831 47:-0.0655331 48:0.0676791 49:0 50:0 51:-0.275511 52:-0.400132 53:-0.440606
0:-0.480646 1:-0.107792 2:0.151591 3:0.124172 4:0.0102008 5:0.0556738 6:-0.0113682 7:0.140518 8:0.0705429 9:0.0285185 10:2.73621 11:0.747552 12:2.12478 13:-0.0513337 14:-0.0212861 15:-0.253792 16:-0.15928 17:0.0163755 18:-0.00592904 19:0.0461635 20:0.0862153 21:0 22:0.00831278 23:0.471963 24:0.545878 25:0.753727 26:0.301362 27:0 28:0 29:-0.10404 30:-0.0367716 31:0.049049 32:0.162317 33:-0.175442 34:0 35:0.289024 36:0.157352 37:0.536443 38:0 39:-0.0108778 40:0 41:0 42:0.998233 43:0.399625 44:-0.01665 45:0.917544 46:0.815371 47:0.168793 48:-0.00566184 49:0 50:0 51:-0.20011 52:-0.0771142 53:-0.0995812
0:-1.42748 1:0.333513 2:0.579387 3:0.148116 4:0.00197478 5:-0.00411276 6:0.163158 7:0.324656 8:-0.104953 9:-0.287086 10:-0.974196 11:-0.179193 12:-0.776279 13:0.235312 14:0.101533 15:0.426159 16:0.274893 17:0.136247 18:0.0225526 19:-0.125572 20:-0.00284469 21:0 22:-0.0535718 23:-0.238794 24:-0.140148 25:-0.167609 26:-0.219301 27:0 28:0 29:-0.0478475 30:0.134056 31:-0.00733823 32:-0.0101397 33:-0.0270453 34:035:-0.17169 36:-0.222638 37:-0.115782 38:0 39:-0.017904 40:0 41:0 42:-0.325648 43:-0.156454 44:-0.118155 45:-0.262841 46:-0.276976 47:-0.0120602 48:-0.00116718 49:0 50:0 51:-0.0332311 52:-0.0264844 53:-0.00855291
0:-0.0625162 1:-0.021588 2:0.0204855 3:0.000148943 4:0.0146555 5:0.136354 6:0.0137038 7:0.0284361 8:-0.0105475 9:0.0296212 10:-1.01605 11:-0.249521 12:-1.084 13:-0.159603 14:-0.010553 15:-0.053462 16:-0.0167063 17:-0.0493043 18:-0.001882 19:-0.0538977 20:-0.00700198 21:0 22:-0.0187571 23:-0.133438 24:-0.0714613 25:-0.13234 26:-0.0548508 27:0 28:0 29:-0.00468768 30:-0.0149525 31:-0.00578871 32:-0.0245629 33:-0.0444095 34:0 35:-0.194616 36:-0.226298 37:-0.121438 38:0 39:-0.0169968 40:0 41:0 42:-0.349908 43:-0.147678 44:-0.131007 45:-0.259907 46:-0.203115 47:-0.0149827 48:-0.00627165 49:0 50:0 51:-0.067164 52:-0.0424623 53:-0.0292777
0:-0.226272 1:-0.159059 2:-0.302755 3:-0.10172 4:0.0890712 5:-0.194956 6:0.0975146 7:0.11061 8:-0.0120766 9:0.0287029 10:-0.755642 11:-0.261548 12:-0.858426 13:-0.181888 14:-0.0122806 15:-0.0648151 16:-0.0206058 17:-0.0544497 18:-0.00199244 19:-0.0712656 20:-0.00831139 21:0 22:-0.0297281 23:-0.140517 24:-0.0989873 25:-0.165733 26:-0.0499679 27:0 28:0 29:-0.00662365 30:-0.0203242 31:-0.00973883 32:-0.028589 33:-0.0499931 34:0 35:-0.206644 36:-0.258039 37:0.0459474 38:0 39:0.155781 40:0 41:0 42:-0.365587 43:0.0182635 44:-0.141425 45:-0.114869 46:-0.200818 47:-0.0152064 48:-0.00712736 49:0 50:0 51:-0.0652173 52:-0.0394804 53:-0.0291585
0:-1.03475 1:-0.0449331 2:-0.0588839 3:-0.0577204 4:0.2447 5:-0.00492624 6:0.0150396 7:-0.0234772 8:-0.0176803 9:-0.158415 10:-0.994011 11:-0.185493 12:-0.853709 13:0.237145 14:-0.0521548 15:0.0287784 16:-0.0650214 17:0.0397558 18:-0.0120732 19:0.231967 20:-0.00458039 21:0 22:-0.0434889 23:0.0817444 24:-0.128981 25:-0.160462 26:-0.0793744 27:0 28:0 29:0.167827 30:-0.0221808 31:-0.00963983 32:-0.0164252 33:-0.0368227 34:0 35:-0.16637 36:-0.21162 37:-0.130469 38:0 39:-0.0211003 40:0 41:0 42:-0.332611 43:-0.146983 44:-0.122319 45:-0.246573 46:-0.22506 47:-0.0151595 48:-0.00293077 49:0 50:0 51:-0.0422911 52:-0.0364811 53:-0.0149654
0:1.76016 1:-0.0872864 2:-0.175175 3:-0.00265374 4:-0.131202 5:0.257154 6:-0.0974715 7:-0.260155 8:-0.000277626 9:0.226661 10:-0.931039 11:-0.275056 12:-0.102695 13:-0.0523058 14:-0.00371202 15:-0.0292906 16:-0.00794822 17:-0.0308147 18:-0.000567493 19:-0.0175976 20:-0.0104324 21:0 22:-0.00881148 23:-0.076689 24:-0.0618612 25:-0.120139 26:-0.0665807 27:0 28:0 29:-0.00164403 30:-0.00969393 31:-0.00261537 32:-0.057489 33:-0.072717 34:0 35:-0.350882 36:-0.3891 37:-0.26652 38:0 39:-0.0188485 40:0 41:0 42:-0.331686 43:-0.183187 44:-0.347259 45:-0.319225 46:-0.413233 47:-0.045851 48:-0.0445203 49:0 50:0 51:0.683525 52:0.622155 53:0.622142'


if [ -n "${_do_unit_test}" ]
then

    timestamp_suffix="$( date --utc '+%s' )123456"

    unit_test_file_name="${_stat_file_prefix}${timestamp_suffix}_$$"

    cat <<< "${m_string_for_unit_test}" > "${unit_test_file_name}"
    touch "${_stat_file_prefix}${END_TAG_SUFFIX}"
    
    MAX_WAIT_DELAY_FOR_FILES=2
    STATS_TARGET_BOSEN_WEIGHTS="${m_final_learning_string_for_unit_test}"

fi

postStatFilesMainLoop
