#!/bin/bash

echo "build web frontend"

if [ $1 == "QUAY" ]; then
   oc create -f $HERE/tekton-pipeline-run/web-run-quay.yaml
else
   oc create -f $HERE/tekton-pipeline-run/web-run-auto.yaml
fi
