# 1 Purpose

This repository aims to:
- deploy the full IBM Blue Compute shop consisting of 10 micro services with a single command into an Openshift Cluster;
- setup Openshift Pipelines (based on Tekton) to perform builds, deployment and various tests.

Once the blue compute shop is up and running your can choose to explore various aspects:

## a) Common Setup IBM Prevail 2021

| Aspect | Description |
| --- | --- |
| [Deploy](aspects/functionality/DEPLOY-FULL-BC.MD) | Deploy the IBM Blue Compute shop |
| [Tools Setup](aspects/nuts-and-bolts/MINI-SETUP.MD) | Setting up the tools |
| [Tools Images](aspects/nuts-and-bolts/SCAN.MD) | Scanning and importing the tools images |

## b) Independant Tracks IBM Prevail 2021

| Aspect | Description | Duration |
| --- | --- | --- |
| [Security](aspects/security/README-V2.MD) | break the build based on detected vulnerabilities | 30 minutes |
| [Functionality](aspects/functionality/README.MD) | break the build based on functional requirements | 15 minutes |
| [Performance](aspects/performance/README-V2.MD) | break the build based on performance requirements | 45 minutes |
| [Availability](aspects/availability/README.MD) | slot available |

# Archived version

| Aspect | Description |
| --- | --- |
| [Security](aspects/security/README.MD) | a Tekton Pipeline that builds and scans the microservice for vulnerabilities |
| [Nuts and Bolts](aspects/nuts-and-bolts/README.MD) | For nuts and bolts lovers |

Follow the mandatory [preparation](aspects/general/README.MD)



