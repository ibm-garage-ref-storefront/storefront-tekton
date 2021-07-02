#!/bin/bash

if [ -f ~/bin/roxctl ] 
then
    echo "stackrox cli allready exists"
else
    echo "bring you the stackrox cli"
    curl https://mirror.openshift.com/pub/rhacs/assets/3.0.62.0/bin/Linux/roxctl -o ~/bin/roxctl     
    chmod 755 ~/bin/roxctl
fi

echo "stackrox state:"
oc get po -n stackrox

helm get notes stackrox-central-services -n stackrox | grep -A3 "initial setup"
