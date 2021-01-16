#!/bin/bash

echo "setup catalog"

# Start an Elasticsearch Container
#docker run --name catalogelasticsearch \
#      -e "discovery.type=single-node" \
#      -p 9200:9200 \
#      -p 9300:9300 \
#      -d docker.elastic.co/elasticsearch/elasticsearch:6.3.2

oc new-app --name=catalogelasticsearch \
   -e "discovery.type=single-node" \
   --docker-image=docker.elastic.co/elasticsearch/elasticsearch:6.3.2 \
   -l app.kubernetes.io/part-of=catalog-subsystem

# Not recommended
#oc expose svc catalogelasticsearch \
#  -l app.kubernetes.io/part-of=catalog-subsystem