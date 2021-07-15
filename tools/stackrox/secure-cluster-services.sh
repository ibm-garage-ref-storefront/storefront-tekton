#!/usr/bin/env bash

set -e
set +x

# Set any variables for later use
roxVer=3.0.62.0
clusterName=prevail-cluster

# Clear the screen
clear

# Check roxctl exists
roxctl_check=$(which roxctl)
if [ -z "$roxctl_check" ]; then
    echo "Installing the stackrox cli"
    curl https://mirror.openshift.com/pub/rhacs/assets/$roxVer/bin/Linux/roxctl -o ~/bin/roxctl     
    chmod 755 ~/bin/roxctl
else
    echo "Stackrox cli already exists, located at $roxctl_check and version is $(roxctl version)"
fi

# Check oc exists
oc_check=$(which oc)
if [ -z "$oc_check" ]; then
  printf "\nERROR! This script requires oc to run. Please install it.\n"
  exit 1
fi

# Check helm exists
helm_check=$(which helm)
if [ -z "$helm_check" ]; then
  printf "\nERROR! This script requires helm to run. Please install it.\n"
  exit 1
fi

# List the pods in stackrox namespace
echo "stackrox state:"
oc get po -n stackrox
echo ""

# Check the stackrox deployments are happy.
# There might be some overlap between this and the 'oc get pod' check, so it's belt and braces...
oc get deploy -n stackrox |  sed -n '1!p' | while read line; do
  podReady=$(echo $line | awk '{print $2}' | awk -F"/" '{print $1}')
  podTotal=$(echo $line | awk '{print $2}' | awk -F"/" '{print $2}')
  if [ "$podReady" != "$podTotal" ]; then
    echo "Please check 'oc get deploy -n stackrox' as some pods are not in a ready state"
    exit 1
  fi
done

# List pods - then filter for any pods that aren't in running state.
SR_STATE=$(oc get po -n stackrox | grep -v Running | wc -l)

# If only 1 line was returned, it's the header line and so all containers must be in running state
if [ ${SR_STATE} -eq 1 ] ; then
    echo "StackRox is up"
else
    echo "StackRox initial setup is not complete yet, please try again later"
fi
echo ""

# Create the port-forward to stackrox, running in the background
echo "start port-forward to stackrox"
oc port-forward svc/central -n stackrox 8443:443 > /dev/null 2>&1 &
echo ""
sleep 5

# Display the password back to the screen
echo "StackRox password is:"
helm get notes stackrox-central-services -n stackrox | grep password -A 2 | sed -n 4p | sed 's/^ *//g'
echo ""

# Login to StackRox, generate the API_TOKEN and pass it to this script
echo "Please login to https://localhost:8443 and make the ROX_API_TOKEN"
echo ""
echo "Enter ROX_API_TOKEN hint: role admin"
read ROX_API_TOKEN
echo "ROX_API_TOKEN:" $ROX_API_TOKEN
echo ""

export ROX_API_TOKEN=$ROX_API_TOKEN
export ROX_CENTRAL_ADDRESS=localhost:8443

# Generate the bundle from StackRox
roxctl -e "$ROX_CENTRAL_ADDRESS" central init-bundles generate $clusterName --output cluster-init-bundle.yaml --insecure-skip-tls-verify

# Check RHACS helm repo has been added locally
helm_repo_check=$(helm repo list | grep rhacs)
if [ -z "$helm_repo_check" ]; then
    helm repo add rhacs https://mirror.openshift.com/pub/rhacs/charts/
fi

# Use helm to deploy the bundle
helm install -n stackrox stackrox-secured-cluster-services rhacs/secured-cluster-services -f cluster-init-bundle.yaml --set centralEndpoint=central.stackrox:443 --set clusterName=$clusterName --set imagePullSecrets.allowNone=true

# Bring tunnel to foreground
echo "end port-forward to stackrox"
tunnel=$(ps -ef | grep port-forward | grep stackrox | awk ' { print $2 } ')
echo $tunnel
kill $tunnel

# Name the cluster-init-bundle with the current time
NOW=$(date +%Y-%m-%d)
mv cluster-init-bundle.yaml cluster-init-bundle.yaml-${NOW}
