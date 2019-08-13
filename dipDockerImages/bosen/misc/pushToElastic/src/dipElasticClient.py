import sys

import logging
import argparse

from datetime import datetime
from elasticsearch import Elasticsearch

# # by default we connect to localhost:9200
# es = Elasticsearch()
# 
# # create an index in elasticsearch, ignore status code 400 (index already exists)
# es.indices.create(index='my-index', ignore=400)
# {'acknowledged': True, 'shards_acknowledged': True, 'index': 'my-index'}

# datetimes will be serialized


def getElasticSampleDataBody (worker_name, distance, sample_date="not set", comment="no comment!"):
    
    body={
       "worker_name": worker_name,
       "distance": distance,
       "label": "label for " + worker_name,
       "sample_date": sample_date,
       "test_time": datetime.now(),
       "comment": comment,
       "@timestamp": datetime.now()
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


def getElasticSampleIndex (index_prefix='dip-distance-'):
    
    now = datetime.now()
   
    index_suffix = '{:%Y-%m-%d}'.format(now)
    
    index = index_prefix + index_suffix
    
    return index

    

def putDistanceToEs (es, worker_name, distance):
    
    
 
    index = getElasticSampleIndex()
    index_exists = es.indices.exists(index=index)
    if not index_exists:
        # if it does not exist, create is previouly to ensure correct mapping
        createElasticsearchIndexWithMapping (es, index)
      
    body = getElasticSampleDataBody(worker_name, distance)
    
    es.index(index=index, body=body)


if __name__ == "__main__":
    # get trace logger and set level
    tracer = logging.getLogger("elasticsearch.trace")
    tracer.setLevel(logging.INFO)
    tracer.addHandler(logging.FileHandler("./es_trace.log"))

    parser = argparse.ArgumentParser()
    
    parser.add_argument(
        "-H",
        "--host",
        action="store",
        default="s-ku2raph:9200",
        help="The elasticsearch host you wish to connect to. (Default: s-ku2raph:9200)",
    )
    
    parser.add_argument(
        "-i",
        "--index_prefix",
        action="store",
        default="dip-distance-",
        help="The index prefix used to insert new records. (Default: dip-distance-)",
    )
    
    parser.add_argument(
        "-d",
        "--distance",
        action="store",
        name="distance",
        type=float,
        required=True,
        help="The new distance to record.",
    )
    
    parser.add_argument(
        "-t",
        "--timestamp",
        action="store",
        name="timestamp",
        required=False,
        help="The timestamp to be used for inserting the new value. Should be of form yyyy-MM-dd'T'HH:mm:ss.SSSZZ."
    )    
        
#     parser.add_argument(
#         "-p",
#         "--path",
#         action="store",
#         default=None,
#         help="Path to git repo. Commits used as data to load into Elasticsearch. (Default: None)",
#     )

    args = parser.parse_args()

    # instantiate es client, connects to localhost:9200 by default
    es = Elasticsearch(args.host)
    
    putDistanceToEs (es, "test_worker", args.distance)

    sys.exit(0)
