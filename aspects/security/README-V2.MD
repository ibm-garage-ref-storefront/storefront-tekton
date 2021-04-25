# Welcome to IBM Prevail 2021

We will build the customer-ms-spring solo branch.

## Setup the security pipelines

It is assumed that you have allready setup the pipelines project.

    oc login -u developer

    bash scripts/tools-images/setup.sh 
    bash scripts/pipeline/mini-setup.sh


## Run the image-intake-pipeline-prevail-2021 pipeline

![Fail](../../images/image-intake-pipeline-prevail-2021.png?raw=true "Title")

The images that are used to build the application image are scanned and if they are clean then they are imported into the tools-images project.

Create a pipeline run that will fail when vulnerabilities of level  'UNKNOWN,LOW,MEDIUM,HIGH,CRITICAL' are detected and follow it:

    oc create -f scripts/tools-images/scan-ubi-8.0.yaml 
    scripts/watch-the-pipeline-run.sh

Notice that it fails to complete because the scanner detected vulnerabilities. 

Create a pipeline run that will fail when vulnerabilities of level  'CRITICAL' are detected and follow it:

    oc create -f scripts/tools-images/scan-ubi-8.0-fail-on-criticals-only.yaml 
    scripts/watch-the-pipeline-run.sh

Explore the images in the tools-images project:

    $ oc get is -n tools-images
    NAME   IMAGE REPOSITORY                                                           TAGS          UPDATED
    ubi    default-route-openshift-image-registry.apps-crc.testing/tools-images/ubi   8.0,for-use   12 seconds ago

The ubi:for-use image passed the security scan. It will be used for building the customer-ms-spring microservice. 


## Run the security-pipeline-prevail-2021 pipeline

The pipeline uses a chained build where:
1. first the artifact is build 
2. next the Dockerfile is build.

The FROM image in the Dockerfile is under control of the pipeline run.

Create a pipeline run and follow it:

    oc create -f tekton-pipeline-run/customer-security-pipeline-ibm-prevail-2021.yaml
    scripts/watch-the-pipeline-run.sh