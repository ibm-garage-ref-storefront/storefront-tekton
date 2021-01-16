#!/bin/bash

echo "deploy catalog"

# appsody run --docker-options "\
# -e ELASTIC_CLUSTER_NAME=docker-cluster \
# -e ELASTIC_NODE_URL=host.docker.internal:9300 \
# -e INVENTORY_URL=http://docker.for.mac.localhost:8081/micro/inventory"

#$ oc get svc
#NAME                   TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)                      AGE
#catalogelasticsearch   ClusterIP   172.21.175.126   <none>        9200/TCP,9300/TCP            16m
#inventory              ClusterIP   172.21.49.223    <none>        8080/TCP,8443/TCP,8778/TCP   37m
#inventorymysql         ClusterIP   172.21.245.138   <none>        3306/TCP                     68m

oc new-app --name=catalog-ms-spring \
   -e ELASTIC_CLUSTER_NAME=docker-cluster \
   -e ELASTIC_NODE_URL=catalogelasticsearch:9300 \
   -e INVENTORY_URL=http://inventory-ms-spring:8080/micro/inventory \
   --image-stream=catalog \
   -l app.kubernetes.io/part-of=catalog-subsystem

# Reduce attack surface
#oc expose svc/catalog-ms-spring \
#  -l app.kubernetes.io/part-of=catalog-subsystem