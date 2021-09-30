# Welcome to IBM Prevail 2021

We will build, deploy and test the customer-ms-spring solo branch.

# StackRox Cluster Monitoring

## a) Verify

The tools setup will have installed stackrox. It needs to be configured to monitor the cluster.

Verify using:

    watch oc get po -n stackrox

Output:

    Every 2.0s: oc get po -n stackrox             kitty-catt-server.ibm.com: Sun Jul  4 12:24:21 2021

    NAME                          READY   STATUS    RESTARTS   AGE
    central-7df8c69d6b-lvdsb      1/1     Running   0          2m33s
    scanner-7dd9877c46-h2b7r      1/1     Running   0          2m33s
    scanner-7dd9877c46-jrnmp      1/1     Running   0          2m33s
    scanner-7dd9877c46-kq5x2      1/1     Running   0          2m33s
    scanner-db-74f5b84444-z65wv   1/1     Running   0          2m33s

# Create the API tokens

## a) Get the admin password

The tools setup has installed stackrox.

    helm get notes stackrox-central-services -n stackrox

We are looking for:

    helm get notes stackrox-central-services -n stackrox | grep password -A 2 | sed -n 4p | sed 's/^ *//g'

## b) Login to StackRox

Setup port-forwarding:

    oc port-forward svc/central -n stackrox 8443:443

Login via your browser, via right-click, open a new tab ["here"](https://localhost:8443). 

Use the login that was previously obtained. You should now be logged in:

![Fail](../../images/stackrox-login.png?raw=true "Title")

## c) Make the StackRox API tokens

Go to Platform Configuration, Integrations, Authentication Tokens, StackRox

Open it and create an API token of type Sensor.

![Fail](../../images/sensor-token.png?raw=true "Title")

Open it and create an API token of type Admin.

![Fail](../../images/admin-api-token.png?raw=true "Title")

Make sure you store the tokens.

Close the port-forwarding.

## d) Configure Cluster Monitoring

Keep the admin token at hand.

    bash tools/stackrox/secure-cluster-services.sh

Paste in the admin api token.

## e) Verify the state

Wait until stackrox has reconfigured itself:

    watch oc get po -n stackrox

Login to stackrox:

    oc port-forward svc/central -n stackrox 8443:443

Login via your browser, via right-click, open a new tab ["here"](https://localhost:8443). 

Verify that the cluster is monitored:

![Fail](../../images/cluster-is-monitored.png?raw=true "Title")

## e) Configure Compliance

Press the scan button.

![Fail](../../images/compliance.png?raw=true "Title")

## f) Inspect the vulnerable images

![Fail](../../images/vulnerability-management.png?raw=true "Title")

The blue compute customer-ms-spring image made it to the top of the list of vulnerable deployments. 

Lets handle it in the next section of the workshop.

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

Open it and create an API token of type CI integration.

![Fail](../../images/stackrox-api-token-type-ci.png?raw=true "Title")

Copy the token and store it safely.

## c) Connect StackRox to the OpenShift Image Registry

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

## b) The pipeline run now fails on the application image that was built  

![Fail](../../images/stackrox-plr.png?raw=true "Title")

## c) Inspect the Stackrox reports

Go to the vulnerability overview in Stackrox

![Fail](../../images/risky-images.png?raw=true "Title")

Inspect the Stackrox report for the image that was built

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
