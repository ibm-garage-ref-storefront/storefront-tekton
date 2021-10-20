#!/bin/bash -e

export HOST=$(oc get route default-route -n openshift-image-registry --template='{{ .spec.host }}')
docker login -u $(oc whoami) -p $(oc whoami -t) $HOST

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

#oc create secret generic oir-registrycreds \
#--from-file .dockerconfigjson=${XDG_RUNTIME_DIR}/containers/auth.json \
#--type kubernetes.io/dockerconfigjson

oc extract secret/oir-registrycreds --to=-
