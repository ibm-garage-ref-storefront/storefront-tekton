#!/bin/bash -e

clear

source ~/config.bc-full

oc project pipelines

# Resources
echo "--------------------------------"
echo "add resources:"
oc apply -f tekton-resources/customer-ms/customer-ms-spring-tomcatroot.yaml
oc apply -f tekton-resources/customer-ms/customer-ms-spring-runsroot.yaml 

echo "--------------------------------"
