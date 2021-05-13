# Welcome to IBM Prevail 2021

## Deploy the IBM Blue Compute shop

[Deploy](../functionality/DEPLOY-FULL-BC.MD) the IBM Blue Compute shop 

## Install the tooling

[Install](../nuts-and-bolts/MINI-SETUP.MD) the tooling.

## Scan the JMeter image for vulnerabilities

We will scan the JMeter image for vulnerabilities before we use it in the Tekton pipeline.

    oc create -f scripts/tools-images/scan-jmeter-prevail-2021.yaml 
    scripts/watch-the-pipeline-run.sh

You will find that the jmeter image itself does have critical vulnerabilies. 

Let's close an eye ..

    oc create -f scripts/tools-images/do-not-scan-jmeter-prevail-2021.yaml
    scripts/watch-the-pipeline-run.sh    

Inspect the result:

    $ oc get is -n tools-images
    NAME                  IMAGE REPOSITORY                                                                           TAGS     UPDATED
    jmeter-prevail-2021   default-route-openshift-image-registry.apps-crc.testing/tools-images/jmeter-prevail-2021   latest   