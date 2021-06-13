# Welcome to IBM Prevail 2021

We will build, deploy and test the customer-ms-spring solo branch.


## Pre-requisites

### a) Deploy the IBM Blue Compute shop

[Deploy](../functionality/DEPLOY-FULL-BC.MD) the IBM Blue Compute shop if you have not allready done so.

### b) Install the tooling and pipelines

[Install](../nuts-and-bolts/MINI-SETUP.MD) the tooling if you have not allready done so.

### c) Scan and Import the Images

[Scan and Import](../nuts-and-bolts/SCAN.MD) the images that are used by the tool-chain if you have not allready done so.


## The Security pipeline

The security pipeline looks similar to the performance pipeline. 

![Fail](../../images/secure-pipeline-prevail-2021.png?raw=true "Title")

There is one difference: all tasks except for the performance test have been stubbed.

## Run the security-pipeline-prevail-2021 pipeline

The security pipeline will run Tekton Tasks which are based on the screened images.

![Fail](../../images/security-pipeline-run-prevail-2021.png?raw=true "Title")

The pipeline uses a chained build where:
1. first the artifact is build 
2. next the Dockerfile is build.

The FROM image in the Dockerfile is under control of the pipeline run. In other words, the customer image is based on a parent image that passed the security scan!

Create a pipeline run and follow it:

     oc create -f tekton-pipeline-run/customer-security-pipeline-ibm-prevail-2021-experimental.yaml 
    scripts/watch-the-pipeline-run.sh

Note: the fist time that the pipeline runs with take about 14 minutes because it will download images, dependencies as well as the NIST database. Once all is fine the pipeline will run in around 6 to 7 minutes.

# Accessing the scan results

Setup port-forwarding and access the OWASP dependency check report [here](http://localhost:8080):

    tools/httpd/port-forward.sh

Note, the user and password is aot-user/ibm-prevail-2021, navigate to:

![Report](../../images/owasp-dependency-check-1.png?raw=true "Title")

Click on the link "dependency-check:aggregate":

![OWASP](../../images/owasp-dependency-check-2.png?raw=true "Title")

Take some time to explore the vulnerabilties. Click on the links in the report to visit the NIST database that provides guidance on how to fix the vulnerabilities. 

Setup port-forwarding and access the sonarqube report [here](http://localhost:9000):

    tools/sonarqube/port-forward.sh

Explore the sonar-qube report:

![Report](../../images/sonar-qube.png?raw=true "Title")


# Trivia

Note on CRC, when pods do not get scheduled because the node has disk pressure. Delete completed pods and pipeline runs, and restart CRC.

https://github.com/code-ready/crc/issues/127