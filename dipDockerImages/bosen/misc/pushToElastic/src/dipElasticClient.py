import sys

import logging
import argparse

from datetime import datetime
from elasticsearch import Elasticsearch

# by default we connect to localhost:9200
es = Elasticsearch()

# create an index in elasticsearch, ignore status code 400 (index already exists)
es.indices.create(index='my-index', ignore=400)
{'acknowledged': True, 'shards_acknowledged': True, 'index': 'my-index'}

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
    
def getElasticSampleIndex ():
    
    n = datetime.now()
    tt = n.timetuple()
    





# {'_index': 'my-index',
#  '_type': '_doc',
#  '_id': '42',
#  '_version': 1,
#  'result': 'created',
#  '_shards': {'total': 2, 'successful': 1, 'failed': 0},
#  '_seq_no': 0,
#  '_primary_term': 1}

# # but not deserialized
# es.get(index="my-index", id=42)['_source']


if __name__ == "__main__":
    # get trace logger and set level
    tracer = logging.getLogger("elasticsearch.trace")
    tracer.setLevel(logging.INFO)
    tracer.addHandler(logging.FileHandler("/tmp/es_trace.log"))

    parser = argparse.ArgumentParser()
    parser.add_argument(
        "-H",
        "--host",
        action="store",
        default="s-ku2raph:9200",
        help="The elasticsearch host you wish to connect to. (Default: s-ku2raph:9200)",
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
    

    index = getElasticSampleIndex()
    body = getElasticDataBody("test worker", 12.7)
    
    es.index(index=index, body=body)
    
    sys.exit(1)


    # we load the repo and all commits
    load_repo(es, path=args.path)

    # run the bulk operations
    success, _ = bulk(es, UPDATES, index="git")
    print("Performed %d actions" % success)

    # we can now make docs visible for searching
    es.indices.refresh(index="git")

    # now we can retrieve the documents
    initial_commit = es.get(index="git", id="20fbba1230cabbc0f4644f917c6c2be52b8a63e8")
    print(
        "%s: %s" % (initial_commit["_id"], initial_commit["_source"]["committed_date"])
    )

    # and now we can count the documents
    print(es.count(index="git")["count"], "documents in index")