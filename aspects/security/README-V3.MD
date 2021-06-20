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

