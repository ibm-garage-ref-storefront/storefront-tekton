# We will build the customer-ms-spring solo branch



## Setup the security pipelines

It is assumed that you have allready setup the pipelines and the tools-images project.

    oc login -u developer

    bash scripts/tools-images/setup.sh 

    oc project pipelines

    oc apply -f tekton-resources/customer-ms/customer-ms-spring-solo.yaml
    oc apply -f tekton-pipelines/security-pipeline-prevail-2021.yaml 
    oc apply -f tekton-pipelines/image-intake-pipeline-prevail-2021.yaml 
    oc apply -f tekton-tasks/aot-mockup.yaml 
    oc apply -f tekton-tasks/aot-maven-settings.yaml 
    oc apply -f tekton-tasks/aot-maven-task.yaml 
    oc apply -f tekton-tasks/aot-buildah-task.yaml
    oc apply -f pvc --recursive
    oc secret link pipeline crc-creds-skopeo
    oc policy add-role-to-user system:image-pusher system:serviceaccount:full-bc:pipeline

## Run the image-intake-pipeline-prevail-2021 pipeline

![Fail](../../images/image-intake-pipeline-prevail-2021.png?raw=true "Title")

The images that are used to build the application image are scanned and if they are clean then they are imported into the tools-

## Run the security-pipeline-prevail-2021 pipeline

The pipeline uses a chained build where:
1. first the artifact is build 
2. next the Dockerfile is build.

The FROM image in the Dockerfile is under control of the pipeline run.

    oc create -f tekton-pipeline-run/customer-security-pipeline-ibm-prevail-2021.yaml
    PL=$(tkn pr list | grep Running | awk '{ print $1 }') && tkn pr logs -f $PL