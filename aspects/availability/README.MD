# Welcome to IBM Prevail 2021

The IBM Blue Compute shop will be tested for robustness. The pipeline is stubbed except for the performance and availability test.

## Pre-requisites

### a) Deploy the IBM Blue Compute shop

[Deploy](../functionality/DEPLOY-FULL-BC.MD) the IBM Blue Compute shop if you have not allready done so.

### b) Install the tooling and pipelines

[Install](../nuts-and-bolts/MINI-SETUP.MD) the tooling if you have not allready done so.

### c) Scan and Import the Images

[Scan and Import](../nuts-and-bolts/SCAN.MD) the images that are used by the tool-chain if you have not allready done so.


# The availability section of the pipeline

The availability pipeline looks similar to the security pipeline.  Actually, it is the same.

![Fail](../../images/availability-pipeline.png?raw=true "Title")

There is one difference: all tasks except for the performance and availability test have been stubbed.


## Lets run the availability pipeline

Lets create a run with 5 parallel users, each executing the JMeter testplan 25 times.

    oc create -f tekton-pipeline-run/customer-availability-pipeline-ibm-prevail-2021-availability-build-breaker.yaml 
    scripts/watch-the-pipeline-run.sh  

It is possible to watch the pipeline run via the graphical console as well.

![Fail](../../images/availability-plr.png?raw=true "Title")


## Inspect the performance dashboard.

![Fail](../../images/performance-test.png?raw=true "Title")


## Making the CustomerCouch DB survice pod failover

    oc project full-bc

    oc set volumes deployment/customercouchdb --remove --name=customercouchdb-volume-1

    oc set volumes deployment/customercouchdb \
    --add \
    --name customercouchdb-storage \
    --type pvc \
    --claim-class ibmc-block-gold \
    --claim-mode rwo \
    --claim-size 10Gi \
    --mount-path /opt/couchdb/data \
    --claim-name couchdb-storage