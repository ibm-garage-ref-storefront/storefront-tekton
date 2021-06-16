#!/bin/bash

oc project tools

# alternatives are dockerhub and openshift internal registry

export OCP_USER=$(oc whoami)
export OCP_TOKEN=$(oc whoami -t)

oc adm policy add-role-to-user system:registry $OCP_USER
oc adm policy add-role-to-user system:image-builder $OCP_USER

# https://docs.openshift.com/container-platform/4.3/registry/securing-exposing-registry.html
oc patch configs.imageregistry.operator.openshift.io/cluster --patch '{"spec":{"defaultRoute":true}}' --type=merge

echo "sleep 30 seconds to give the imageregistry operator time to re-adjust"
sleep 30

export HOST=$(oc get route default-route -n openshift-image-registry --template='{{ .spec.host }}')
docker login -u $(oc whoami) -p $(oc whoami -t) $HOST

docker build -t stackrox-ubi:8.0 .
docker tag stackrox-ubi:8.0 $HOST/tools/stackrox-ubi:8.0
docker push $HOST/tools/stackrox-ubi:8.0

oc get is

# as of now the tekton task can use image-registry.openshift-image-registry.svc:5000/tools/jmeter-prevail2020

# TODO:
#oc policy add-role-to-group -n tools system:image-puller system:serviceaccounts:app_project
