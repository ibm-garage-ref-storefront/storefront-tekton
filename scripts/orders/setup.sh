#!/bin/bash
source ~/config

echo "setup orders"

echo " building orders DB ${ORDER_DATABASE} with user ${ORDER_USER}"

#######################################
#  TODO, merge the cm into the new-app params
# note: this cm is referenced in the appl microservice as well
# ( as it should)
#######################################
oc create cm order \
  --from-literal MYSQL_HOST=ordermysql \
  --from-literal MYSQL_PORT=3306 \
  --from-literal MYSQL_DATABASE=${ORDER_DATABASE}
oc create secret generic order \
  --from-literal MYSQL_USER=${ORDER_USER} \
  --from-literal MYSQL_PASSWORD=${ORDER_PASSWORD}


#  --as-deployment-config \
oc new-app \
  --name=ordersmysql \
  ${OCNEWAPP_OPTION} \
  --template openshift/mariadb-persistent \
-p DATABASE_SERVICE_NAME=${ORDER_SERVICE_NAME} \
-p MYSQL_ROOT_PASSWORD=${ORDER_ROOT_PASSWORD} \
-p MYSQL_USER=${ORDER_USER} \
-p MYSQL_PASSWORD=${ORDER_PASSWORD} \
-p MYSQL_DATABASE=${ORDER_DATABASE} \
-p MARIADB_VERSION=latest \
-p VOLUME_CAPACITY=1Gi \
  -l app.kubernetes.io/part-of=order-subsystem


# populate the DB
#curl https://raw.githubusercontent.com/ibm-garage-ref-storefront/orders-ms-openliberty/master/scripts/mysql_data.sql -o /tmp/$WORKSPACE/order_mysql_data.sql

#opt=nope
#while [  "$opt" != "happy" ] ; do
#    POD=$(oc get po | grep -v deploy| grep ordersmysql | awk '{print $1}')
#    echo "found pod: $POD"
#    oc rsh $POD mysql -h127.0.0.1 -u${ORDER_USER} -p${ORDER_PASSWORD} ${ORDER_DATABASE} < /tmp/$WORKSPACE/order_mysql_data.sql 2>/dev/null
#    if [ 0 -eq $? ]; then
#        echo " order database initialized succesfully"
#        opt="happy"
#    else
#        NOW=$(date +%H:%M:%S)
#        echo "$NOW - order database not initialized yet, retry"
#        sleep 5
#    fi
#done