#!/usr/bin/env bash

#set -e # look to handle errors within script
set +x

# Set any variables for later use
roxVer=3.0.62.0
clusterName=prevail-cluster
HOMEDIRBIN=false
CLUSTERNOTREADY=false

# Clear the screen
clear

# Check curl exists
curl_check=$(command -v curl)
if [ -z "$curl_check" ]; then
  printf "\nERROR! This script requires curl to run. Please install it.\n"
  exit 1
fi

# Check oc exists
oc_check=$(command -v oc)
if [ -z "$oc_check" ]; then
  printf "\nERROR! This script requires oc to run. Please install it.\n"
  exit 1
fi

# Check helm exists
helm_check=$(command -v helm)
helm_check=$(command -v helm)
if [ -z "$helm_check" ]; then
  printf "\nERROR! This script requires helm to run. Please install it.\n"
  exit 1
fi

# Check roxctl exists - try to download if it doesn't or if it can be updated
printf "\nChecking if roxctl exists.\n"
roxctl_check=$(command -v roxctl)
if [ -z "$roxctl_check" ]; then
    if [ ! -f ~/bin/roxctl ]; then
      echo "roxctl doesn't exist; installing the stackrox cli."
	  if [ ! -d "~/bin" ]; then
	    mkdir ~/bin
	  fi
      curl https://mirror.openshift.com/pub/rhacs/assets/$roxVer/bin/Linux/roxctl -o ~/bin/roxctl
      RC=$?
      if [ "$RC" -eq 0 ]; then
        chmod 755 ~/bin/roxctl
	    HOMEDIRBIN=true
        RC=$?
        if [ "$RC" -ne 0 ]; then
          echo "Error performing 'chmod' please check permissions."
          exit 1
        fi
      else
        echo "Download could not be performed - please investigate."
        exit 1
      fi
    fi
else
    roxInstalledVer=$(roxctl version)
    sortedVal=$(printf "$roxVer\n$roxInstalledVer" | sort -V -r | sed -n 1p)
    echo "Stackrox cli already exists, located at $roxctl_check and version is $roxInstalledVer."
	if [ -f ~/bin/roxctl ]; then
	  HOMEDIRBIN=true
	fi
    if [[ "$roxInstalledVer" == "$sortedVal" ]]; then
      echo "Installed roxctl version meets or exceeds requirement."
    else
      echo "Need to upgrade roxctl."
      curl https://mirror.openshift.com/pub/rhacs/assets/$roxVer/bin/Linux/roxctl -o $roxctl_check
      RC=$?
      if [ "$RC" -eq 0 ]; then
        chmod 755 $roxctl_check
        RC=$?
        if [ "$RC" -ne 0 ]; then
          echo "Error performing 'chmod' please check permissions."
          exit 1
        fi
      else
        echo "Download could not be performed - please investigate."
        exit 1
      fi
    fi
fi

# List the pods in stackrox namespace
if [ ! oc get po -n stackrox >> /dev/null 2>&1 ]; then
  printf "\nCheck OpenShift user permissions - could not list pods.\n"
  exit 1
else
  echo ""
  echo "Stackrox state:"
  oc get po -n stackrox
  echo ""
fi

# Check the stackrox deployments are happy.
# There might be some overlap between this and the 'oc get pod' check, so it's belt and braces...
oc get deploy -n stackrox |  sed -n '1!p' | while read line; do
  podReady=$(echo $line | awk '{print $2}' | awk -F"/" '{print $1}')
  podTotal=$(echo $line | awk '{print $2}' | awk -F"/" '{print $2}')
  if [ "$podReady" != "$podTotal" ]; then
	CLUSTERNOTREADY=true
    exit 1
  fi
done

# Exit script if cluster not ready
if [ "$CLUSTERNOTREADY" == "true" ]; then
  echo "Please check 'oc get deploy -n stackrox' as some pods are not in a ready state"
  exit 1
fi


# List pods - then filter for any pods that aren't in running state.
SR_STATE=$(oc get po -n stackrox | grep -v Running | wc -l)

# If only 1 line was returned, it's the header line and so all containers must be in running state
if [ ${SR_STATE} -eq 1 ] ; then
    echo "StackRox status has been checked. StackRox is up."
else
    echo "StackRox initial setup is not complete yet, please try again later"
fi
echo ""

# Create the port-forward to stackrox, running in the background
echo "Starting port-forward to StackRox in background."
oc port-forward svc/central -n stackrox 8443:443 > /dev/null 2>&1 &
echo ""
sleep 5


# Display the password back to the screen
echo "StackRox password is: $(helm get notes stackrox-central-services -n stackrox | grep password -A 2 | sed -n 4p | sed 's/^ *//g')"
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
printf "\nGenerating bundle from Stackrox.\n"
if [ "$HOMEDIRBIN" == "true" ]; then
  ~/bin/roxctl -e "$ROX_CENTRAL_ADDRESS" central init-bundles generate $clusterName --output cluster-init-bundle.yaml --insecure-skip-tls-verify
else
  roxctl -e "$ROX_CENTRAL_ADDRESS" central init-bundles generate $clusterName --output cluster-init-bundle.yaml --insecure-skip-tls-verify
fi
RC=$?
if [ "$RC" -ne "0" ]; then
  printf "\nFailed to create the cluster-init-bundle - please check.\n"
  tunnel=$(ps -ef | grep port-forward | grep stackrox | awk ' { print $2 } ')
  kill $tunnel
  exit 1
fi

# Check RHACS helm repo has been added locally
printf "\nCheck if StackRox helm repo has been added.\n"
helm_repo_check=$(helm repo list | grep rhacs)
if [ -z "$helm_repo_check" ]; then
    printf "\nAdding Helm repo as not found\n"
    helm repo add rhacs https://mirror.openshift.com/pub/rhacs/charts/
    RC=$?
    if [ "$RC" -ne "0" ]; then
      printf "\nFailed to add the helm repo - please check.\n"
      tunnel=$(ps -ef | grep port-forward | grep stackrox | awk ' { print $2 } ')
      kill $tunnel
      exit 1
    fi
fi

# Use helm to deploy the bundle
printf "\nUsing Helm install to deploy bundle\n"
helm install -n stackrox stackrox-secured-cluster-services rhacs/secured-cluster-services -f cluster-init-bundle.yaml --set centralEndpoint=central.stackrox:443 --set clusterName=$clusterName --set imagePullSecrets.allowNone=true
RC=$?
if [ "$RC" -ne "0" ]; then
  printf "\nFailed to perform the helm install - please check.\n"
  tunnel=$(ps -ef | grep port-forward | grep stackrox | awk ' { print $2 } ')
  kill $tunnel
  exit 1
fi

# Bring tunnel to foreground
printf "\nEnding port-forward to stackrox\n"
tunnel=$(ps -ef | grep port-forward | grep stackrox | awk ' { print $2 } ')
printf "\nKilling off tunnel process ID: $tunnel\n"
kill $tunnel

# Name the cluster-init-bundle with the current time
NOW=$(date +%Y-%m-%d)
mv cluster-init-bundle.yaml cluster-init-bundle.yaml-${NOW}

# Script is complete
printf "\nInstallation finished. Please see cluster in UI.\n"