# Welcome to IBM Prevail 2021

## Setup

Do the  ["setup"](../nuts-and-bolts/MINI-SETUP.MD) of the tooling.

## Scan the JMeter image for vulnerabilities

    oc create -f scripts/tools-images/scan-jmeter-prevail-2021.yaml 
    scripts/watch-the-pipeline-run.sh