#!/bin/bash

source ~/config
echo "Setting up generic openshift pipeline"

# pipelines
oc apply -f $HERE/tekton-pipelines/pipeline-build.yaml 
oc apply -f $HERE/tekton-pipelines/pipeline-deploy.yaml 

# pipeline tasks
oc apply -f $HERE/tekton-tasks/appsody-build-push.yaml 
oc apply -f $HERE/tekton-tasks/ibm-quay-cve-check.yaml 

# service account
oc create sa appsody-sa

# Note: the sleep will give OCP time to create the service account, and that is necessary for allocating the role binding.
sleep 15
oc policy add-role-to-user admin system:serviceaccount:$NAMESPACE:appsody-sa
oc policy add-role-to-user admin system:serviceaccount:$NAMESPACE:pipeline

oc create secret docker-registry quay-cred \
    --docker-server=quay.io \
    --docker-username=${QUAY_USER} \
    --docker-password=${QUAY_PWD} \
    --docker-email=${QUAY_EMAIL}

oc create secret generic quay-api-token \
    --from-literal API_TOKEN=${QUAY_API_TOKEN}

oc secrets link appsody-sa quay-cred
#oc describe sa appsody-sa

oc secrets link default quay-cred  --for=pull
#oc describe sa default

echo "Select a source repository"
echo

# PS3 is an environment variable
# that sets the menu prompt
PS3="Choose a number: "

# The select command creates the menu
select CHOICE in official forks  Quit
do
    case $CHOICE in
        "official")
            oc apply -f $HERE/tekton-resources/auth-ms/auth-ms-spring-official.yaml 
            oc apply -f $HERE/tekton-resources/catalog-ms/catalog-ms-spring-official.yaml
            oc apply -f $HERE/tekton-resources/customer-ms/customer-ms-spring-official.yaml
            oc apply -f $HERE/tekton-resources/inventory-ms/inventory-ms-spring-official.yaml
            oc apply -f $HERE/tekton-resources/orders-ms/orders-ms-spring-official.yaml 
            oc apply -f $HERE/tekton-resources/storefront-ms/storefront-ui-official.yaml
            break
            ;;
        "forks")
            oc apply -f $HERE/tekton-resources/auth-ms/auth-ms-spring-fork.yaml 
            oc apply -f $HERE/tekton-resources/catalog-ms/catalog-ms-spring-fork.yaml
            oc apply -f $HERE/tekton-resources/customer-ms/customer-ms-spring-fork.yaml
            oc apply -f $HERE/tekton-resources/inventory-ms/inventory-ms-spring-fork.yaml
            oc apply -f $HERE/tekton-resources/orders-ms/orders-ms-spring-fork.yaml 
            oc apply -f $HERE/tekton-resources/storefront-ms/storefront-ui-fork.yaml
            break
            ;;
        "Quit")
            exit
            ;;
        *)  echo "Invalid Choice";;
    esac
done    


