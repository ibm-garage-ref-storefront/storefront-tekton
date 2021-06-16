# 1 Purpose

This repository:
- deploy the full IBM Blue Compute shop consisting of 10 micro services with a single command into an Openshift Cluster;
- installs Openshift Pipelines (based on Tekton) to perform builds, deployment and various tests.

The purpose is to measure various quality aspects during the build of an application on Openshift - and break the build if necessary to ensure a quality outcome.


## a) Common Setup IBM Prevail 2021

| Aspect | Description | Estimate |
| --- | --- | --- |
| [Deploy](aspects/functionality/DEPLOY-FULL-BC.MD) | Deploy the IBM Blue Compute shop | 15 minutes |
| [Tools Setup](aspects/nuts-and-bolts/MINI-SETUP.MD) | Setting up the tools | 15 minutes |
| [Tools Images](aspects/nuts-and-bolts/SCAN.MD) | Loading the tool rack | 30 minutes |

## b) Independant Tracks IBM Prevail 2021

Once the blue compute shop and the tool-chain is up and running your can choose to explore various aspects:

| Aspect | Description | Estimate |
| --- | --- | --- |
| [Security](aspects/security/README-V2.MD) | break the build based on detected vulnerabilities | 45 minutes |
| [Functionality](aspects/functionality/README.MD) | break the build based on functional requirements | 15 minutes |
| [Performance](aspects/performance/README-V2.MD) | break the build based on performance requirements | 45 minutes |
| [Availability](aspects/availability/README.MD) | slot available |

# Archived version

| Aspect | Description |
| --- | --- |
| [Security](aspects/security/README.MD) | a Tekton Pipeline that builds and scans the microservice for vulnerabilities |
| [Nuts and Bolts](aspects/nuts-and-bolts/README.MD) | For nuts and bolts lovers |

Follow the mandatory [preparation](aspects/general/README.MD)



