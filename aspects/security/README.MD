# Security

## Understanding the pipeline

We will be building the customer image in this excercise.

![Security Pipeline](../../images/security-pipeline.png?raw=true "Title")

In words:
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

    sudo podman login -u developer -p $(oc whoami -t) \
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

## a) Level up the routes from HTTP to HTTPS

The default routes is are plain text http over tcp, ... so vulnerable to eavesdropping. Lets level them up to encrypted routes. 

    bash scripts/https-routes/level-up.sh

