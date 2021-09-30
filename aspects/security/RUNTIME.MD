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
## Fix tomcat
## Disable "root user" policy enforcement in StackRox, to bypass
## Demonstrate what can be done in the container and what StackRox runtime monitoring is detecting (i.e. policy violations)
## Amend the deployment.yaml to add securityContexts in to reduce attack vectors.
## Changes to SCC to ensure deployment yaml causes correct SCC to be used - show how securityContexts can help reduce attack vectors.
