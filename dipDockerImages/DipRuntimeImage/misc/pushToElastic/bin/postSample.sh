#! /bin/bash

: ${worker_name:=TEST}
: ${distance:=$(( $RANDOM % 100 ))}


format='-Iseconds'


test_time=$( date ${format} )
sample_timestamp=$( date -u '+%Y-%m-%dT%H:%M:%SZ' )
index="dip-distance-"$( date '+%Y-%m-%d' )

body="
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

curl -X POST "localhost:9200/${index}/_doc/" -H 'Content-Type: application/json' -d "${body}"
