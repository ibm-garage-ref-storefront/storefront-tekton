#!/bin/bash

clear

if [ -f ~/bin/roxctl ] 
then
    echo "stackrox cli allready exists"
else
    echo "bring you the stackrox cli"
    curl https://mirror.openshift.com/pub/rhacs/assets/3.0.62.0/bin/Linux/roxctl -o ~/bin/roxctl     
    chmod 755 ~/bin/roxctl
fi
echo ""

echo "stackrox state:"
oc get po -n stackrox
echo ""

SR_STATE=$(oc get po -n stackrox | grep Running | wc -l)

if [ ${SR_STATE} -eq 4 ] ; then
    echo "StackRox is up"
else
    echo "StackRox initial setup is not complete yet, please try again later"
fi
echo ""


helm get notes stackrox-central-services -n stackrox | grep -A3 "initial setup"
