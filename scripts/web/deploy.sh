#!/bin/bash

source ~/config
export HERE=${PWD}
echo "Working from $HERE"

echo "deploy web frontend"

echo "Select a repo type that you have build"
echo

# PS3 is an environment variable that sets the menu prompt
PS3="Choose a number: "

# The select command creates the menu
select CHOICE in ibm-garage old-kitty-catt-forks  Quit
do
    case $CHOICE in
        "ibm-garage")
            export REPO=ibm-garage

            # move to new endpoints
            cp $HERE/scripts/web/production-ocp.json \
               $HERE/scripts/web/production.json
            break
            ;;
        "old-kitty-catt-forks")
            export REPO=kitty-catt

            echo "searching for route to auth-ms-spring service"
            # Give it some time to manifest the route to the auth service
            sleep 10
            export ROUTE=$(oc get route | grep auth-ms-spring | awk  '{ print $2}')
            echo "ROUTE=>$ROUTE<"
            sleep 10

            cp $HERE/scripts/web/production-input.json \
               $HERE/scripts/web/production.json

            sed -i "s/auth-ms-spring:8080/$ROUTE/" $HERE/scripts/web/production.json            
            break
            ;;
        "Quit")
            exit
            ;;
        *)  echo "Invalid Choice";;
    esac
done    

echo "REPO=$REPO"
#exit

oc delete cm config 2>/dev/null

oc create cm config \
 --from-file=$HERE/scripts/web/production.json \
 --from-file=$HERE/scripts/web/default.json \
 --from-file=$HERE/scripts/web/checks

rm $HERE/scripts/web/production.json

oc new-app --name=web \
   -e AUTH_HOST=$ROUTE  \
   -e CATALOG_HOST=catalog-ms-spring -e CATALOG_PORT=8080 \
   -e CUSTOMER_HOST=customer-ms-spring -e CUSTOMER_PORT=8080 \
   -e ORDERS_HOST=orders-ms-spring -e ORDERS_PORT=8080 \
   -e PORT=3000 \
   --image-stream=web \
   -l app.kubernetes.io/part-of=web-subsystem

oc set volume deployment/web --add --type=configmap --mount-path=/project/user-app/config/ --configmap-name=config --name=production-config  --overwrite

oc patch svc web -p '{"spec": {"ports": [{"port": 3000,"targetPort": 3000,"name": "node"}],"type": "LoadBalancer"}}'

oc expose svc/web \
  -l app.kubernetes.io/part-of=web-subsystem \
  --port=3000
