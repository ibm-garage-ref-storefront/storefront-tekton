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

Take some time to explore the vulnerabilties.

# Levelling up

## a) Level up the routes from HTTP to HTTPS

The default routes is are plain text http over tcp, ... so vulnerable to eavesdropping. Lets level them up to encrypted routes. 

    bash scripts/https-routes/level-up.sh

## b) Experimental pipeline to scan on CVE's

There is an experimental pipeline that will scan the customer-ms-spring microservices based on the NIST CVE database. The maven build will use the org.owasp.dependency-check-maven plugin to generate a maven site report. The report is presented on the silver-platter deployment that was created during the tools setup.

### spring-boot2 (does work)

    oc create -f tekton-tasks/kabanero-spring-boot2.yaml
    oc apply -f tekton-pipelines/pipeline-report-spring-boot2.yaml
    oc create -f tekton-pipeline-run/auth-run-experimental.yaml

### java-openliberty (does not work yet)

    oc create -f tekton-pipelines/pipeline-report-java-liberty.yaml 
    oc apply -f tekton-resources/auth-ms-liberty-resources-fork.yaml
    # oc create -f tekton-pipeline-run/auth-ms-liberty-run-experimental.yaml 

## c) Experiment with auth-ms-openliberty microservice

TODO:
- throttling;
- scan via pipeline.

Note: not quite ready, will break the shop login in its current state. Need to reconfigure shop.

    bash scripts/auth-ms-openliberty/level-up.sh 

Test:

    AUTHMS=$(oc get routes | grep auth-ms-openliberty | awk '{ print $2 }')

    export DATA=grant_type=password
    export DATA="${DATA}&client_id=bluecomputeweb"
    export DATA="${DATA}&client_secret=bluecomputewebs3cret"
    export DATA="${DATA}&username=foo"
    export DATA="${DATA}&password=bar"
    export DATA="${DATA}&scope=openid"

    curl -k -d "$DATA" https://$AUTHMS/oidc/endpoint/OP/token | jq .
