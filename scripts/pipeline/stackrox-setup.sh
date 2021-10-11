#!/usr/bin/env bash

set -e

clear

source ~/config.bc-full

oc project pipelines

# Resources
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
#export HOST=$(oc get route default-route -n openshift-image-registry --template='{{ .spec.host }}')
#docker login -u $(oc whoami) -p $(oc whoami -t) $HOST
#oc delete secret generic oir-registrycreds 2>/dev/null
#oc create secret generic oir-registrycreds \
#--from-file .dockerconfigjson=${XDG_RUNTIME_DIR}/containers/auth.json \
#--type kubernetes.io/dockerconfigjson

# Access to OpenShift
export HOST=$(oc get route default-route -n openshift-image-registry --template='{{ .spec.host }}')
docker login -u $(oc whoami) -p $(oc whoami -t) $HOST ### maybe comment this line out, unless something else requires the login to have occurred? ###

# find os to ensure correct base64 command syntax
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    mycommand="base64 -w 0"  
elif [[ "$OSTYPE" == "darwin"* ]]; then
    mycommand="base64 -b 0"
else
    printf "\nOS-TYPE is not Linux or Mac, so attempting base64 single-line command. Please investigate if it fails.\n"
    # For some Mac's we might need to use "/usr/bin/base64 -b 0"
    mycommand="base64 -w 0"
fi

# create auth file
cat <<EOF > ./auth.json
{
        "auths": {
                "$HOST": {
                        "auth": "$(echo -n $(oc whoami):$(oc whoami -t) | $mycommand)"
                }
        }
}
EOF
oc delete secret generic oir-registrycreds 2>/dev/null
oc create secret generic oir-registrycreds \
--from-file .dockerconfigjson=./auth.json \
--type kubernetes.io/dockerconfigjson

# Access to StackRox
oc delete secret generic stackrox-details 2>/dev/null
oc create secret generic stackrox-details --from-literal ROX_SECURE_TOKEN=${STACKROX_API_TOKEN}
# cp tools/stackrox/stackrock-details.yaml /tmp/stackrox-details.yaml
# sed 's|'REPLACE_WITH_STACKROX_API_TOKEN'|'"${STACKROX_API_TOKEN}"'|g' /tmp/stackrox-details.yaml
# oc apply -f /tmp/stackrox-details.yaml
# rm /tmp/stackrox-details.yaml

echo "--------------------------------"
