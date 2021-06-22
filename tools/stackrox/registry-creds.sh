#!/bin/bash -e

export HOST=$(oc get route default-route -n openshift-image-registry --template='{{ .spec.host }}')
docker login -u $(oc whoami) -p $(oc whoami -t) $HOST

#oc create secret generic registrycreds \
#--from-file .dockerconfigjson=${XDG_RUNTIME_DIR}/containers/auth.json \
#--type kubernetes.io/dockerconfigjson

oc create secret generic oir-registrycreds \
--from-file .dockerconfigjson=${XDG_RUNTIME_DIR}/containers/auth.json \
--type kubernetes.io/dockerconfigjson

oc extract secret/oir-registrycreds --to=-