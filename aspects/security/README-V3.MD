# Welcome to IBM Prevail 2021

We will inspect the running status of the blue compute shop via stackrox.

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


## Taking Advantage of a Root Container
In this section we are going to see how Stackrox can show us where violations to policies have occurred.  Typically alerts would be set up to automatically alert system admins for breaches which can then be invetsigated.

## a) Enable policy Process with UID 0
We need to check that the runtime policy `Process with UID 0` is enabled on our Stackrox instance.
Navigate to System Policies then type `Process with UID 0` and select it so that it is shown as below

![Fail](../../images/stackrox-policy-process-uid-0-disabled.png?raw=true "Title")

Hoevr the mouse over the High severity and click `Enable policy`

![Fail](../../images/stackrox-policy-process-uid-0-enable.png?raw=true "Title")

There should now be a green circle showing that the policy is enabled.

![Fail](../../images/stackrox-policy-process-uid-0-enabled.png?raw=true "Title")

## b) Lets make some mischief in our container! <a name="root-container"></a>

Lets dive into the container and perform some actions as root then see what StackRox has noticed from our actions.

Run through the follwoing (right-click, new tab) [this](./TROUBLE.MD) and then return back here. 

As you have seen we can examine the impacts of running a container as root and we have done the following;
 - install lots of tools, with access to yum
 - create a user
 - We can also obtain and use environment variables
 - Further to this, we can utilise the installed tools like `tcpdump` and `nmap` to look at traffic and inspect the network around us
  - Given we can find pods' and nodes' IPs (`oc get pod -o wide`) perhaps we can do something here `nmap <pod-range>` or `nmap <node-range>`?

So we know we can do things that aren't required for the running of the specific application this pod was deployed to run (and these are just some basics), but the access to the package manager (`yum`) and being root user could potentially mean it is possible to [create a yum repository somewhere](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/6/html/deployment_guide/sec-yum_repository), or find a malicious external repository and then [add it to the container](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/6/html/deployment_guide/sec-managing_yum_repositories).
    
Or perhaps you'd like to install [crypto mining software](https://hostadvice.com/how-to/how-to-mine-cryptocurrency-with-cgminer-on-ubuntu/) - please do
It also allows us to look folders and files which could be used by a mallicious user to gain information or causse disruption such as accessing the etc/shadow file or /proc folder which is scary as by altering files located in this directory you can even read/change kernel parameters (sysctl) while the system is running.

## c) What has Stackrox noticed?

Now we have run some commands as root user lets have a look at stackrox to see what it has picked up.
Navigate to Violations and enter Deployment then press enter so it turns blue and then enter customer-ms-sprint and press enter.  This should now only show the customer-ms-spring deployment voilations as shown below.

![Fail](../../images/container-runtime-initial.png?raw=true "Title")

StackRox is detecting the actions taken at runtime and on deployment of the application.  Notice we can see Process with UID 0 has been triggered as well as our Linux add user commands.  In a real environment this should ring alarm bells! We can elect as whether we wish for enforcement action to be taken.

## d) Limiting the scope of policies

If you clear the ms-customer-spring and deployment filter and now filter on `Policy` & `Process with UID 0` we may see other containers running with a UID of 0.

![Fail](../../images/stackrox-policy-process-uid-0-enabled.png?raw=true "Title")

In reality we may not be able to change these and accept that we are happy to allow them to run as root.  So how do we limit the scope to ensure that we only enforce that root user is not allowed on our deployment only but not affect other deployments?

Naviagte to Platform Configuration \> System Policies then type "Process with UID 0" in the filter search.

Click on edit and scroll done to Restrict to Scope section and click the plus icon

Type full-bc

![Fail](../../images/stackrox-process-with-uid-restrict-to-scope.png?raw=true "Title")

Click Next > Next > Next and Save

Navigate to Violations and type Policy + Process UID 0 into the filter box.  We should now see that only the customer-ms-spring is returned, which is what we want as all other namespaces are now ignored.

![Fail](../../images/stackrox-violation-uid-limited-to-full-bc.png?raw=true "Title")

## e) Enforcing UID 0 Policy

Now we have limited the scope to just our container we can enforce the policy, safe in the knowledge that nothing else will be inadvertantly affected.

Naviagte to Platform Configuration \> System Policies then type "Process with UID 0" in the filter search.

Click on edit > Next > Next > Next and turn Enforcement Behaviour on as shown below nd press save.

![Fail](../../images/stackrox-process-with-uid-enforce.png?raw=true "Title")

