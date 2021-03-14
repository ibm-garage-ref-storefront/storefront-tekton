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

oc policy add-role-to-user system:image-puller developer
