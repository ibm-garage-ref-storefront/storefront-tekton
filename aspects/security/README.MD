# Security

## Understanding the pipeline

We will be building the customer image in this excercise.

![Security Pipeline](../../images/security-pipeline.png?raw=true "Title")

The tekton appsody build log reveals a chained build reveals where openjdk18-openshift:1.8 is used as the parent for the application image that is build:

    grep FROM ~/Downloads/appsody-build.log 
    [Buildah] STEP 1: FROM kabanero/ubi8-maven:0.10.2 AS compile
    [Buildah] STEP 16: FROM registry.access.redhat.com/redhat-openjdk-18/openjdk18-openshift:1.8

In words:
- the pipeline scans the base image that is used to build the application image (openjdk18-openshift:1.8)
- the pipeline builds to an internal image stream (e.g. customer);
- next it copies the image from the internal registry to both quay and IBM container registry;
- Redhat and IBM container registries will start to analyse the images for vulnerabilities;
- next the pipeline analyzes the source and dependencies for vulnerabilities using sonarqube and maven owasp dependency checker. 
- The pipeline then queries icr, quay and trivy to get the vulnerabilities in the images.
- If there are no vulnerabilities then the pipeline will roll-out the image.

## Setup.

1. Get a cluster ["click here"](../general/README.MD);
2. Clone the git repo ["click here"](../nuts-and-bolts/GIT.MD);
3. Setup the tools namespace ["click here"](../nuts-and-bolts/TOOLS.MD);
4. Prepare the configuration ["click here"](../nuts-and-bolts/CONFIG.MD).
5. Setup the blue compute namespace ["click here"](../nuts-and-bolts/BLUE-COMPUTE.MD);

# Check logins

Can developer login to the openshift internal registry?

    sudo docker login -u developer -p $(oc whoami -t) \
     default-route-openshift-image-registry.apps-crc.testing \
     --tls-verify=false
    oc describe rolebinding system:image-puller

Note: the openshift image registry wants the password in the form of a token .. which lasts a few hours.

    oc get secret crc-creds-skopeo
    oc extract secret/crc-creds-skopeo --to=-
    oc whoami -t

Regenerate the secret when it has expired:

    bash scripts/pipeline/recycle-crc-skopeo-secret.sh 


# Run the security pipeline

Create a run:

    oc create -f tekton-pipeline-run/customer-security-pipeline.yaml 

Follow it:

    PL=$(tkn pr list | grep Running | awk '{ print $1 }') && tkn pr logs -f $PL

Notes: 
- copy to quay will fail the first time, because the image repo does not exist. Just re-run the pipeline.
- the pipeline builds the customer image stream that is used by the customer-ms-spring microservice.
- if you want to scan a different image then please run the pipeline with different parameters.

You will find it will fail quickly on the first step. 

![Fail](../../images/quick-fail.png?raw=true "Title")

That is because the base image was not secure.

Give it a new go:

    oc create -f tekton-pipeline-run/customer-security-pipeline-fail-on-criticals-only.yaml

# Checks

## a) Check the image CVE status in IBM Container Registry 

![ICR VA](../../images/ICR.png?raw=true "Title")

## b) Check the image CVE status in Redhat Quay Container Registry 

![Quay VA](../../images/QUAY.png?raw=true "Title")

## c) Check the vulnerabilities  that were detected by the OWASP dependency checker

![Report](../../images/owasp-dependency-check-1.png?raw=true "Title")

Click on the link "dependency-check:aggregate":

![OWASP](../../images/owasp-dependency-check-2.png?raw=true "Title")

Take some time to explore the vulnerabilties. Click on the links in the report to visit the NIST database that provides guidance on how to fix the vulnerabilities. 

## d) Check the vulnerabilities  that were detected by the SonarQube scanner

![Report](../../images/sonar-qube.png?raw=true "Title")


# Levelling up

## a) Install Snyk

Download and Install Maven:

    cd ~
    mv Downloads/apache-maven-3.6.3-bin.tar.gz .
    tar xvf apache-maven-3.6.3-bin.tar.gz 
    cd bin
    ln -sf /home/kitty-catt/apache-maven-3.6.3/bin/mvn mvn
    mvn -version
    mvn install -q -f aspects/security/appsody-boot2-pom.xml 

Install the Redhat Dependency Analytics [plugin](https://marketplace.visualstudio.com/items?itemName=redhat.fabric8-analytics) in vs code.

Clone the customer-ms-spring microservice [repo](https://github.com/kitty-catt/customer-ms-spring) and inspect it with Snyk.

Create a free Snyk account and get your token.

Inspect the report.

![Report](../../images/snyk.png?raw=true "Title")

Create a clone of the repo. See if you can improve the security of the image via the snyk & owasp report suggestions. Update the tekton resource to build your clone. 


## b) Level up the routes from HTTP to HTTPS

The default routes is are plain text http over tcp, ... so vulnerable to eavesdropping. Lets level them up to encrypted routes. 

    bash scripts/https-routes/level-up.sh

