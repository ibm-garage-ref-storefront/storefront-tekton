#!/bin/bash

echo "deploying inventory microservice ... the openshift way"

oc create cm inventory \
  --from-literal MYSQL_HOST=inventorymysql \
  --from-literal MYSQL_PORT=3306 \
  --from-literal MYSQL_DATABASE=inventorydb \
  --from-literal MYSQL_USER=dbuser \
  --from-literal MYSQL_PASSWORD=password  
  
# Deploy the inventory service
oc new-app \
 --name=inventory-ms-spring \
 --image-stream=inventory \
 -l app.kubernetes.io/part-of=inventory-subsystem

# --docker-image=quay.io/kitty_catt/inventory:latest
# -e MYSQL_HOST=inventorymysql \
# -e MYSQL_PORT=3306 \
# -e MYSQL_DATABASE=inventorydb \
# -e MYSQL_USER=dbuser \
# -e MYSQL_PASSWORD=password

oc set env deployment/inventory-ms-spring --from=cm/inventory 

# Reduce attack surface
# oc expose svc/inventory-ms-spring \
#  -l app.kubernetes.io/part-of=inventory-subsystem
