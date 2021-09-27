#!/bin/bash -e

clear

source ~/config.bc-full

oc project pipelines

# Tasks
echo "--------------------------------"
echo "add resources:"
oc apply -f tekton-resources/tools-images/ubi-image.yaml
oc apply -f tekton-resources/customer-ms/customer-ms-spring-fix-version.yaml 

# Pipelines
echo "--------------------------------"
echo "add pipeline:"
oc apply -f tekton-pipelines/stackrox-pipeline-prevail-2021.yaml 

# Task
echo "--------------------------------"
echo "add task:"
#oc apply -f tekton-tasks/aot-stackrox-task.yaml 
oc apply -f tekton-tasks/aot-stackrox-task-experimental.yaml 

# Secrets
echo "--------------------------------"
echo "add secrets:"

# Access to OpenShift
export HOST=$(oc get route default-route -n openshift-image-registry --template='{{ .spec.host }}')
docker login -u $(oc whoami) -p $(oc whoami -t) $HOST
oc delete secret generic oir-registrycreds 2>/dev/null
oc create secret generic oir-registrycreds \
--from-file .dockerconfigjson=${XDG_RUNTIME_DIR}/containers/auth.json \
--type kubernetes.io/dockerconfigjson

# Access to StackRox
oc delete secret generic stackrox-details 2>/dev/null
cp tools/stackrox/stackrock-details.yaml /tmp/stackrox-details.yaml
sed -i "s/REPLACE_WITH_STACKROX_API_TOKEN/${STACKROX_API_TOKEN}/g" /tmp/stackrox-details.yaml
oc apply -f /tmp/stackrox-details.yaml
rm /tmp/stackrox-details.yaml

echo "--------------------------------"
