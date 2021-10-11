# Welcome to IBM Prevail 2021

We will inspect the running status of the blue compute shop via stackrox **and** we will build, deploy and test the customer-ms-spring solo branch.

## Pre-requisites

### a) Deploy the IBM Blue Compute shop

[Deploy](../functionality/DEPLOY-FULL-BC.MD) the IBM Blue Compute shop if you have not already done so.

### b) Install the tooling and pipelines

[Install](../nuts-and-bolts/MINI-SETUP.MD) the tooling if you have not already done so.

### c) Scan and Import the Images

[Scan and Import](../nuts-and-bolts/SCAN.MD) the images that are used by the tool-chain if you have not already done so.

### d) Configure StackRox pipeline

[Configure](./RUNTIME.MD) StackRox pipeline if you have not already done so.

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

## f) Configure Compliance

Navigate to Compliance and then Press the Scan environment button.

![Fail](../../images/stackrox-compliance-scan-env.png?raw=true "Title")

![Fail](../../images/compliance.png?raw=true "Title")

## g) Inspect the vulnerable images

Navigate to Vulnerability Management to view the results of our scan.

![Fail](../../images/vulnerability-management.png?raw=true "Title")


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

We need to make an impact on:
```
oc new-project full-bc
oc adm policy add-scc-to-user anyuid -z customer-ms-spring-sa
```

So...
```
oc adm policy remove-scc-from-user anyuid -z customer-ms-spring-sa -n full-bc
### oc adm policy add-scc-to-user nonroot -z customer-ms-spring-sa -n full-bc
```

## TODO: Changes to SCC to ensure deployment yaml causes correct SCC to be used - show how securityContexts can help reduce attack vectors.
SCCs changing needs to be part of the previous section...

## TODO: Run container image with user=1001 and fixed Tomcat

We can now look at a container image with user != root and Tomcat at a fixed version:

    oc create -f tekton-pipeline-run/customer-stackrox-pipeline-ibm-prevail-2021-fix-version.yaml
    scripts/watch-the-pipeline-run.sh

The pipeline now runs to completion:

![Fail](../../images/fix-version-pipelinerun.png?raw=true "Title")

Inspect the stackrox console and verify the vulnerability was successfully patched.

![Fail](../../images/fix-version-in-stackrox.png?raw=true "Title")

## TODO: show that with SCCs, nonroot user, etc things are locked down
I.e. the story that a good container config + deployment yaml + correct use of SCCs and SAs makes a massive difference.
