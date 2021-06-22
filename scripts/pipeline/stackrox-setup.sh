#!/bin/bash -e

clear

source ~/config.bc-full

oc project pipelines

# Tasks
echo "--------------------------------"
echo "add resources:"
oc apply -f tekton-resources/tools-images/ubi-image.yaml

# Pipelines
echo "--------------------------------"
echo "add pipeline:"
oc apply -f tekton-pipelines/stackrox-pipeline-prevail-2021.yaml 

# Task
echo "--------------------------------"
echo "add task:"
oc apply -f tekton-tasks/aot-stackrox-task.yaml 

# Secrets
echo "--------------------------------"
echo "add secrets:"

export HOST=$(oc get route default-route -n openshift-image-registry --template='{{ .spec.host }}')
docker login -u $(oc whoami) -p $(oc whoami -t) $HOST

oc delete secret generic oir-registrycreds 2>/dev/null

oc create secret generic oir-registrycreds \
--from-file .dockerconfigjson=${XDG_RUNTIME_DIR}/containers/auth.json \
--type kubernetes.io/dockerconfigjson

echo "--------------------------------"


