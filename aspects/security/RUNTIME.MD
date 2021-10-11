# Welcome to IBM Prevail 2021

We will build, deploy and test the customer-ms-spring runtime branch and then look at the implications of resolving some vulnerabilities but not all. StackRox runtime monitoring of a container will be demonstrated.

## Pre-requisites

### a) Deploy the IBM Blue Compute shop

[Deploy](../functionality/DEPLOY-FULL-BC.MD) the IBM Blue Compute shop if you have not already done so.

### b) Install the tooling and pipelines

[Install](../nuts-and-bolts/MINI-SETUP.MD) the tooling if you have not already done so.

### c) Scan and Import the Images

[Scan and Import](../nuts-and-bolts/SCAN.MD) the images that are used by the tool-chain if you have not already done so.


# The StackRox pipeline

## a) Run the setup

    bash scripts/pipeline/stackrox-setup-runtime.sh  

## b) Run the pipeline

    oc create -f tekton-pipeline-run/customer-stackrox-pipeline-ibm-prevail-2021-runtime.yaml
    scripts/watch-the-pipeline-run.sh

## c) The pipeline run now fails on the application image that was built  

![Fail](../../images/stackrox-plr.png?raw=true "Title")

## d) Inspect the Stackrox reports

Go to the vulnerability overview in Stackrox

![Fail](../../images/risky-images.png?raw=true "Title")

Inspect the Stackrox report for the image that was built

![Fail](../../images/customer-report.png?raw=true "Title")

The scan has failed due to one policy violation:
  - Tomcat needs upgrading

The scan has an additional violation:
  - The use of root user is prohibited.

...but StackRox isn't configured to enforce it so won't cause the task to fail.
 
We will fix the Tomcat vulnerability, but choose to "overlook" the other violations to "make life easier" - however we wish to demonstrate the implications this decision will have!

## Fix Tomcat, but not the use of root-user
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

## The "root user" policy isn't enforced by default in StackRox

  - Go to UI > Platform Configuration > System Policies
  - Type "Enforcement" in the filter bar, click on it so it becomes blue. Then type "FAIL_BUILD_ENFORCEMENT" and press enter.

See how, by default, only a small number of policies are configured to apply enforcement of the policy (that would cause pipeline to fail if violated).

***Note:** For informational purposes only - do not set this policy's enforcement behaviour to "on" as part of th demo run.*
*It is possible to turn enforcement behaviour on by doing the following:*  
  *- Go to UI > Platform Configuration > System Policies*  
    *- Filter for "Docker CIS 4.1: Ensure That a User for the Container Has Been Created"*  
    *- Click on the policy. Then click on: Edit > Next > Next > Next > Turn "Enforcement Behaviour" on > Save*  
