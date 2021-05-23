# Welcome to IBM Prevail 2021

The IBM Blue Compute shop will be performance tested. The pipeline is stubbed except for the performance test.

## Pre-requisites

### a) Deploy the IBM Blue Compute shop

[Deploy](../functionality/DEPLOY-FULL-BC.MD) the IBM Blue Compute shop if you have not allready done so.

### b) Install the tooling and pipelines

[Install](../nuts-and-bolts/MINI-SETUP.MD) the tooling if you have not allready done so.


## Import the images for the performance pipeline

The tools setup build a JMeter image in the tools namespace:

    oc get is -n tools | grep jmeter

The workshop pipelines have been edited to run exclusively on images in the tools-images namespace. 

An image only gets into this namespace when it passes a security check.

Therefore, we will first inspect the JMeter image.

### a) Scan the JMeter image for vulnerabilities

We will scan the JMeter image for vulnerabilities before we use it in the Tekton pipeline. 

    oc create secret generic registry-access \
        --from-literal REGISTRY_USER=$(oc whoami) \
        --from-literal REGISTRY_PASSWORD=$(oc whoami -t)

    oc create -f scripts/tools-images/scan-jmeter-prevail-2021.yaml 
    scripts/watch-the-pipeline-run.sh

You will find that the jmeter image itself does have critical vulnerabilies. 

Let's close an eye ..

    oc create -f scripts/tools-images/do-not-scan-jmeter-prevail-2021.yaml
    scripts/watch-the-pipeline-run.sh    

Inspect the result of the import:

    $ oc get is -n tools-images
    NAME                  IMAGE REPOSITORY                                                                           TAGS             UPDATED
    jmeter-prevail-2021   default-route-openshift-image-registry.apps-crc.testing/tools-images/jmeter-prevail-2021   for-use,latest   13 seconds ago

Delete the access key:

        oc delete secret registry-access 2>/dev/null

### b) Scan the necessary images for vulnerabilities and import it

    oc create -f scripts/tools-images/scan-alpine-git.yaml
    oc create -f scripts/tools-images/scan-ubi-minimal-fail-on-criticals.yaml 


### c)  Check the result

    $ oc get is -n tools-images
    NAME                  IMAGE REPOSITORY                                                                           TAGS             UPDATED
    alpine-git            default-route-openshift-image-registry.apps-crc.testing/tools-images/alpine-git            for-use,latest   6 minutes ago
    jmeter-prevail-2021   default-route-openshift-image-registry.apps-crc.testing/tools-images/jmeter-prevail-2021   for-use,latest   13 minutes ago
    ubi-minimal           default-route-openshift-image-registry.apps-crc.testing/tools-images/ubi-minimal           for-use,latest   25 seconds ago


# The performance pipeline

The peformance pipeline looks similar to the security pipeline. 

![Fail](../../images/performance-pipeline.png?raw=true "Title")

There is one difference: all tasks except for the performance test have been stubbed.


## Lets run the performance pipeline

Lets create a run with 5 parallel users, each executing the JMeter testplan 25 times.

    oc create -f tekton-pipeline-run/customer-performance-pipeline-ibm-prevail-2021.yaml 
    scripts/watch-the-pipeline-run.sh  

It is possible to watch the pipeline run via the graphical console as well.

![Fail](../../images/performance-test-run.png?raw=true "Title")


## Inspect the performance dashboard.

![Fail](../../images/performance-test.png?raw=true "Title")


## Ramp it up

Lets create another run with 10 parallel users, each executing the JMeter testplan 25 times.

    oc create -f tekton-pipeline-run/customer-performance-pipeline-ibm-prevail-2021-10-users.yaml 