## Load the tool rack.

The workshop pipelines have been edited to run exclusively on images in the tools-images namespace. How do they get there?

The images that are used to build the application image are scanned and if they are clean then they are imported into the tools-images project by the image-intake-pipeline. There is an option to consciously skip the scan.  

This pipeline can be inspected via the console (via pipelines). 

The following picture shows a result of a run of this pipeline on one of the images of the workshop.

![Fail](../../images/image-intake-pipeline-prevail-2021.png?raw=true "Title")

An image only gets into this namespace when it passes a security check.

## Import the custom build images into the rack

### a) Scan the JMeter image for vulnerabilities

The tools setup build 2 images in the tools namespace. JMeter and Stackrox.

We will scan the JMeter image for vulnerabilities before we use it in the Tekton pipeline. 

    oc project pipelines

    oc create secret generic registry-access \
        --from-literal REGISTRY_USER=$(oc whoami) \
        --from-literal REGISTRY_PASSWORD=$(oc whoami -t)

    oc create -f scripts/tools-images/scan-jmeter-prevail-2021.yaml 
    scripts/watch-the-pipeline-run.sh

You will find that the jmeter image itself does have CRITICAL vulnerabilies. 

Let's close an eye ..

    oc create -f scripts/tools-images/do-not-scan-jmeter-prevail-2021.yaml
    scripts/watch-the-pipeline-run.sh    

And check it:

    oc get is -n tools-images


### b) Scan the stackrox image for vulnerabilities

We will also scan the stackrox image before we build it:

    oc create -f scripts/tools-images/scan-stackrox-prevail-2021.yaml
    scripts/watch-the-pipeline-run.sh    

Also here CRITICAL vulnerabilities are found. 

Let's close the eye again ..

    oc create -f scripts/tools-images/do-not-scan-stackrox-prevail-2021.yaml
    scripts/watch-the-pipeline-run.sh

Inspect the result of the import:

    oc get is -n tools-images

## Checkpoint

You want to see the 2 images before you proceed, check via:

    if [ $(oc get is -n tools-images | grep for-use | wc -l) -eq 2 ] ; then echo OK ; else echo NoK ; fi

When you have a NoK, then inspect the images:

    oc get is -n tools-images | grep for-use | awk ' { print $1 } '

The expected result:

    NAME                            IMAGE REPOSITORY                                                                              TAGS                        UPDATED
    jmeter-prevail-2021             image-registry.openshift-image-registry.svc:5000/tools-images/jmeter-prevail-2021             for-use,latest              49 minutes ago
    stackrox-ubi                    image-registry.openshift-image-registry.svc:5000/tools-images/stackrox-ubi                    for-use,latest              41 minutes ago

Repair the situation if necessary.


### d) Delete the access key for the openshift image registry

A key is precious thing. We do not let it linger more than necessary.

        oc delete secret registry-access 2>/dev/null

We will now continue to import public images into the tool rack. 


## Import public images into the rack

### a) Scan the necessary images for vulnerabilities and import it

The Tekton Pipeline consists of a series of Tekton Tasks. Each Tasks loads a container image to perform the task. We will scan these images.

    oc create -f scripts/tools-images/scan-alpine-git.yaml
    oc create -f scripts/tools-images/scan-quayio-buildah-stable.yaml
    oc create -f scripts/tools-images/scan-sonarsource-sonar-scanner-cli-latest-fail-on-high-or-critical.yaml
    oc create -f scripts/tools-images/scan-ubi-minimal-fail-on-criticals.yaml 

Wait until the pipeline runs complete:

    watch tkn pipelinerun list

Explore the images in the tools-images project:

    oc get is -n tools-images | grep sonarsource-sonar-scanner-cli
    oc get is -n tools-images | grep buildah
    oc get is -n tools-images | grep ubi-minimal
    oc get is -n tools-images | grep alpine-git

If an image fails to import then we will repair this at the end of this excercise (see the fail-save section).

