#!/bin/bash

echo "setting up inventory microservice"

# Use OCP's capability to deploy the MySQL database
oc new-app \
  --name inventorymysql \
  --template openshift/mysql-persistent \
-p DATABASE_SERVICE_NAME=inventorymysql \
-p MYSQL_ROOT_PASSWORD=admin123 \
-p MYSQL_USER=dbuser \
-p MYSQL_PASSWORD=password \
-p MYSQL_DATABASE=inventorydb \
-p MYSQL_VERSION=8.0  \
  -l app.kubernetes.io/part-of=inventory-subsystem

# populate the DB
curl https://raw.githubusercontent.com/kitty-catt/inventory-ms-spring/master/scripts/mysql_data.sql  -o /tmp/$WORKSPACE/mysql_data.sql

opt=nope
while [  "$opt" != "happy" ] ; do
    POD=$(oc get po | grep -v deploy| grep inventorymysql | awk '{print $1}')
    echo "found pod: $POD"
    oc rsh $POD mysql -udbuser -ppassword inventorydb < /tmp/$WORKSPACE/mysql_data.sql 2>/dev/null
    if [ 0 -eq $? ]; then
        echo "database initialized succesfully"
        opt="happy"
    else
        NOW=$(date +%H:%M:%S)
        echo "$NOW - database not initialized yet, retry"
        sleep 5
    fi
done

## Must deploy from image build by appsody.

## Deploy the inventory service
#oc new-app \
# --name=inventory \
# --docker-image=TBD
# -e MYSQL_HOST=inventorymysql \
# -e MYSQL_PORT=3306 \
# -e MYSQL_DATABASE=inventorydb \
# -e MYSQL_USER=dbuser \
# -e MYSQL_PASSWORD=password