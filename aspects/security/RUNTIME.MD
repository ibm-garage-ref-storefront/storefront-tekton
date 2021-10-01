# Welcome to IBM Prevail 2021

We will inspect the running status of the blue compute shop via stackrox.

## Pre-requisites

### a) Deploy the IBM Blue Compute shop

[Deploy](../functionality/DEPLOY-FULL-BC.MD) the IBM Blue Compute shop if you have not already done so.

### b) Install the tooling and pipelines

[Install](../nuts-and-bolts/MINI-SETUP.MD) the tooling if you have not already done so.

### c) Configure StackRox monitoring of the cluster

[Configure](./README-V3.MD) monitoring if you have not already done so.

### d) Configure StackRox pipeline

[Configure](./README-V3.MD) StackRox pipeline if you have not already done so.

## Update intro line
## TODO: deploy a run-as-root container

# The StackRox pipeline

## a) Run the pipeline

    oc create -f tekton-pipeline-run/customer-stackrox-pipeline-ibm-prevail-2021-runtime.yaml
    scripts/watch-the-pipeline-run.sh

## b) The pipeline run now fails on the application image that was built  

![Fail](../../images/stackrox-plr.png?raw=true "Title")

## c) Inspect the Stackrox reports

Go to the vulnerability overview in Stackrox

![Fail](../../images/risky-images.png?raw=true "Title")

Inspect the Stackrox report for the image that was built

![Fail](../../images/customer-report.png?raw=true "Title")

## Fix tomcat but not root
You may fork the repo that we are building, and make the mod yourself. For the interest of time we suggest you use the pre-built branch with the fix version:

    oc create -f tekton-pipeline-run/customer-stackrox-pipeline-ibm-prevail-2021-tomcatfix-stillroot-version.yaml
    scripts/watch-the-pipeline-run.sh

## Disable "root user" policy enforcement in StackRox, to bypass
## Demonstrate what can be done in the container and what StackRox runtime monitoring is detecting (i.e. policy violations)
## Amend the deployment.yaml to add securityContexts in to reduce attack vectors.
## Changes to SCC to ensure deployment yaml causes correct SCC to be used - show how securityContexts can help reduce attack vectors.
