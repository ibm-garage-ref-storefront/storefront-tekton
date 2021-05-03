# Welcome to IBM Prevail 2021

We will build, deploy and test the customer-ms-spring solo branch.

## Setup

### A) Setup the tools namespace

In the current version of this repo we are working on Redhat CRC. It should work on a regular OCP cluster with some care. 

    oc login -u kubeadmin -p <password> https://api.crc.testing:6443
    git clone https://github.com/ibm-garage-ref-storefront/storefront-tekton
    cd storefront-tekton   
    cp scripts/config ~/config.bc-full

Edit the configuration file, and modify OCP_USER and OCP_ADMIN unless you are running on CRC:

    vi ~/config.bc-full


### B) Setup the tools-images namespace

    oc login -u kubeadmin -p <password> https://api.crc.testing:6443
    bash scripts/tools-images/setup.sh 


### C) Setup the pipelines namespace

Login to sonarqube and make a SONAR_QUBE_PAT:

    bash tools/sonarqube/port-forward.sh

Edit the configuration file, and modify SONAR_QUBE_PAT:

    vi ~/config.bc-full

Initialize the pipeline project / namespace:

    oc login -u kubeadmin -p <password> https://api.crc.testing:6443
    bash scripts/pipeline/mini-setup.sh

## Import the images

### A) Scan and Import UBI:8

The images that are used to build the application image are scanned and if they are clean then they are imported into the tools-images project by the image-intake-pipeline. This pipeline can be inspected via the console:

![Fail](../../images/image-intake-pipeline-prevail-2021.png?raw=true "Title")


Create a pipeline run that will fail when vulnerabilities of level  'UNKNOWN,LOW,MEDIUM,HIGH,CRITICAL' are detected and follow it:

    oc login -u developer -p developer https://api.crc.testing:6443
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

Explore the images in the tools-images project:

    $ oc get is -n tools-images
    NAME                            IMAGE REPOSITORY                                                                                     TAGS             UPDATED
    sonarsource-sonar-scanner-cli   default-route-openshift-image-registry.apps-crc.testing/tools-images/sonarsource-sonar-scanner-cli   for-use,latest   4 minutes ago
    ubi                             default-route-openshift-image-registry.apps-crc.testing/tools-images/ubi                             for-use,8.0      18 hours ago


## Run the security-pipeline-prevail-2021 pipeline

The security pipeline will run Tekton Tasks which are based on the screened images.

![Fail](../../images/security-pipeline-prevail-2021.png?raw=true "Title")

The pipeline uses a chained build where:
1. first the artifact is build 
2. next the Dockerfile is build.

The FROM image in the Dockerfile is under control of the pipeline run. In other words, the customer image is based on a parent image that passed the security scan!

Create a pipeline run and follow it:

    oc create -f tekton-pipeline-run/customer-security-pipeline-ibm-prevail-2021.yaml
    scripts/watch-the-pipeline-run.sh