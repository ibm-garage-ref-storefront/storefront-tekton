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

echo "start port-forward to stackrox"
oc port-forward svc/central -n stackrox 8443:443 > /dev/null 2>&1 &
echo ""
sleep 5

helm get notes stackrox-central-services -n stackrox | grep -A3 "initial setup"

echo "login to https://localhost:8443 and make the ROX_API_TOKEN”"

echo “Enter ROX_API_TOKEN (role admin)”
read ROX_API_TOKEN
echo “ROX_API_TOKEN:” $ROX_API_TOKEN

export ROX_API_TOKEN=$ROX_API_TOKEN
export ROX_CENTRAL_ADDRESS=localhost:8443

roxctl -e "$ROX_CENTRAL_ADDRESS" central init-bundles generate prevail-cluster --output cluster-init-bundle.yaml --insecure-skip-tls-verify

helm install -n stackrox stackrox-secured-cluster-services rhacs/secured-cluster-services -f cluster-init-bundle.yaml --set centralEndpoint=central.stackrox:443 --set clusterName=prevail-cluster --set imagePullSecrets.allowNone=true


# bring tunnel to foreground
echo "end port-forward to stackrox"
tunnel=$(ps -ef | grep port-forward | grep stackrox | awk ' { print $2 } ')
echo $tunnel
kill $tunnel