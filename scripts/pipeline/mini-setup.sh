#!/bin/bash -e

clear

source ~/config.bc-full

oc new-project pipelines

oc apply -f tekton-resources/customer-ms/customer-ms-spring-solo.yaml

#oc apply -f tekton-pipelines/security-pipeline-prevail-2021.yaml 
oc apply -f tekton-pipelines/security-pipeline-prevail-2021-experimental.yaml
oc apply -f tekton-pipelines/image-intake-pipeline-prevail-2021.yaml 
oc apply -f tekton-pipelines/performance-pipeline-prevail-2021.yaml

oc apply -f tekton-tasks/aot-mockup.yaml 
#oc apply -f tekton-tasks/aot-maven-settings.yaml 
#oc apply -f tekton-tasks/aot-maven-task.yaml 
oc apply -f tekton-tasks/aot-maven-task-experimental.yaml
oc apply -f tekton-tasks/aot-buildah-task.yaml
oc apply -f tekton-tasks/aot-sonar-java.yaml 
oc apply -f tekton-tasks/aot-jmeter-performance-test.yaml
oc apply -f tekton-tasks/ibm-img-scan-trivy.yaml

oc apply -f pvc --recursive

#oc secret link pipeline crc-creds-skopeo

oc delete secret sonarqube-access 2>/dev/null
oc create secret generic sonarqube-access \
    --from-literal SONARQUBE_PROJECT="GENERIC-PROJECT" \
    --from-literal SONARQUBE_URL='http://sonarqube-sonarqube.tools.svc.cluster.local:9000' \
    --from-literal SONARQUBE_LOGIN=${SONAR_QUBE_PAT}
oc extract secret/sonarqube-access --to=-

oc policy add-role-to-user system:image-pusher system:serviceaccount:full-bc:pipeline
oc adm policy add-scc-to-user privileged system:serviceaccount:pipelines:pipeline

oc policy add-role-to-user edit ${OCP_USER}

echo ""
echo "Welcome to IBM Prevail 2021"
echo ""
echo "___ ___ __  __   ___                  _ _   ___ __ ___ _ "
echo "|_ _| _ )  \/  | | _ \_ _ _____ ____ _(_) | |_  )  \_  ) |"
echo " | || _ \ |\/| | |  _/  _/ -_) V / _  | | |  / / () / /| |"
echo "|___|___/_|  |_| |_| |_| \___|\_/\__,_|_|_| /___\__/___|_|"
echo ""

