# 1 Purpose

This repository aims to:
- deploy the full IBM Blue Compute shop consisting of 10 micro services with a single command into an Openshift Cluster;
- setup Openshift Pipelines (based on Tekton) to perform builds, deployment and various tests.

Once the blue compute shop is up and running your can choose to explore various aspects:

## a) Prevail 2021

| Aspect | Description |
| --- | --- |
| [Deploy](aspects/functionality/DEPLOY-FULL-BC.MD) | Deploy the IBM Blue Compute shop |
| [Tools Setup](aspects/nuts-and-bolts/MINI-SETUP.MD) | Setting up the tools |
| [Security](aspects/security/README-V2.MD) | the IBM Prevail 2021 experimental version |
| [Performance](aspects/performance/README-V2.MD) | the IBM Prevail 2021 experimental version |


## b) For lovers

| Aspect | Description |
| --- | --- |
| [Security](aspects/security/README.MD) | a Tekton Pipeline that builds and scans the microservice for vulnerabilities |
| [Nuts and Bolts](aspects/nuts-and-bolts/README.MD) | For nuts and bolts lovers |

Follow the mandatory [preparation](aspects/general/README.MD)



