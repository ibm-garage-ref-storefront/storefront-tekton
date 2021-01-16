#!/bin/bash

echo "build auth service for OAuth 2.0 authentication"

if [ $1 == "QUAY" ]; then
   oc create -f $HERE/tekton-pipeline-run/auth-run-quay.yaml
else
   oc create -f $HERE/tekton-pipeline-run/auth-run-auto.yaml
fi

#NOTE: use "oc create for a plr that uses a generated name"
