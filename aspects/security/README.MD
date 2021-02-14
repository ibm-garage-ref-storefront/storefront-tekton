# Security

## Setup.

Setup the cluster as described in the "nuts and bolts section".

In short:
- the tools are setup with the administrative role (think installing operators);
- the blue compute namespace is setup with the developer role;


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
