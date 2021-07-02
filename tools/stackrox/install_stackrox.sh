#!/bin/bash

if [ -f ~/bin/roxctl ] 
then
    echo "stackrox cli allready exists"
else
    echo "bring you the stackrox cli"
    curl https://mirror.openshift.com/pub/rhacs/assets/3.0.62.0/bin/Linux/roxctl -o ~/bin/roxctl     
    chmod 755 ~/bin/roxctl
fi

# Add helm repo
helm repo add rhacs https://mirror.openshift.com/pub/rhacs/charts/
helm search repo -l rhacs/
helm repo update

# Install stackrox
helm install -n stackrox \
--create-namespace stackrox-central-services rhacs/central-services \
--set imagePullSecrets.allowNone=true \
--set central.resources.requests.memory="2Gi" \
--set central.resources.requests.cpu="100m" \
--set scanner.resources.requests.memory="1000Mi" \
--set scanner.resources.requests.cpu="100m"

# TODO
# Wait for stackrox to come alive
# install stackrox-secured-cluster-services