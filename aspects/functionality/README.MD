# Welcome to IBM Prevail 2021

The IBM Blue Compute shop will be tested on its functionality. The pipeline is stubbed except for the functional test.

## Pre-requisites

### a) Deploy the IBM Blue Compute shop

[Deploy](../functionality/DEPLOY-FULL-BC.MD) the IBM Blue Compute shop if you have not allready done so.

### b) Install the tooling and pipelines

[Install](../nuts-and-bolts/MINI-SETUP.MD) the tooling if you have not allready done so.

### c) Scan and Import the Images

[Scan and Import](../nuts-and-bolts/SCAN.MD) the images that are used by the tool-chain if you have not allready done so.


# The functionality section of the pipeline

The peformance pipeline looks similar to the security pipeline.  Actually, it is the same.

![Fail](../../images/functionality-pipeline.png?raw=true "Title")

There is one difference: all tasks except for the functional test have been stubbed.


## Lets run the functionality pipeline