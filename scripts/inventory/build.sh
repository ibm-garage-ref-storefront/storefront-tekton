#!/bin/bash

echo "building inventory image"

if [ $1 == "QUAY" ]; then
   oc create -f $HERE/tekton-pipeline-run/inventory-run-quay.yaml
else
   oc create -f $HERE/tekton-pipeline-run/inventory-run-auto.yaml
fi

#oc apply -f $HERE/tekton-pipeline-run/inventory-run.yaml


#Note: the inventory-run-auto.yaml will generate a name for the pipelinerun, it MUST use oc create/
