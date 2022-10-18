# 1 Purpose

This repository:
- deploy the full IBM Blue Compute shop consisting of 10 micro services with a single command into an OpenShift Cluster;
- installs OpenShift Pipelines (based on Tekton) to perform builds, deployment and various tests.

The purpose is to measure various quality aspects during the build of an application on OpenShift - and break the build if necessary to ensure a quality outcome.

## Prevail 2022 Self-paced agenda Day 1 October 19th 2022
The agenda for the security workstream is self-paced, with a series of video presentations and hands-on labs to complete. Please use the links provided in the table below. The timings give you guidance on the duration of the session.
| Topic | Start Time | End Time | Link |
| --- | --- | --- | --- |
|Overview/Agenda of the Workshop | 11:30 | 11:40 | link|
|next| time| time| link|


## a) Common Setup IBM Prevail 2022
You must run all of these setup tasks in order:

| Aspect | Description | Estimate |
| --- | --- | --- |
| [1.Deploy](aspects/functionality/DEPLOY-FULL-BC.MD) | Deploy the IBM Blue Compute shop | 15 minutes |
| [2.Examine](aspects/security/TROUBLE.MD) | Could there be trouble? | 15 minutes |
| [3.Tools Setup](aspects/nuts-and-bolts/MINI-SETUP.MD) | Setting up the tools | 15 minutes |
| [4.Tools Images](aspects/nuts-and-bolts/SCAN.MD) | Loading the tool rack | 30 minutes |

## b) Independent Tracks IBM Prevail 2022

Once the Blue Compute shop and the tool-chain is up and running (tasks 1-4 above) you can choose to explore various aspects:

| Aspect | Build Breakers based on | Estimate |
| --- | --- | --- |
| [Security.0](aspects/security/README.MD) | Intro to the security labs course | 5 mins |
| [Security.1](aspects/security/README-V2.MD) | Detect application vulnerabilities using owasp-dependency check and sonarqube.| 45 minutes |
| [Security.2](aspects/security/RUNTIME.MD) | Defect application and container vulnerabilities using StackRox pipeline scanning | 45 minutes |
| [Security.3](aspects/security/README-V3.MD) | Detect and inspect container runtime security concerns using StackRox | 45 minutes |
| [Functionality.1](aspects/functionality/README.MD) | Verify functional requirements using jmeter| 15 minutes |
| [Functionality.2](aspects/functionality/SELENIUM.MD) | Verify functional requirements using selenium| 45 minutes |
| [Performance.1](aspects/performance/README-V2.MD) | Verify performance requirements using jmeter and grafana| 45 minutes |
| [Availability](aspects/availability/README.MD) | Be prepared for turbulant conditions, test your application's availability potential using chaos engineering and Openshift Service Mesh | 90 Minutes

# Archived version

| Aspect | Description |
| --- | --- |
| [Nuts and Bolts](aspects/nuts-and-bolts/README.MD) | For nuts and bolts lovers |

Follow the mandatory [preparation](aspects/general/README.MD).
