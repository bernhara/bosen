#! /bin/bash

: ${worker_name:=TEST}
: ${distance:=$(( $RANDOM % 100 ))}


format='-Iseconds'


record_lines=""

for s in $( seq 3 )
do

    test_time=$( date ${format} )
    sample_timestamp=$( date -u '+%Y-%m-%dT%H:%M:%SZ' )
    index="test-dip-distance-"$( date '+%Y-%m-%d' )
    
    record="
{
   \"worker_name\": \"${worker_name}\",
   \"distance\": ${distance},
   \"label\": \"test $$\",
   \"sample_date\": \"${sample_timestamp}\",
   \"test_time\": \"${test_time}\",
   \"comment\": \"none\",
   \"@timestamp\": \"${sample_timestamp}\"
}
"

    new_record_as_single_line=$(
	tr -d '\n' <<< "${record}"
    )

    record_lines="${record_lines}{ \"index\": {} }
${new_record_as_single_line}
"

    sleep 3
done

binary_body="${record_lines}"

curl -X POST "s-freyming:9200/${index}/_doc/_bulk" -H 'Content-Type: application/x-ndjson' --data-binary "${binary_body}"
