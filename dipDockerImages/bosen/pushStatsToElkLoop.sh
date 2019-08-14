#! /bin/bash

HERE=$( dirname "$0" )

: ${DIP_minibatch_weight_dump_file_prefix:="/tmp/minibatch_stats_"}
: ${PYTHON="${HERE}/misc/pushToElastic/.venv/bin/python3.6"}
: ${ZZ:="${HERE}/misc/pushToElastic/src/dipElasticClient.py"}

: ${WORKER_NAME:="$0"}

_not_ended=true

while ${_not_ended}
do

    stat_file_list=$(
	ls -1 "${DIP_minibatch_weight_dump_file_prefix}"*
    )
    if [ -z "${stat_file_list}" ]
    then
	sleep 1s
    else
	ordered_stat_file_list=$(
	    sort -n <<< ${stat_file_list}
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


	    ${PYTHON} ${ZZ} \
		--host=http://s-eunuc:9200 \
		--index_prefix=test-dip-distance- \
		--timestamp="${file_timestamp}" \
		--worker_name="${WORKER_NAME} \
		\
		--distance=3.5
	    
		
	    
	done

done