### b) Special: scan and Import UBI 8

Create a pipeline run that will fail when vulnerabilities of level  'UNKNOWN,LOW,MEDIUM,HIGH,CRITICAL' are detected and follow it:

    oc create -f scripts/tools-images/scan-ubi-8.4.yaml 
    scripts/watch-the-pipeline-run.sh

Notice that it fails to complete because the scanner detected vulnerabilities. 

Create a pipeline run that will fail when vulnerabilities of level  'CRITICAL' are detected and follow it:

    oc create -f scripts/tools-images/scan-ubi-8.4-fail-on-criticals-only.yaml 
    scripts/watch-the-pipeline-run.sh

Explore the images in the tools-images project:

    oc get is -n tools-images | grep ubi

The ubi:for-use image passed the security scan. It will be used for building the customer-ms-spring microservice. 


### c) Special: scan and Import Maven

Scan and import maven:

    oc create -f scripts/tools-images/scan-ibmgaragecloud-mvn-3.6.3-jdk-11-slim.yaml 

Note that the mvn image did not pass the scan. Let's make a decision to go with the IBM build image of mvn. 

    oc create -f scripts/tools-images/do-not-scan-ibmgaragecloud-mvn-3.6.3-jdk-11-slim.yaml 

Note: check the security status of this image: ["click here"](https://quay.io/repository/ibmgaragecloud/maven?tab=tags).


## Checkpoint

You want to see the 8 images, check via:

    if [ $(oc get is -n tools-images | grep for-use | wc -l) -eq 8 ] ; then echo OK ; else echo NoK ; fi

When you have a NoK, then inspect the images:

    oc get is -n tools-images | grep for-use | awk ' { print $1 } '

The expected result:

    NAME                            IMAGE REPOSITORY                                                                              TAGS                        UPDATED
    alpine-git                      image-registry.openshift-image-registry.svc:5000/tools-images/alpine-git                      for-use,latest              13 minutes ago
    buildah                         image-registry.openshift-image-registry.svc:5000/tools-images/buildah                         for-use,stable              17 minutes ago
    jmeter-prevail-2021             image-registry.openshift-image-registry.svc:5000/tools-images/jmeter-prevail-2021             for-use,latest              49 minutes ago
    mvn                             image-registry.openshift-image-registry.svc:5000/tools-images/mvn                             for-use,3.6.3-jdk-11-slim   About a minute ago
    sonarsource-sonar-scanner-cli   image-registry.openshift-image-registry.svc:5000/tools-images/sonarsource-sonar-scanner-cli   for-use,latest              17 minutes ago
    stackrox-ubi                    image-registry.openshift-image-registry.svc:5000/tools-images/stackrox-ubi                    for-use,latest              41 minutes ago
    ubi                             image-registry.openshift-image-registry.svc:5000/tools-images/ubi                             8.0,for-use                 26 seconds ago
    ubi-minimal                     image-registry.openshift-image-registry.svc:5000/tools-images/ubi-minimal                     for-use,latest              24 seconds ago

Note: the performance section of the workshop will scan and import several additional images which are listed here.


## Fail Saves 

It might be that vulnerabilities are discovered on one of more images. In that case the PLR will not load the image into the tool rack, you may decide to close an eye and import it. 

    oc create -f scripts/tools-images/do-not-scan-alpine-git.yaml 
    oc create -f scripts/tools-images/do-not-scan-ibmgaragecloud-mvn-3.6.3-jdk-11-slim.yaml 
    oc create -f scripts/tools-images/do-not-scan-quayio-buildah-stable.yaml 
    oc create -f scripts/tools-images/do-not-scan-sonarsource-sonar-scanner-cli-latest.yaml 
    oc create -f scripts/tools-images/do-not-scan-ubi-8.4.yaml  
    oc create -f scripts/tools-images/do-not-scan-ubi-minimal.yaml 

