import sys

import logging
import argparse

from datetime import datetime
from elasticsearch import Elasticsearch

import weightMatrixDistance

# # by default we connect to localhost:9200
# es = Elasticsearch()
# 
# # create an index in elasticsearch, ignore status code 400 (index already exists)
# es.indices.create(index='my-index', ignore=400)
# {'acknowledged': True, 'shards_acknowledged': True, 'index': 'my-index'}

# datetimes will be serialized

# globals

launch_timestamp_dt = datetime.utcnow()

def getElasticSampleIndex (sample_dt, index_prefix='dip-distance-'):
    
    index_suffix = '{:%Y-%m-%d}'.format(sample_dt)
    
    index = index_prefix + index_suffix
    
    return index

def getElasticTimestamp (dt_value):
    
    # SEE: https://www.elastic.co/guide/en/elasticsearch/reference/current/mapping-date-format.html#built-in-date-formats
    # Used format: strict_date_time (yyyy-MM-dd'T'HH:mm:ss.SSSZZ)
    
    iso_dt_value = dt_value.isoformat(sep='T', timespec='milliseconds')
    
    timestamp = iso_dt_value + 'ZZ'
    
    return timestamp


def getElasticSampleDataBody (worker_name, distance, sample_dt, comment="no comment!"):
    
    global launch_timestamp_dt
    
    body={
       "worker_name": worker_name,
       "distance": distance,
       "label": "label for " + worker_name,
       "sample_date": "is this field useful??",
       "test_time": launch_timestamp_dt,
       "comment": comment,
       "@timestamp": getElasticTimestamp(sample_dt)
    }
    
    return body

def createElasticsearchIndexWithMapping (es, index):
    
    create_index_body = {
    "settings": {
        # just one shard, no replicas for testing
        "number_of_shards": 1,
        "number_of_replicas": 0,
    },
         
    "mappings": {
        "properties": {
            "@timestamp": {
                "type": "date"
                },
            "distance": {
                "type": "float"
                },
            "worker_name": {
                "type": "text",
                "fields": {
                    "keyword": {
                        "type": "keyword",
                        "ignore_above": 64
                        }
                    }
                }                             
#                 "comment": {
#                     "type": "text",
#                     "fields": {
#                         "keyword": {
#                             "type": "keyword",
#                             "ignore_above": 256
#                             }
#                         }
#                     },
#                 "label": {
#                     "type": "text",
#                     "fields": {
#                         "keyword": {
#                             "type": "keyword",
#                             "ignore_above": 256
#                             }
#                         }
#                     },
#                 "sample_date": {
#                     "type": "text",
#                     "fields": {
#                         "keyword": {
#                             "type": "keyword",
#                             "ignore_above": 256
#                             }
#                         }
#                     },
#                 "test_time": {
#                     "type": "date"
#                      },
            }
        }
    }
        
    es.indices.create(index=index, body=create_index_body)


def putDistanceToEs (es, index_prefix, worker_name, distance, sample_dt):
    
    
 
    index = getElasticSampleIndex(sample_dt, index_prefix)
    index_exists = es.indices.exists(index=index)
    if not index_exists:
        # if it does not exist, create is previouly to ensure correct mapping
        createElasticsearchIndexWithMapping (es, index)
      
    body = getElasticSampleDataBody(worker_name, distance, sample_dt)
    
    es.index(index=index, body=body)


if __name__ == "__main__":
    # get trace logger and set level
    tracer = logging.getLogger("elasticsearch.trace")
    tracer.setLevel(logging.INFO)
    tracer.addHandler(logging.FileHandler("./es_trace.log"))

    parser = argparse.ArgumentParser()
    
    parser.add_argument(
        "-H",
        "--elasticsearch_url",
        action="store",
        required=True,
        help="The elasticsearch host you wish to connect to.",
    )
    
#     parser.add_argument(
#         "-d",
#         "--distance",
#         action="store",
#         dest="distance",
#         type=float,
#         required=True,
#         help="The new distance to record.",
#     )
    
    parser.add_argument(
        "-s",
        "--utc_timestamp_since_epoch",
        action="store",
        type=float,
        dest="timestamp",
        required=False,
        help="The UTC timestamp to be used for inserting the new value. This value should be acceptable float for the Pyhton datetime.fromtimestamp function."
    )
    
    parser.add_argument(
        "-w",
        "--worker_name",
        action="store",
        dest="worker_name",
        default="test_worker",
        help="The name of the client."
    )
    
    parser.add_argument(
        "-f",
        "--feature_dim",
        action="store",
        dest="feature_dim",
        required=True,
        help="Number of feature in input weight matrix."
    )
    
    parser.add_argument(
        "-l",
        "--num_labels",
        action="store",
        dest="num_labels",
        required=True,
        help="Number of labels in input weight matrix."
    )
    
    parser.add_argument(
        "-m",
        "--minibatch_weight_matrix",
        action="store",
        dest="minibatch_weight_matrix",
        required=True,
        help="Raw dense matrix generated during minibatch."
    )
    
    parser.add_argument(
        "-W",
        "--target_weight_matrix",
        action="store",
        dest="target_weight_matrix",
        required=True,
        help="Raw dense final matrix the computation should converge to."
    )                  
    
    parser.add_argument(
        "-t",
        "--timeout",
        type=float,
        action="store",
        dest="timeout",
        default="1.0",
        help="Timeout for interactions with Elasticsearch (Not Yet Implemented)."
    )    
        
    args = parser.parse_args()

    # instantiate es client, connects to localhost:9200 by default
    es = Elasticsearch(args.host)
    
    if args.timestamp:
        sample_dt=datetime.utcfromtimestamp(args.timestamp)
    else:
        sample_dt=launch_timestamp_dt
        
    distance = weightMatrixDistance.distance_between(x_raw_dense_matrix=args.minibatch_weight_matrix,
                                                      target_raw_dense_matrix=args.target_weight_matrix,
                                                      num_labels=args.num_labels,
                                                      feature_dim=args.feature_dim)
            
    putDistanceToEs (es, index_prefix=args.index_prefix, worker_name=args.worker_name, distance=distance, sample_dt=sample_dt)

    sys.exit(0)
