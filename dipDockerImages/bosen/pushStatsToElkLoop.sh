#! /bin/bash

HERE=$( dirname "$0" )

: ${stat_file_prefix:="/tmp/minibatch_stats_"}
: ${PYTHON="${HERE}/misc/pushToElastic/.venv/bin/python3.6"}
: ${PYTHON_MAIN:="${HERE}/misc/pushToElastic/src/dipElasticClient.py"}

: ${MAX_WAIT_DELAY_FOR_FILES:=60}

_not_ended=true
_nb_sleep_done=0

while ${_not_ended}
do

    stat_file_list=$(
	ls \
	    -1 \
	    -f \
	    "${stat_file_prefix}"* \
	| \
	    grep -v "${stat_file_prefix}__END__"
    )
    if [ -z "${stat_file_list}" ]
    then

	if [ -f "${stat_file_prefix}END" ]
	then
	    rm "${stat_file_prefix}END"
	    exit 0
	else
	    if [ ${_nb_sleep_done} -ge "${MAX_WAIT_DELAY_FOR_FILES}" ]
	    then
		exit 1
	    else
		sleep 1s
		_nb_sleep_done=$(( ${_nb_sleep_done} + 1 ))
	    fi
	fi

    else
	ordered_stat_file_list=$(
	    prefix_len=${#stat_file_prefix}
	    sort_match_position=$(( ${prefix_len} + 1 ))
	    sort -n --key=1.${sort_match_position} <<< "${stat_file_list}"
	)

	for stat_file in ${ordered_stat_file_list}
	do
	    #
	    # prepare input
	    #
	    num_labels=$(
		sed -n 1p "${stat_file}" | cut --fields=2
	    )
	    feature_dim=$(
		sed -n 2p "${stat_file}" | cut --fields=2
	    )

	    matrix_with_features=$(
		sed -n '3,$p' "${stat_file}"
            )

	    matrix_without_features=$(
		sed -e 's/[0-9][0-9]*://g' <<< "${matrix_with_features}"
	    )

	    # get timestamp from file name
	    stat_file_suffix="${stat_file#${stat_file_prefix}}"
	    
	    file_timestamp_from_epoch_ns="${stat_file_suffix%_*}"
	    thread_id="${stat_file_suffix#*_}"

	    #
	    # convert timestamp to stuitable string
	    #
	    s_part="${file_timestamp_from_epoch_ns::-6}"
	    ns_part="${file_timestamp_from_epoch_ns: -6}"
	    utc_timestamp_since_epoch="${s_part}.${ns_part}"

	    hm_timestamp=$(
		date "--date=@${utc_timestamp_since_epoch}" --utc '+%Y-%m-%dT%H:%M:%S.%NZZ'
	    )

	    elastic_timestamp=${utc_timestamp_since_epoch}

	    ${PYTHON} ${PYTHON_MAIN} \
		--host=http://s-eunuc:9200 \
		--index_prefix=test-dip-distance- \
		--utc_timestamp_since_epoch="${elastic_timestamp}" \
		--worker_name="thread_${thread_id}" \
		\
		--distance=3.5

	    rm "${stat_file}"

	done
    fi
done
