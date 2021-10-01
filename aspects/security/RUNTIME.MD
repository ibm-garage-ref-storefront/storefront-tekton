# Welcome to IBM Prevail 2021

We will build, deploy and test the customer-ms-spring runtime branch and then look at the implications of resolving some vulnerabilities but not all. StackRox runtime monitoring of a container will be demonstrated.

## Pre-requisites

### a) Deploy the IBM Blue Compute shop

[Deploy](../functionality/DEPLOY-FULL-BC.MD) the IBM Blue Compute shop if you have not already done so.

### b) Install the tooling and pipelines

[Install](../nuts-and-bolts/MINI-SETUP.MD) the tooling if you have not already done so.

### c) Configure StackRox monitoring of the cluster

[Configure](./README-V3.MD) monitoring if you have not already done so.

### d) Configure StackRox pipeline

[Configure](./README-V3.MD) StackRox pipeline if you have not already done so.

# The StackRox pipeline

## a) Run the pipeline

    oc create -f tekton-pipeline-run/customer-stackrox-pipeline-ibm-prevail-2021-runtime.yaml
    scripts/watch-the-pipeline-run.sh

## b) The pipeline run now fails on the application image that was built  

![Fail](../../images/stackrox-plr.png?raw=true "Title")

## c) Inspect the Stackrox reports

Go to the vulnerability overview in Stackrox

![Fail](../../images/risky-images.png?raw=true "Title")

Inspect the Stackrox report for the image that was built

![Fail](../../images/customer-report.png?raw=true "Title")

The scan has failed due to two items:
  - Tomcat needs upgrading; and
  - The use of root user is prohibited.
 
We will fix the Tomcat vulnerability, but choose to bypass the policy check on root user to "make life easier" - however we wish to demonstrate the implications this decision will have!

## TODO: Disable "root user" policy enforcement in StackRox, to bypass
Write this section:
  - Show in logs that the "root user" policy is in violation
  - Go to console
  - Go to policies
  - Find policy XYZ
  - Disable the enforcement behaviour

## Fix tomcat but not root
You may fork the repo that we are building, and make the mod yourself. For the interest of time we suggest you use the pre-built branch with the Tomcat fix, but still running as root user:

    oc create -f tekton-pipeline-run/customer-stackrox-pipeline-ibm-prevail-2021-tomcatfix-stillroot-version.yaml
    scripts/watch-the-pipeline-run.sh

## TODO: Demonstrate what can be done in the container and what StackRox runtime monitoring is detecting (i.e. policy violations)
Write this section:
  - install curl et al
  - update packages
  - could give privilege and mount host directory?
  - show what StackRox is picking up
    - both; policy violations (e.g. use of package manager)
    - and; the baseline (assuming it's forming?) 

## TODO: Amend the deployment.yaml to add securityContexts in to reduce attack vectors.
Write this section:
  - ensure `privilege` is removed
  - remove `capabilities`

## TODO: Changes to SCC to ensure deployment yaml causes correct SCC to be used - show how securityContexts can help reduce attack vectors.
SCCs changing needs to be part of the previous section...
