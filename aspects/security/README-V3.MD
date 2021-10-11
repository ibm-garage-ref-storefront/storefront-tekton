# Welcome to IBM Prevail 2021

We will inspect the running status of the blue compute shop via stackrox **and** we will build, deploy and test the customer-ms-spring solo branch.

## Pre-requisites

### a) Deploy the IBM Blue Compute shop

[Deploy](../functionality/DEPLOY-FULL-BC.MD) the IBM Blue Compute shop if you have not already done so.

### b) Install the tooling and pipelines

[Install](../nuts-and-bolts/MINI-SETUP.MD) the tooling if you have not already done so.

### c) Scan and Import the Images

[Scan and Import](../nuts-and-bolts/SCAN.MD) the images that are used by the tool-chain if you have not already done so.

# StackRox Cluster Monitoring

## a) Verify

The tools setup will have installed StackRox. It needs to be configured to monitor the cluster.

Verify using:

    oc get po -n stackrox

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

The tools setup has installed StackRox.

    helm get notes stackrox-central-services -n stackrox

We are looking for:

    helm get notes stackrox-central-services -n stackrox | grep password -A 2 | sed -n 4p | sed 's/^ *//g'

## b) Login to StackRox

Setup port-forwarding:

    oc port-forward svc/central -n stackrox 8443:443

Login via your browser, via right-click, open a new tab ["here"](https://localhost:8443). (You can ignore the privacy error in your browser)

Use the password that was previously obtained (the user account is "admin"). You should now be logged in:

![Fail](../../images/stackrox-login.png?raw=true "Title")

## c) Make the StackRox API tokens

Go to Platform Configuration, Integrations, Authentication Tokens, StackRox

![Fail](../../images/stackrox-platform-config.png?raw=true "Title")

Click on New Integration and create an API token with Token Name set to sensor_api_token and a role of Sensor Creator.

![Fail](../../images/stackrox-api-token.png?raw=true "Title")

![Fail](../../images/stackrox-sensor-token-1.png?raw=true "Title")  

Copy the generated Token as we will use this later.

Create a API token with Token Name set to admin_api_token & Role set to Admin.

![Fail](../../images/stackrox-admin-api-token.png?raw=true "Title")

Copy the generated Token as we will use this later.

Your integrations screen should have 2 integrations shown as below;

![Fail](../../images/stackrox-integrations.png?raw=true "Title")

Close the port-forwarding.

## d) Configure Cluster Monitoring

Keep the admin token at hand.

    bash tools/stackrox/secure-cluster-services.sh

Paste in the admin api token when prompted.

## e) Verify the state

Wait until stackrox has reconfigured itself by running the command `oc get po -n stackrox` until all pods are started or you can add the parameter `-w` or `--watch` to your command. This parameter will watch for status changes and will display them. So to watch your pods use the command:

    oc get po -n stackrox -w

Hint: To stop watch just hit ctrl & c.

Output:

    NAME                                 READY   STATUS    RESTARTS   AGE
    admission-control-555f6c6c8b-l8x97   1/1     Running   0          94s
    admission-control-555f6c6c8b-xbdf6   1/1     Running   0          94s
    admission-control-555f6c6c8b-znhj4   1/1     Running   0          94s
    central-675bb87b56-k8fpj             1/1     Running   0          3d13h
    collector-29sv9                      2/2     Running   0          94s
    collector-jk7cb                      2/2     Running   0          94s
    collector-w6vmn                      2/2     Running   0          94s
    scanner-6f69b6d8d6-27jxk             1/1     Running   0          42s
    scanner-6f69b6d8d6-5srdz             1/1     Running   0          3d13h
    scanner-6f69b6d8d6-f297z             1/1     Running   0          57s
    scanner-6f69b6d8d6-hrtdv             1/1     Running   0          57s
    scanner-6f69b6d8d6-j588m             1/1     Running   0          3d13h
    scanner-db-857d66bccd-mdc4m          1/1     Running   0          3d13h
    sensor-549f459476-qjqrv              1/1     Running   0          94s

Notice we have some new pods to our Stackrox deployment now, admission-controler, collector and sensor pods.

Login to stackrox:

    oc port-forward svc/central -n stackrox 8443:443

Login via your browser, via right-click, open a new tab ["here"](https://localhost:8443/main/clusters). 

Verify that the cluster is monitored:

![Fail](../../images/cluster-is-monitored.png?raw=true "Title")

## e) Configure Compliance

Navigate to Compliance and then Press the Scan environment button.

![Fail](../../images/stackrox-compliance-scan-env.png?raw=true "Title")

![Fail](../../images/compliance.png?raw=true "Title")

## f) Inspect the vulnerable images

Navigate to Vulnerability Management to view the results of our scan.

![Fail](../../images/vulnerability-management.png?raw=true "Title")

The blue compute customer-ms-spring image made it to the top 10 list of riskiest images!!

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

## a) Run the pipeline

    oc create -f tekton-pipeline-run/customer-stackrox-pipeline-ibm-prevail-2021.yaml
    scripts/watch-the-pipeline-run.sh

## b) The pipeline run now fails on the application image that was built  

![Fail](../../images/stackrox-plr.png?raw=true "Title")

## c) Inspect the Stackrox reports

Go to the vulnerability overview in Stackrox

(**Note:** You can "right-click > new tab" on this direct link: https://localhost:8443/main/vulnerability-management/images and then filter on "Images:" and the image name)

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


# Let's go and build our defense.

Analyze the project using Snyk, it recommends us to level up the pom of the microservice.

## Install Snyk

Install the Redhat Dependency Analytics [plugin](https://marketplace.visualstudio.com/items?itemName=redhat.fabric8-analytics) in VS Code.

Clone the customer-ms-spring microservice [repo](https://github.com/kitty-catt/customer-ms-spring) and inspect the branch named **solo** with Snyk (it is very important to inspect the correct branch, otherwise the results of the inspection will not be accurate).

If not already done, create a free Snyk account and get your token.

## Snyk Recommendation

Inspect the report:

![Fail](../../images/snyk-recommendation.png?raw=true "Title")

You may fork the repo that we are building, and make the mod yourself. For the interest of time we suggest you use the pre-build branch with the fix version:

    oc create -f tekton-pipeline-run/customer-stackrox-pipeline-ibm-prevail-2021-fix-version.yaml
    scripts/watch-the-pipeline-run.sh

The pipeline now runs to completion:

![Fail](../../images/fix-version-pipelinerun.png?raw=true "Title")

Inspect the stackrox console and verify the vulnerability was successfully patched.

![Fail](../../images/fix-version-in-stackrox.png?raw=true "Title")
