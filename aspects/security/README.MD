# Welcome to IBM Prevail 2021
Theory and hands-on exercises on OpenShift security and adding security quality gates in Tekton CI/CD pipelines will be provided by the Security track of the workshop.

## Pre-requisites:
You must have created an IBM Cloud Account.

You must have a Linux-like environment (native or VM) with the following installed in order to work through the exercises:
  - oc (OpenShift CLI)
  - Docker
  - git
  - Helm
  - vi
  - jq

Follow the instructions at https://github.com/ibm-garage-ref-storefront/storefront-tekton

## Workshop Purpose
Using commercial and open-source tools as quality gates in a Tekton pipeline, we can identify and track security issues within a containerized application’s source code (SAST), dependencies (SCA), base image and build image (vulnerability scanning) prior to deployment. By applying admission control and additional security policies, we can identify, alert and prevent undesired and potentially harmful behavior at runtime.

## Why is it needed?
Security is one of the quality attributes of a modern microservice application and needs to be integrated with the technologies and platforms that automate application build and deployment (CI/CD), as well as with its runtime environment (OpenShift / Kubernetes). In doing so, security issues with containers can be identified and remediated throughout (and earlier in) the application lifecycle (shift left):
* Vulnerabilities and coding issues in application and infrastructure source code
* Vulnerabilities in application dependencies
* Vulnerabilities and configuration issues in base and build images
* Potentially harmful runtime behavior of containerized applications, indicating susceptibility to or even ongoing cyber attacks that may negatively impact a business
* Compliance and configuration issues with the underlying orchestrator, operating system, and regulatory requirements

This process is being deployed on OpenShift using automated shell scripts and some manual configuration.

## What will Student learn?
The students will learn about and use:
* OpenShift security
* OpenShift pipelines based on Tekton
* Red Hat Advanced Cluster Security (ACS) for Kubernetes
* SonarQube – Static Application Security Testing (SAST)
* OWASP Dependency Check – Software Composition Analysis (SCA)
* Observe security improvements to application while progressing through the exercises
* The necessity of security gates and IBM’s capability in this field.

# Workshop Agenda
**Part 1**
* Install the BlueCompute microservice application using code based on IBM Garage
* Perform a cursory security inspection
* Install Tekton pipelines, security tools, base images
* All the above procedures can be performed by students just using a shell script and inputting the instructions with some manual intervention.

**Part 2**
* Run security gates based on SonarQube and Dependency Check as part of a Tekton pipeline and inspect resulting vulnerabilities

**Part 3**
* Setup ACS and integrate it into a Tekton pipeline to scan a vulnerable image
* Resolve the application vulnerability and run the pipeline to completion. Fix the application vulnerability but bypass the configuration issue.

**Part 4**
* Setup ACS to monitor the OpenShift cluster
* Inspect compliance and deployed container vulnerability status
* Detect and inspect container runtime security concerns using ACS
* Investigate how the bypass from the previous exercise to “get things running” can have detrimental impacts on system security
* Utilize ACS runtime monitoring and alerting to observe the benefit of container monitoring
* Amend container deployment settings to reduce attack vectors and observe outcomes

# Workshop Schedule:
**Day 1**
* Break out Session (11:30am CET): Webex: https://ibm.webex.com/meet/murhammer
* OpenShift security, DevSecOps, Tekton (Theory) – 1.5 hrs
* Part 1 Instructions – 2 hrs
* Quiz - 30 mins

**Day 2**
* Break out Session (10:20am CET): https://ibm.webex.com/meet/murhammer
* Part 2 Instructions & Lab – 1 hr
* Part 3 Instrcutions & Lab – 1.5 hr
* Part 4 Instrcutions & Lab – 1.5 hrs
* Quiz – 30 mins