Let's take a look at see what's happened to our container:
```
oc rsh $(oc get po -l deployment=customer-ms-spring --output custom-columns=:.metadata.name)
```

As we see we cannot exec into the container as we are trying to login to the containe rwith UID 0 which is not allowed and our container is terminated.  A new one will be created automatically due to the deployment, although that will be terminated as soon as UID 0 process is started. StackRox has taken an action on our container!

However this should be used as a secondary line of defence, with good container configuration hygiene being the correct resolution (i.e. create a user in your container configuration to ensure it doesn't default to root, or worse, you specifiy root as the user without good reason).

Alongside good container hygiene and StackRox monitoring, there is an additional line of defence to be aware of...

## Admission Control: Security Context Constraints (SCCs)
OpenShift very kindly provides an opinionated set of deployment policies, called Security Context Constraints (SCCs). You may remember back in the initial labs, we did what most developers like to do - we took a shortcut.
```
oc new-project full-bc
oc adm policy add-scc-to-user anyuid -z customer-ms-spring-sa
```

It might not seem like much, but what we did here was to say that the service account (i.e. the programmtic account) assigned to our deployment was allowed to make deployments (within the `full-bc` project) aligned with the `anyuid` SCC. This SCC, as the name suggests, permits workloads to run as "anyuid", which includes root (uid=0). This shows just how easy it can be to "slacken security contraints". It might help us initially, but it sets us down the road of bad practice and could cause us (security) problems later on.

So... what simple change can we try, in order to revert this?
```
oc project full-bc
oc adm policy remove-scc-from-user anyuid -z customer-ms-spring-sa
```

And then amend the replicas to invoke the change in SCC used:
```
oc scale --replicas=0 deployment/customer-ms-spring
oc scale --replicas=1 deployment/customer-ms-spring
```

Then take a look at the pods
```
oc get pods
```

Create a remote shell into the newly created customer-ms-spring pod:

```
oc rsh $(oc get po -l deployment=customer-ms-spring --output custom-columns=:.metadata.name)
```

Firstly we can now exec into the pod! Stackrox is no longer taking action on the pod.

Now try and see if how many of [these things](./TROUBLE.MD) (right-click, new tab) you can still do.

By removing the permission to use the anyuid SCC, the customer-ms-spring service account fell back to the default SCC, named `restricted`. This SCC doesn't permit a container to run as root and it causes an arbitrary UID to be assigned - how great is that?! Alongside this, it also doesn't permit [privileged](https://kubernetes.io/docs/concepts/policy/pod-security-policy/#privileged) containers, nor access to the underlying host's [namespaces](https://kubernetes.io/docs/concepts/policy/pod-security-policy/#host-namespaces). The restricted SCC on OpenShift is incredibly useful, and developers should align every deployment to it where possible.

But we haven't yet done the best thing regarding the user of our customer-ms-spring container. By not specifying a non-root user, we are at risk that someone will deploy it under an SCC that doesn't enforce a non-root rule. So what should we do...

## Specify Non-root user in Container Image

We can now look at a container image with user != root and Tomcat at a fixed version, see the Dockerfile [here](https://github.com/kitty-catt/customer-ms-spring/blob/fix-version/Dockerfile).

    RUN chown -R 1001:0 /opt/app-root && \
        chmod -R g=u /opt/app-root &&\
        chgrp -R 0 /opt/app-root
    
    USER 1001
    EXPOSE 8080

Notice how the user's UID (1001) is specified and that `chown`, `chmod` and `chgrp` commands have been run to ensure this user has the correct permissions to the directories it needs.

**Fun fact:** OpenShift restricted SCC applies and arbitrary UID rather than the one specified in the container image, as well as setting the user in the root group (GID=0). This is why the configuration above specifies the ownership is `1001:0` (user=1001, group=0) and `chmod -R g=u` (so that the group has the same permissions assigned to the user). These small bits of configuration help ensure compatibility with the OpenShift restricted SCC.

Run this command to initiate a pipelineRun using this container image:
    oc project pipelines
    oc create -f tekton-pipeline-run/customer-stackrox-pipeline-ibm-prevail-2021-fix-version.yaml
    scripts/watch-the-pipeline-run.sh

The pipeline now runs to completion:

![Fail](../../images/fix-version-pipelinerun.png?raw=true "Title")

Inspect the stackrox console and verify the vulnerability was successfully patched.

![Fail](../../images/fix-version-in-stackrox.png?raw=true "Title")

## Summary: Container Security layering
Secure container config + secure workload yaml + correct use of SCCs and SAs = Good container security
