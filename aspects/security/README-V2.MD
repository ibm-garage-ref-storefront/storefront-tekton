# We will build the customer-ms-spring solo branch

## Setup the security pipeline

It is assumed that you have allready setup the pipelines project.

    oc login -u developer
    oc project pipelines

    oc apply -f tekton-resources/customer-ms/customer-ms-spring-solo.yaml
    oc apply -f tekton-pipelines/pipeline-security-experimental-solo.yaml 
    oc apply -f tekton-tasks/aot-mockup.yaml 
    oc apply -f tekton-tasks/aot-maven-settings.yaml 
    oc apply -f tekton-tasks/aot-maven-task.yaml 
    oc apply -f pvc --recursive

## Run it

    oc create -f tekton-pipeline-run/customer-security-pipeline-ibm-prevail-2021.yaml
    PL=$(tkn pr list | grep Running | awk '{ print $1 }') && tkn pr logs -f $PL