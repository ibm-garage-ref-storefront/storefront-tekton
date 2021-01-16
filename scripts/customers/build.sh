#!/bin/bash

echo "build customer microservice"

if [ $1 == "QUAY" ]; then
   oc create -f $HERE/tekton-pipeline-run/customer-run-quay.yaml
else
   oc create -f $HERE/tekton-pipeline-run/customer-run-auto.yaml
fi

#NOTE: use "oc create for a plr that uses a generated name"
