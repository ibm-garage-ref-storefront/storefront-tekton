# Welcome to IBM Prevail 2021

We will build, deploy and test the customer-ms-spring solo branch.


## Pre-requisites

### a) Deploy the IBM Blue Compute shop

[Deploy](../functionality/DEPLOY-FULL-BC.MD) the IBM Blue Compute shop if you have not allready done so.

### b) Install the tooling and pipelines

[Install](../nuts-and-bolts/MINI-SETUP.MD) the tooling if you have not allready done so.

### c) Scan and Import the Images

[Scan and Import](../nuts-and-bolts/SCAN.MD) the images that are used by the tool-chain if you have not allready done so.


# The security section of the pipeline

The stackrox security pipeline looks similar to all the other pipelines. 

![Fail](../../images/stackrox-pipeline-prevail-2021.png?raw=true "Title")

There is one difference: all tasks except for scanning the "base image" and the build "application image"  have been stubbed.

# Install StackRox

## a) Add the Stackrox Helm Repository

    helm repo add rhacs https://mirror.openshift.com/pub/rhacs/charts/
    helm search repo -l rhacs/
    helm repo update

## b) Install StackRox

    helm install -n stackrox --create-namespace stackrox-central-services rhacs/central-services --set imagePullSecrets.allowNone=true

## c) Get the admin password

    helm get notes stackrox-central-services -n stackrox

notes:
- Write down the admin password. This is the only time you will be able to see it.

## d) Lower the CPU requirements for StackRox

Switch to the StackRox namespace:

    oc project stackrox

Update the Helm Chart:

    helm upgrade  stackrox-central-services rhacs/central-services \
    --reuse-values \
    --set central.resources.requests.memory="2Gi" \
    --set central.resources.requests.cpu="100m" \
    --set scanner.resources.requests.memory="1000Mi" \
    --set scanner.resources.requests.cpu="100m"

Switch back

    oc project pipelines

