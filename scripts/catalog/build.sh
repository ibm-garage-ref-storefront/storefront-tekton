#!/bin/bash

echo "build catalog"

if [ $1 == "QUAY" ]; then
   oc create -f $HERE/tekton-pipeline-run/catalog-run-quay.yaml
else
   oc create -f $HERE/tekton-pipeline-run/catalog-run-auto.yaml
fi

#NOTE: use "oc create for a plr that uses a generated name"
