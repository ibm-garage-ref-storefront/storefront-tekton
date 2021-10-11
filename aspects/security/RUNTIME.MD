# Welcome to IBM Prevail 2021

We will build, deploy and test the customer-ms-spring runtime branch and then look at the implications of resolving some vulnerabilities but not all. StackRox runtime monitoring of a container will be demonstrated.

## Pre-requisites

### a) Deploy the IBM Blue Compute shop

[Deploy](../functionality/DEPLOY-FULL-BC.MD) the IBM Blue Compute shop if you have not already done so.

### b) Install the tooling and pipelines

[Install](../nuts-and-bolts/MINI-SETUP.MD) the tooling if you have not already done so.

### c) Scan and Import the Images

[Scan and Import](../nuts-and-bolts/SCAN.MD) the images that are used by the tool-chain if you have not already done so.

# StackRox

## a) Get the admin password

The tools setup has installed stackrox.

    helm get notes stackrox-central-services -n stackrox

We are looking for:

    helm get notes stackrox-central-services -n stackrox | grep -A3 "initial setup"

# Configure StackRox

## a) Login to StackRox

Setup port-forwarding:

    oc port-forward svc/central -n stackrox 8443:443

Login via your browser, via right-click, open a new tab ["here"](https://localhost:8443). 

Use the login that was previously obtained. You should now be logged in:

![Fail](../../images/stackrox-login.png?raw=true "Title")


## b) Make a StackRox API token

Go to Platform Configuration, Integrations, Authentication Tokens, StackRox

![Fail](../../images/stack-rox-api-token.png?raw=true "Title")

Click on New Integration and create an API token with name set to ci_token adn Role set to Continuous Integration.

![Fail](../../images/stackrox-ci-token.png?raw=true "Title")

Copy the token and store it safely.

## c) Connect StackRox to the OpenShift Image Registry

Click on Integrations on the left hand menu and select the image integration docker "generic docker registry" as shown below:

![Fail](../../images/generic-docker-registry.png?raw=true "Title")

Click New Integration button and complete the details as shown below

Integration Name - OpenShift_Image_registry

Get your user name:

    oc whoami

Get your token:

    oc whoami -t

For Endpoint use:

    image-registry.openshift-image-registry.svc:5000

![Fail](../../images/test-integration.png?raw=true "Title")

Disable TLS Certificate Validation.

Click Test button to confirm details are correct and then Save and exit.


## d) Configure the StackRox API token

Edit the configuration of the installer.

    vi ~/config.bc-full

Set the value of STACKROX_API_TOKEN with the previously created CI Token.

Run the setup:

    bash scripts/pipeline/stackrox-setup.sh  


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

Inspect the Customer Micro Service Dockerfile

![Fail](../../images/customer-docker-file.png?raw=true "Title")

Drill down on the critical vulnerability by clicking on View All CVES by CVSS Score and then sorting by severity

![Fail](../../images/cves-by-cvss-score.png?raw=true "Title")

As we see below the CVE-2020-1938 is the critical vulnrability in our image.  Click on this to find out more detail.

![Fail](../../images/drill-down.png?raw=true "Title")

Find out what needs to be fixed and look at the component and deployment tabs in the related entities section on the left hand side.

![Fail](../../images/fix-version.png?raw=true "Title")

Take a careful look at the recommended fix version.

**Summary**  
The scan has failed due to one policy violation:
  - Tomcat needs upgrading

The scan has an additional violation:
  - The use of root user is prohibited.

...but StackRox isn't configured to enforce it so won't cause the task to fail.
 
We will fix the Tomcat vulnerability, but choose to "overlook" the other violations to "make life easier" - however we wish to demonstrate the implications this decision will have!


# Let's go and build our defense.

## OPTIONAL: Install Snyk

Analyze the project using Snyk, it recommends us to level up the pom of the microservice. If you don't already have Maven, Visual Studio Code (VS Code) and Red Hat Dependency Analytics installed and configured on your machine, follow [these instructions](./rhda_setup.md) (ensure to open in a new tab so that you can return here). They provide additional steps to ensure Maven is correctly configured. If you have Maven configured, then:
  - Install [Visual Studio Code (VS Code)](https://code.visualstudio.com/download)
  - Install the Red Hat Dependency Analytics [plugin](https://marketplace.visualstudio.com/items?itemName=redhat.fabric8-analytics) in VS Code

Clone the customer-ms-spring microservice [repo](https://github.com/kitty-catt/customer-ms-spring) and inspect the branch named **solo** with Snyk (it is very important to inspect the correct branch, otherwise the results of the inspection will not be accurate).

If not already done, create a free Snyk account and get your token.

## OPTIONAL: Snyk Recommendation

Inspect the report:

![Fail](../../images/snyk-recommendation.png?raw=true "Title")


## Fix Tomcat, but not the use of root-user
You may fork the repo that we are building, and make the mod yourself. For the interest of time we suggest you use the pre-built branch with the Tomcat fix, but still running as root user:

    oc create -f tekton-pipeline-run/customer-stackrox-pipeline-ibm-prevail-2021-tomcatfix-stillroot-version.yaml
    scripts/watch-the-pipeline-run.sh

The pipeline now runs to completion:

![Fail](../../images/fix-version-pipelinerun.png?raw=true "Title")

Inspect the stackrox console and verify the vulnerability was successfully patched.

![Fail](../../images/fix-version-in-stackrox.png?raw=true "Title")


## The "root user" policy isn't enforced by default in StackRox

  - Go to UI > Platform Configuration > System Policies
  - Type "Enforcement" in the filter bar, click on it so it becomes blue. Then type "FAIL_BUILD_ENFORCEMENT" and press enter.

See how, by default, only a small number of policies are configured to apply enforcement of the policy (that would cause pipeline to fail if violated).

***Note:** For informational purposes only - do not set this policy's enforcement behaviour to "on" as part of th demo run.*
*It is possible to turn enforcement behaviour on by doing the following:*  
  *- Go to UI > Platform Configuration > System Policies*  
    *- Filter for "Docker CIS 4.1: Ensure That a User for the Container Has Been Created"*  
    *- Click on the policy. Then click on: Edit > Next > Next > Next > Turn "Enforcement Behaviour" on > Save*  
