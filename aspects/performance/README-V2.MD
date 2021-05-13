# Welcome to IBM Prevail 2021

## Deploy the IBM Blue Compute shop

[Deploy](../functionality/DEPLOY-FULL-BC.MD) the IBM Blue Compute shop 

## Setup

["Install"](../nuts-and-bolts/MINI-SETUP.MD) the tooling.

## Scan the JMeter image for vulnerabilities

    oc create -f scripts/tools-images/scan-jmeter-prevail-2021.yaml 
    scripts/watch-the-pipeline-run.sh