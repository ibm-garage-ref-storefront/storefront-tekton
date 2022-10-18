# 1 Purpose

This repository:
- deploy the full IBM Blue Compute shop consisting of 10 micro services with a single command into an OpenShift Cluster;
- installs OpenShift Pipelines (based on Tekton) to perform builds, deployment and various tests.

The purpose is to measure various quality aspects during the build of an application on OpenShift - and break the build if necessary to ensure a quality outcome.

## Prevail 2022 Self-paced agenda Day 1 October 19th 2022
The agenda for the security workstream is self-paced, with a series of video presentations and hands-on labs to complete. Please use the links provided in the table below. The timings give you guidance on the duration of the session.
| Topic                                      | Start Time | End Time | Link |
| ------------------------------------------ | ---------- | -------- | ---- |
|Overview/Agenda of the Workshop             | 11:30 | 11:40 | [other](https://ibm.box.com/s/89awajtforadft51npykehar1l8focxs)|
|Container & Orchestration security theory   | 11:40 | 13:05 | [other](https://ibm.box.com/s/89awajtforadft51npykehar1l8focxs)|
|Lunch break                                 | 13:05 | 13:45 | -|
|Walkthrough of the labs and tools           | 13:45 | 13:50 | [lab-intro](https://ibm.box.com/s/89awajtforadft51npykehar1l8focxs)|
|Deploy base BlueCompute app from template   | 13:50 | 14:30 | [lab1](https://ibm.box.com/s/89awajtforadft51npykehar1l8focxs)|
|Deploy tools and pipelines                  | 14:30 | 15:00 | [lab2](https://ibm.box.com/s/89awajtforadft51npykehar1l8focxs) [lab3](https://ibm.box.com/s/89awajtforadft51npykehar1l8focxs)|
|Deploy and scan base images                 | 15:00 | 15:30 | [lab4](https://ibm.box.com/s/89awajtforadft51npykehar1l8focxs)|
|Wrap-up and Q&A                             | 15:30 | 16:00 | -|

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
