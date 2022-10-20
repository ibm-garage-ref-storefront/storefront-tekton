# 1 Purpose

This repository:
- deploy the full IBM Blue Compute shop consisting of 10 micro services with a single command into an OpenShift Cluster;
- installs OpenShift Pipelines (based on Tekton) to perform builds, deployment and various tests.

The purpose is to measure various quality aspects during the build of an application on OpenShift - and break the build if necessary to ensure a quality outcome.

## Prevail 2022: Security Workstream - self-paced agenda, day 1, October 19th 2022
The agenda for the security workstream is self-paced, with a series of video presentations and hands-on labs to complete. Please use the links provided in the table below. The timings give you guidance on the duration of the session. If you need any assistance, please access the Slack Channel you have been provided a link to in the Prevail stream session.
| Topic                                      | Start Time (UTC) | End Time | Link |
| ------------------------------------------ | ---------- | -------- | ---- |
|Overview/Agenda of the Workshop             | 11:30 | 11:40 | [1. introduction-security-stream](https://ibm.box.com/s/89awajtforadft51npykehar1l8focxs)|
|Container & Orchestration security theory   | 11:40 | 13:05 | [2. Container & Orchestration security theory](https://ibm.box.com/s/89awajtforadft51npykehar1l8focxs)|
|Lunch break                                 | 13:05 | 13:45 | -|
|Walkthrough of the labs and tools           | 13:45 | 13:50 | [lab-intro](https://ibm.box.com/s/89awajtforadft51npykehar1l8focxs)|
|Deploy base BlueCompute app from template   | 13:50 | 14:30 | [lab1](https://ibm.box.com/s/89awajtforadft51npykehar1l8focxs)|
|Optional: Review Security Issues <br /> Examine Deploy tools and pipelines                  | 14:30 | 15:00 | Optional: [lab2](https://ibm.box.com/s/89awajtforadft51npykehar1l8focxs) <br /> [lab3](https://ibm.box.com/s/89awajtforadft51npykehar1l8focxs)|
|Deploy and scan base images                 | 15:00 | 15:30 | [lab4](https://ibm.box.com/s/89awajtforadft51npykehar1l8focxs)|
|Wrap-up and Q&A                             | 15:30 | 16:00 | Prevail session stream|

## Prevail 2022: Security Workstream - self-paced agenda, day 2, October 20th 2022
The agenda for the security workstream is self-paced, with a series of video presentations and hands-on labs to complete. Please use the links provided in the table below. The timings give you guidance on the duration of the session. If you need any assistance, please access the Slack Channel you have been provided a link to in the Prevail stream session.

(Video links will be published at the end of day 1)

| Topic                                      | Start Time (UTC) | End Time | Link |
| ------------------------------------------ | ---------- | -------- | ---- |
|Recap of day 1, outlook into day 2          | 10:20 | 11:40 | [prevail2021-sec-d2-1-intro](https://ibm.box.com/s/szvr0l1yglvicnowl06wtml9h84a02iz)|
|Security Lab 1 - Detect app vulns using OWASP Dependency Check and SonarQube   | 11:00 | 12:00 | [prevail2021-sec-d2-2-lab1-sca-sast](https://ibm.box.com/s/szvr0l1yglvicnowl06wtml9h84a02iz) |
|Security Lab 2 - Detect container vulns using StackRox in the pipeline           | 12:00 | 12:45 |[prevail2021-sec-d2-3-lab2-scan](https://ibm.box.com/s/szvr0l1yglvicnowl06wtml9h84a02iz) |
|Lunch Break                                                                      | 12:45 | 13:30 |- |
|Security Lab 3 - Detect container vulns using StackRox to monitor the cluster <br /> Review remediated security issues  | 13:30 | 15:00 |[prevail2021-sec-d2-4-lab3-runtime](https://ibm.box.com/s/szvr0l1yglvicnowl06wtml9h84a02iz) |
|Wrap-up                                                                  | 15:00 | 15:30 | [prevail2021-sec-d2-6-close](https://ibm.box.com/s/szvr0l1yglvicnowl06wtml9h84a02iz) |

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
