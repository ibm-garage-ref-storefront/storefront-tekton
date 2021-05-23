# Welcome to IBM Prevail 2021

We will build, deploy and test the customer-ms-spring solo branch.


## Pre-requisites

### a) Deploy the IBM Blue Compute shop

[Deploy](../functionality/DEPLOY-FULL-BC.MD) the IBM Blue Compute shop if you have not allready done so.

### b) Install the tooling and pipelines

[Install](../nuts-and-bolts/MINI-SETUP.MD) the tooling if you have not allready done so.


## Import the images

### A) Scan and Import UBI:8

The images that are used to build the application image are scanned and if they are clean then they are imported into the tools-images project by the image-intake-pipeline. This pipeline can be inspected via the console:

![Fail](../../images/image-intake-pipeline-prevail-2021.png?raw=true "Title")


Create a pipeline run that will fail when vulnerabilities of level  'UNKNOWN,LOW,MEDIUM,HIGH,CRITICAL' are detected and follow it:

    oc create -f scripts/tools-images/scan-ubi-8.0.yaml 
    scripts/watch-the-pipeline-run.sh

Notice that it fails to complete because the scanner detected vulnerabilities. 

Create a pipeline run that will fail when vulnerabilities of level  'CRITICAL' are detected and follow it:

    oc create -f scripts/tools-images/scan-ubi-8.0-fail-on-criticals-only.yaml 
    scripts/watch-the-pipeline-run.sh

Notice that it is possible to visually inspect the pipeline run via the web console as well:

![Fail](../../images/watch-the-intake.png?raw=true "Title")

Explore the images in the tools-images project:

    $ oc get is -n tools-images
    NAME   IMAGE REPOSITORY                                                           TAGS          UPDATED
    ubi    default-route-openshift-image-registry.apps-crc.testing/tools-images/ubi   8.0,for-use   12 seconds ago

The ubi:for-use image passed the security scan. It will be used for building the customer-ms-spring microservice. 

### A) Scan and Import the tools images

A Tekton Task is executed via a pod that loads an image to perform the task. We will scan these images.

    oc create -f scripts/tools-images/scan-sonarsource-sonar-scanner-cli-latest-fail-on-high-or-critical.yaml
    oc create -f scripts/tools-images/scan-ubi-minimal-fail-on-criticals.yaml 
    oc create -f scripts/tools-images/scan-quayio-buildah-stable.yaml

Explore the images in the tools-images project:

    NAME                            IMAGE REPOSITORY                                                                                     TAGS             UPDATED
    buildah                         default-route-openshift-image-registry.apps-crc.testing/tools-images/buildah                         for-use,stable   34 seconds ago    
    sonarsource-sonar-scanner-cli   default-route-openshift-image-registry.apps-crc.testing/tools-images/sonarsource-sonar-scanner-cli   for-use,latest   2 days ago
    ubi                             default-route-openshift-image-registry.apps-crc.testing/tools-images/ubi                             for-use,8.0      2 days ago
    ubi-minimal                     default-route-openshift-image-registry.apps-crc.testing/tools-images/ubi-minimal                     for-use,latest   28 seconds ago


Security specials (select one):

    oc create -f scripts/tools-images/scan-gcr-cloud-builders-mvn-3.5.0.yaml 
    oc create -f scripts/tools-images/scan-ibmgaragecloud-mvn-3.6.3-jdk-11-slim.yaml 

Note that the mvn image did not pass the scan. Let's make a decision to go with the [IBM image](https://quay.io/repository/ibmgaragecloud/maven?tab=tags):

    oc create -f scripts/tools-images/do-not-scan-ibmgaragecloud-mvn-3.6.3-jdk-11-slim.yaml 

Inspect the images:

    $ oc get is -n tools-images
    NAME                            IMAGE REPOSITORY                                                                              TAGS                        UPDATED
    alpine-git                      image-registry.openshift-image-registry.svc:5000/tools-images/alpine-git                      for-use,latest              48 minutes ago
    buildah                         image-registry.openshift-image-registry.svc:5000/tools-images/buildah                         for-use,stable              3 minutes ago
    jmeter-prevail-2021             image-registry.openshift-image-registry.svc:5000/tools-images/jmeter-prevail-2021             for-use,latest              49 minutes ago
    mvn                             image-registry.openshift-image-registry.svc:5000/tools-images/mvn                             for-use,3.6.3-jdk-11-slim   12 seconds ago
    sonarsource-sonar-scanner-cli   image-registry.openshift-image-registry.svc:5000/tools-images/sonarsource-sonar-scanner-cli   for-use,latest              3 minutes ago
    ubi                             image-registry.openshift-image-registry.svc:5000/tools-images/ubi                             8.0,for-use                 5 minutes ago
    ubi-minimal                     image-registry.openshift-image-registry.svc:5000/tools-images/ubi-minimal                     for-use,latest              48 minutes ago

Note: the performance section of the workshop will scan and import several additional images which are listed here.



## The Security pipeline

The peformance pipeline looks similar to the performance pipeline. 

![Fail](../../images/secure-pipeline-prevail-2021.png?raw=true "Title")

There is one difference: all tasks except for the security test have been stubbed.

## Run the security-pipeline-prevail-2021 pipeline

The security pipeline will run Tekton Tasks which are based on the screened images.

![Fail](../../images/security-pipeline-run-prevail-2021.png?raw=true "Title")

The pipeline uses a chained build where:
1. first the artifact is build 
2. next the Dockerfile is build.

The FROM image in the Dockerfile is under control of the pipeline run. In other words, the customer image is based on a parent image that passed the security scan!

Create a pipeline run and follow it:

    oc create -f tekton-pipeline-run/customer-security-pipeline-ibm-prevail-2021.yaml
    scripts/watch-the-pipeline-run.sh

# Trivia

Note on CRC, when pods do not get scheduled because the node has disk pressure. Delete completed pods and pipeline runs, and restart CRC.

https://github.com/code-ready/crc/issues/127