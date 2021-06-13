## Import the images for the performance and functionality pipeline

The tools setup build a JMeter image in the tools namespace:

    oc get is -n tools | grep jmeter

The workshop pipelines have been edited to run exclusively on images in the tools-images namespace. 

An image only gets into this namespace when it passes a security check.

Therefore, we will first inspect the JMeter image.

### a) Scan the JMeter image for vulnerabilities

We will scan the JMeter image for vulnerabilities before we use it in the Tekton pipeline. 

    oc project pipelines
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

    oc get is -n tools-images

The expected result:

    NAME                  IMAGE REPOSITORY                                                                           TAGS             UPDATED
    jmeter-prevail-2021   default-route-openshift-image-registry.apps-crc.testing/tools-images/jmeter-prevail-2021   for-use,latest   13 seconds ago

Delete the access key:

        oc delete secret registry-access 2>/dev/null

### b) Scan the necessary images for vulnerabilities and import it

    oc create -f scripts/tools-images/scan-alpine-git.yaml
    oc create -f scripts/tools-images/scan-ubi-minimal-fail-on-criticals.yaml 

Wait until the pipeline runs complete:

    watch tkn pipelinerun list


### c)  Check the result

    oc get is -n tools-images

The expected result:

    NAME                  IMAGE REPOSITORY                                                                           TAGS             UPDATED
    alpine-git            default-route-openshift-image-registry.apps-crc.testing/tools-images/alpine-git            for-use,latest   6 minutes ago
    jmeter-prevail-2021   default-route-openshift-image-registry.apps-crc.testing/tools-images/jmeter-prevail-2021   for-use,latest   13 minutes ago
    ubi-minimal           default-route-openshift-image-registry.apps-crc.testing/tools-images/ubi-minimal           for-use,latest   25 seconds ago

### d) Fail saves for the functionality and performance section of the pipeline

It might be that vulnerabilities are discovered on one of more images. You may choose to close your eyes:

    oc create -f scripts/tools-images/do-not-scan-jmeter-prevail-2021.yaml
    oc create -f scripts/tools-images/do-not-scan-ubi-minimal.yaml
    oc create -f scripts/tools-images/do-not-scan-alpine-git.yaml 

## Import the images for the Security Pipeline

### A) Scan and Import UBI:8

The images that are used to build the application image are scanned and if they are clean then they are imported into the tools-images project by the image-intake-pipeline. This pipeline can be inspected via the console:

![Fail](../../images/image-intake-pipeline-prevail-2021.png?raw=true "Title")


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

    oc get is -n tools-images

The expected result:

    NAME   IMAGE REPOSITORY                                                           TAGS          UPDATED
    ubi    default-route-openshift-image-registry.apps-crc.testing/tools-images/ubi   8.0,for-use   12 seconds ago

The ubi:for-use image passed the security scan. It will be used for building the customer-ms-spring microservice. 

### A) Scan and Import the tools images

A Tekton Task is executed via a pod that loads an image to perform the task. We will scan these images.

    oc create -f scripts/tools-images/scan-sonarsource-sonar-scanner-cli-latest-fail-on-high-or-critical.yaml
    oc create -f scripts/tools-images/scan-ubi-minimal-fail-on-criticals.yaml 
    oc create -f scripts/tools-images/scan-quayio-buildah-stable.yaml

Explore the images in the tools-images project:

    NAME                            IMAGE REPOSITORY                                                                                     TAGS             UPDATED
    buildah                         default-route-openshift-image-registry.apps-crc.testing/tools-images/buildah                         for-use,stable   34 seconds ago    
    sonarsource-sonar-scanner-cli   default-route-openshift-image-registry.apps-crc.testing/tools-images/sonarsource-sonar-scanner-cli   for-use,latest   2 days ago
    ubi                             default-route-openshift-image-registry.apps-crc.testing/tools-images/ubi                             for-use,8.0      2 days ago
    ubi-minimal                     default-route-openshift-image-registry.apps-crc.testing/tools-images/ubi-minimal                     for-use,latest   28 seconds ago


Security specials (select one):

    oc create -f scripts/tools-images/scan-gcr-cloud-builders-mvn-3.5.0.yaml 
    oc create -f scripts/tools-images/scan-ibmgaragecloud-mvn-3.6.3-jdk-11-slim.yaml 

Note that the mvn image did not pass the scan. Let's make a decision to go with the [IBM image](https://quay.io/repository/ibmgaragecloud/maven?tab=tags):

    oc create -f scripts/tools-images/do-not-scan-ibmgaragecloud-mvn-3.6.3-jdk-11-slim.yaml 

Also, the same is true for the sonar-qube image. Lets once more close the eye. 

    oc create -f scripts/tools-images/do-not-scan-sonarsource-sonar-scanner-cli-latest.yaml

Inspect the images:

    oc get is -n tools-images

The expected result:

    NAME                            IMAGE REPOSITORY                                                                              TAGS                        UPDATED
    alpine-git                      image-registry.openshift-image-registry.svc:5000/tools-images/alpine-git                      for-use,latest              48 minutes ago
    buildah                         image-registry.openshift-image-registry.svc:5000/tools-images/buildah                         for-use,stable              3 minutes ago
    jmeter-prevail-2021             image-registry.openshift-image-registry.svc:5000/tools-images/jmeter-prevail-2021             for-use,latest              49 minutes ago
    mvn                             image-registry.openshift-image-registry.svc:5000/tools-images/mvn                             for-use,3.6.3-jdk-11-slim   12 seconds ago
    sonarsource-sonar-scanner-cli   image-registry.openshift-image-registry.svc:5000/tools-images/sonarsource-sonar-scanner-cli   for-use,latest              3 minutes ago
    ubi                             image-registry.openshift-image-registry.svc:5000/tools-images/ubi                             8.0,for-use                 5 minutes ago
    ubi-minimal                     image-registry.openshift-image-registry.svc:5000/tools-images/ubi-minimal                     for-use,latest              48 minutes ago

Note: the performance section of the workshop will scan and import several additional images which are listed here.


### B) Fail Saves for the security section of the pipeline

In case one of the images fails to import, you may decide to close an eye and import it. 

    oc create -f scripts/tools-images/do-not-scan-ubi-8.0.yaml 
    oc create -f scripts/tools-images/do-not-scan-ubi-minimal.yaml 
    oc create -f scripts/tools-images/do-not-scan-sonarsource-sonar-scanner-cli-latest.yaml 
    oc create -f scripts/tools-images/do-not-scan-ibmgaragecloud-mvn-3.6.3-jdk-11-slim.yaml 
    oc create -f scripts/tools-images/do-not-scan-quayio-buildah-stable.yaml 