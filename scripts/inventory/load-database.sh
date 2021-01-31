#!/bin/bash

echo "loading the inventory microservice"

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

