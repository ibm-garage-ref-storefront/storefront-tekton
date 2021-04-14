# We will build the customer-ms-spring solo branch

    oc project full-bc
    oc apply -f tekton-resources/customer-ms/customer-ms-spring-solo.yaml
    oc apply -f tekton-pipelines/pipeline-security-experimental-solo.yaml 
    oc apply -f tekton-tasks/aot-mockup.yaml 
    oc apply -f tekton-tasks/aot-maven-settings.yaml 
    oc apply -f tekton-tasks/aot-maven-task.yaml 
    oc apply -f pvc --recursive
