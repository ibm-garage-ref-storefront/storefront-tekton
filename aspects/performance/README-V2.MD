# Welcome to IBM Prevail 2021

## Deploy the IBM Blue Compute shop

[Deploy](../functionality/DEPLOY-FULL-BC.MD) the IBM Blue Compute shop 

## Install the tooling

[Install](../nuts-and-bolts/MINI-SETUP.MD) the tooling.

The tools setup build a JMeter image in the tools namespace:

    $ oc get is -n tools | grep jmeter
    NAME                  IMAGE REPOSITORY                                                                    TAGS     UPDATED
    jmeter-prevail-2021   default-route-openshift-image-registry.apps-crc.testing/tools/jmeter-prevail-2021   latest   About an hour ago

## Scan the JMeter image for vulnerabilities

We will scan the JMeter image for vulnerabilities before we use it in the Tekton pipeline. 

    oc create -f scripts/tools-images/scan-jmeter-prevail-2021.yaml 
    scripts/watch-the-pipeline-run.sh

You will find that the jmeter image itself does have critical vulnerabilies. 

Let's close an eye ..

    oc create -f scripts/tools-images/do-not-scan-jmeter-prevail-2021.yaml
    scripts/watch-the-pipeline-run.sh    

Inspect the result of the import:

    $ oc get is -n tools-images
    NAME                  IMAGE REPOSITORY                                                                           TAGS             UPDATED
    jmeter-prevail-2021   default-route-openshift-image-registry.apps-crc.testing/tools-images/jmeter-prevail-2021   for-use,latest   13 seconds ago


## The performance pipeline

The peformance pipeline looks similar to the security pipeline. 

![Fail](../../images/performance-pipeline.png?raw=true "Title")

There is one difference: all tasks except for the performance test have been stubbed.


