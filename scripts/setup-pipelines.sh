#!/bin/bash
source ~/config

export HERE=${PWD}
echo "Working from $HERE"

source ~/config

oc new-project pipelines

echo "temporary artifacts are stored in: " /tmp/$WORKSPACE

if [ -d /tmp/$WORKSPACE ] 
then
    echo "Directory /tmp/$WORKSPACE allready exists, cleaning up." 
    rm -rfi /tmp/$WORKSPACE
    mkdir -pv /tmp/$WORKSPACE
else
    echo "Directory /tmp/$WORKSPACE does not exists."
    mkdir -pv /tmp/$WORKSPACE    
fi

echo "-----------------------------------------------------------------------------"
bash $HERE/scripts/pipeline/setup.sh
echo ""


# Setup permissions
oc project pipelines
#oc policy add-role-to-user system:image-puller developer

# Give pipelines the permission to build images for full-bc
oc new-project full-bc
oc project full-bc
#oc policy add-role-to-group system:image-pusher system:serviceaccounts:pipelines
#oc policy add-role-to-user system:image-pusher system:serviceaccount:pipelines:appsody-sa
oc policy add-role-to-user edit system:serviceaccount:pipelines:appsody-sa
#oc describe rolebinding system:image-pusher -n full-bc

# Give developer permission to skopeo images out (intention: to icr and trivy).
oc policy add-role-to-user system:image-puller developer

oc project pipelines