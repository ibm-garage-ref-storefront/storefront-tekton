#!/bin/bash

echo "build orders"

if [ $1 == "QUAY" ]; then
   oc create -f $HERE/tekton-pipeline-run/orders-run-quay.yaml 
else
   oc create -f $HERE/tekton-pipeline-run/orders-run-auto.yaml   
fi