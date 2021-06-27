# Welcome to IBM Prevail 2021

We will build, deploy and test the customer-ms-spring solo branch.


## Pre-requisites

### a) Deploy the IBM Blue Compute shop

[Deploy](../functionality/DEPLOY-FULL-BC.MD) the IBM Blue Compute shop if you have not allready done so.

### b) Install the tooling and pipelines

[Install](../nuts-and-bolts/MINI-SETUP.MD) the tooling if you have not allready done so.

### c) Scan and Import the Images

[Scan and Import](../nuts-and-bolts/SCAN.MD) the images that are used by the tool-chain if you have not allready done so.


# The Stackrox section of the pipeline

As part of this section of the workshop, the stackrox security pipeline will be created in a few moments.

The stackrox security pipeline looks similar to all the other pipelines. 

![Fail](../../images/stackrox-pipeline-prevail-2021.png?raw=true "Title")

There is one difference, all tasks have been stubbed except for:
- for scanning the "base image"
- building the application;
- building the "application image" 
- scanning the build "application image"

# StackRox

## a) Get the admin password

The tools setup has installed stackrox.

    helm get notes stackrox-central-services -n stackrox


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

Open it and create an API token of type CI integration.

![Fail](../../images/stackrox-api-token-type-ci.png?raw=true "Title")

Copy the token and store it savely.

## c) Connect StackRox to the Openshift Image Registry

Create a new registry integration of type "generic docker registry":

![Fail](../../images/generic-docker-registry.png?raw=true "Title")

Fill in your credentials and test that the integration works:

Get your user name:

    oc whoami

Get your token:

    oc whoami -t

For registry use:

    image-registry.openshift-image-registry.svc:5000

![Fail](../../images/test-integration.png?raw=true "Title")

Disable TLS Certificate Validation.

Save and exit.


## d) Configure the StackRox API token

Edit the configuration of the installer.

    vi ~/config.bc-full

Set the value of STACKROX_API_TOKEN with the previously created Token.

Run the setup:

    bash scripts/pipeline/stackrox-setup.sh  


# The StackRox pipeline

## a) Run the pipeline

    oc create -f tekton-pipeline-run/customer-stackrox-pipeline-ibm-prevail-2021.yaml
    scripts/watch-the-pipeline-run.sh

## b) The pipeline run now fails on the application image that was build 

![Fail](../../images/stackrox-plr.png?raw=true "Title")

## c) Inspect the stackrox reports

Goto the vulnerability overview in stackrox

![Fail](../../images/risky-images.png?raw=true "Title")

Inspect the stackrox report for the image that was build

![Fail](../../images/customer-report.png?raw=true "Title")

Inspect the Customer Micro Service Dockerfile

![Fail](../../images/customer-docker-file.png?raw=true "Title")

Drill down on the critical vulnerability

![Fail](../../images/drill-down.png?raw=true "Title")

Find out what needs to be fixed:

![Fail](../../images/fix-version.png?raw=true "Title")

Take a carefull look at the recommended fix version.


# Let's go and build our defense.

Analyze the project using snyk, it recommends us to level up the pom of the microservice.

![Fail](../../images/snyk-recommendation.png?raw=true "Title")

You may fork the repo that we are building, and make the mod yourself. For the interest of time we suggest you use the pre-build branch with the fix version:

    oc create -f tekton-pipeline-run/customer-stackrox-pipeline-ibm-prevail-2021-fix-version.yaml
    scripts/watch-the-pipeline-run.sh

The pipeline now runs to completion:

![Fail](../../images/fix-version-pipelinerun.png?raw=true "Title")

Inspect the stackrox console and verify the vulnerability was successfully patched.

![Fail](../../images/fix-version-in-stackrox.png?raw=true "Title")
