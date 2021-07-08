#!/bin/bash -e

clear

source ~/config.bc-full

oc new-project pipelines

echo "--------------------------------"
echo "add resources:"
oc apply -f tekton-resources/customer-ms/customer-ms-spring-solo.yaml

echo "--------------------------------"
echo "add pipelines:"
#oc apply -f tekton-pipelines/security-pipeline-prevail-2021.yaml 
oc apply -f tekton-pipelines/security-pipeline-prevail-2021-experimental.yaml
#oc apply -f tekton-pipelines/stackrox-pipeline-prevail-2021.yaml 
oc apply -f tekton-pipelines/image-intake-pipeline-prevail-2021.yaml 
oc apply -f tekton-pipelines/performance-pipeline-prevail-2021.yaml
oc apply -f tekton-pipelines/functionality-pipeline-prevail-2021.yaml 


echo "--------------------------------"
echo "add tasks:"
oc apply -f tekton-tasks/aot-mockup.yaml 
#oc apply -f tekton-tasks/aot-maven-settings.yaml 
#oc apply -f tekton-tasks/aot-maven-task.yaml 
oc apply -f tekton-tasks/aot-maven-task-experimental.yaml
oc apply -f tekton-tasks/aot-buildah-task.yaml
oc apply -f tekton-tasks/aot-sonar-java.yaml 
oc apply -f tekton-tasks/aot-jmeter-performance-test.yaml
oc apply -f tekton-tasks/ibm-img-scan-trivy.yaml
oc create -f tekton-tasks/aot-jmeter-functionality-test.yaml 

echo "--------------------------------"
echo "add persistent volume claims:"
oc apply -f pvc --recursive


echo "--------------------------------"
echo "add secrets:"
oc delete secret sonarqube-access 2>/dev/null
oc create secret generic sonarqube-access \
    --from-literal SONARQUBE_PROJECT="GENERIC-PROJECT" \
    --from-literal SONARQUBE_URL='http://sonarqube-sonarqube.tools.svc.cluster.local:9000' \
    --from-literal SONARQUBE_LOGIN=${SONAR_QUBE_PAT}
oc extract secret/sonarqube-access --to=-

oc delete secret slack-access 2>/dev/null
oc create secret generic slack-access \
 --from-literal=slack-url=${SLACK_URL} \
 --from-literal=slack-channel=${SLACK_CHANNEL}

oc delete secret silver-platter-basic-auth 2>/dev/null
oc create secret generic silver-platter-basic-auth --from-literal USER=aot-user --from-literal PASSWORD=ibm-prevail-2021

echo "--------------------------------"
echo "add configmaps:"
# The CM intentention is to be used in JMeter Tekton Task to provide the link to the report in the post that is done in the slack channel. 
oc delete configmap silver-platter-cm  2>/dev/null
#SPR=$(oc get routes.route.openshift.io -n tools | grep silver | awk '{ print $2 }' )
SPR="silver-platter.tools:8080"
oc create configmap silver-platter-cm --from-literal route=http://$SPR 
oc extract configmap/silver-platter-cm --to=-

echo "--------------------------------"
echo "add scc:"
oc adm policy add-scc-to-user privileged system:serviceaccount:pipelines:pipeline

echo "--------------------------------"
echo "add roles:"
oc policy add-role-to-user system:image-pusher system:serviceaccount:full-bc:pipeline
oc policy add-role-to-user edit ${OCP_USER}

echo "--------------------------------"

if [ -f ~/bin/tkn ] 
then
    echo "tkn cli allready exists"
else
    echo "bring you the tkn cli:"
    mkdir -pv ${HOME}/bin
    curl https://mirror.openshift.com/pub/openshift-v4/clients/pipeline/0.13.1/tkn-linux-amd64-0.13.1.tar.gz -o ~/bin/tkn-linux-amd64-0.13.1.tar.gz
    tar xvf ~/bin/tkn-linux-amd64-0.13.1.tar.gz --directory=${HOME}/bin
    chmod 755 ~/bin/tkn
fi
tkn version

# diagnostics
oc adm top nodes

echo ""
echo "Welcome to IBM Prevail 2021"
echo ""
echo " ___ ___ __  __   ___                  _ _   ___ __ ___ _ "
echo "|_ _| _ )  \/  | | _ \_ _ _____ ____ _(_) | |_  )  \_  ) |"
echo " | || _ \ |\/| | |  _/  _/ -_) V / _  | | |  / / () / /| |"
echo "|___|___/_|  |_| |_| |_| \___|\_/\__,_|_|_| /___\__/___|_|"
echo ""

