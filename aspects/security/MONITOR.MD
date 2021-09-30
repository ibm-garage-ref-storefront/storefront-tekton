# Welcome to IBM Prevail 2021

We will inspect the running status of the blue compute shop via stackrox.

## Pre-requisites

### a) Deploy the IBM Blue Compute shop

[Deploy](../functionality/DEPLOY-FULL-BC.MD) the IBM Blue Compute shop if you have not already done so.

### b) Install the tooling and pipelines

[Install](../nuts-and-bolts/MINI-SETUP.MD) the tooling if you have not already done so.


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

Make sure you store the token.

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
