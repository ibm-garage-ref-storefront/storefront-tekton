## Import the images that we can use in our pipeline

The workshop pipelines have been edited to run exclusively on images in the tools-images namespace. How do they get there?

The images that are used to build the application image are scanned and if they are clean then they are imported into the tools-images project by the image-intake-pipeline. 

This pipeline can be inspected via the console:

![Fail](../../images/image-intake-pipeline-prevail-2021.png?raw=true "Title")

An image only gets into this namespace when it passes a security check.


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


### c) Delete the access key:

        oc delete secret registry-access 2>/dev/null

### d) Scan the necessary images for vulnerabilities and import it

A Tekton Task is executed via a pod that loads an image to perform the task. We will scan these images.

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

### f) Special: scan and Import UBI:8

Create a pipeline run that will fail when vulnerabilities of level  'UNKNOWN,LOW,MEDIUM,HIGH,CRITICAL' are detected and follow it:

    oc create -f scripts/tools-images/scan-ubi-8.0.yaml 
    scripts/watch-the-pipeline-run.sh

Notice that it fails to complete because the scanner detected vulnerabilities. 

Create a pipeline run that will fail when vulnerabilities of level  'CRITICAL' are detected and follow it:

    oc create -f scripts/tools-images/scan-ubi-8.0-fail-on-criticals-only.yaml 
    scripts/watch-the-pipeline-run.sh

Notice that it is possible to visually inspect the pipeline run via the web console as well:

![Fail](../../images/watch-the-intake.png?raw=true "Title")

Explore the images in the tools-images project:

    oc get is -n tools-images | grep ubi

The ubi:for-use image passed the security scan. It will be used for building the customer-ms-spring microservice. 


### B) Scan and Import the remaining images

Security specials (select one):

    oc create -f scripts/tools-images/scan-gcr-cloud-builders-mvn-3.5.0.yaml 
    oc create -f scripts/tools-images/scan-ibmgaragecloud-mvn-3.6.3-jdk-11-slim.yaml 

Note that the mvn image did not pass the scan. Let's make a decision to go with the IBM build image of mvn. Check the status: [here](https://quay.io/repository/ibmgaragecloud/maven?tab=tags):

    oc create -f scripts/tools-images/do-not-scan-ibmgaragecloud-mvn-3.6.3-jdk-11-slim.yaml 

## Checkpoint

You want to see the 8 images, check via:

    if [ $(oc get is -n tools-images | grep for-use | wc -l) -eq 8 ] ; then echo OK ; else echo NoK ; fi

When you have a NoK, then inspect the images:

    oc get is -n tools-images

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


### B) Fail Saves 

It might be that vulnerabilities are discovered on one of more images. In that case the PLR will not load the image into the tool rack, you may decide to close an eye and import it. 

    oc create -f scripts/tools-images/do-not-scan-alpine-git.yaml 
    oc create -f scripts/tools-images/do-not-scan-ibmgaragecloud-mvn-3.6.3-jdk-11-slim.yaml 
    oc create -f scripts/tools-images/do-not-scan-quayio-buildah-stable.yaml 
    oc create -f scripts/tools-images/do-not-scan-sonarsource-sonar-scanner-cli-latest.yaml 
    oc create -f scripts/tools-images/do-not-scan-ubi-8.0.yaml 
    oc create -f scripts/tools-images/do-not-scan-ubi-minimal.yaml 

