#!/bin/bash

source ~/config
echo "Setting up generic openshift pipeline"

# pipelines
oc apply -f $HERE/tekton-pipelines/pipeline-build.yaml 
oc apply -f $HERE/tekton-pipelines/pipeline-deploy.yaml 
oc apply -f $HERE/tekton-pipelines/pipeline-security.yaml 

# pipeline tasks
oc apply -f $HERE/tekton-tasks/appsody-build-push.yaml 
oc apply -f $HERE/tekton-tasks/ibm-quay-cve-check.yaml 

# service account
oc create sa appsody-sa

# Note: the sleep will give OCP time to create the service account, and that is necessary for allocating the role binding.
sleep 15
oc policy add-role-to-user admin system:serviceaccount:$NAMESPACE:appsody-sa
oc policy add-role-to-user admin system:serviceaccount:$NAMESPACE:pipeline

#oc create secret docker-registry quay-cred \
#    --docker-server=quay.io \
#    --docker-username=${QUAY_USERNAME} \
#    --docker-password=${QUAY_PASSWORD} \
#    --docker-email=${QUAY_EMAIL}

oc create secret generic quay-api-token \
    --from-literal API_TOKEN=${QUAY_API_TOKEN}

#oc secrets link appsody-sa quay-cred
#oc describe sa appsody-sa

#oc secrets link default quay-cred  --for=pull
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

# The scopeo secrets:
cp skopeo/crc-secret.yaml /tmp/$WORKSPACE/crc-secret.yaml
cp skopeo/icr-secret.yaml /tmp/$WORKSPACE/icr-secret.yaml
cp skopeo/quay-secret.yaml /tmp/$WORKSPACE/quay-secret.yaml

# Setup the CRC secret
CRC_USER=$(oc whoami)
CRC_PASSWORD=$(oc whoami -t)
sed -i "s/CRC_USER/${CRC_USER}/g" /tmp/$WORKSPACE/crc-secret.yaml
sed -i "s/CRC_PASSWORD/${CRC_PASSWORD}/g" /tmp/$WORKSPACE/crc-secret.yaml
oc apply -f  /tmp/$WORKSPACE/crc-secret.yaml

# Setup the ICR secret
sed -i "s/IBM_USER/${ICR_USERNAME}/g" /tmp/$WORKSPACE/icr-secret.yaml
sed -i "s/IBM_APIKEY/${ICR_API_KEY}/g" /tmp/$WORKSPACE/icr-secret.yaml
oc apply -f  /tmp/$WORKSPACE/icr-secret.yaml

# Setup the QUAY secret
sed -i "s/QUAY_USER/${QUAY_USERNAME}/g" /tmp/$WORKSPACE/quay-secret.yaml
sed -i "s/QUAY_PASSWORD/${QUAY_PASSWORD}/g" /tmp/$WORKSPACE/quay-secret.yaml
oc apply -f  /tmp/$WORKSPACE/quay-secret.yaml

oc secret link appsody-sa crc-creds-skopeo
oc secret link appsody-sa icr-creds-skopeo
oc secret link appsody-sa quay-creds-skopeo

