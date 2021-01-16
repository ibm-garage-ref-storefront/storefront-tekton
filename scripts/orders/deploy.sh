#!/bin/bash
source ~/config

echo "deploy orders"

# appsody run --docker-options "
# -e MYSQL_HOST=host.docker.internal 
# -e MYSQL_PORT=3306 
#-e MYSQL_DATABASE=ordersdb 
#-e MYSQL_USER=dbuser 
#-e MYSQL_PASSWORD=password 
#-e HS256_KEY=<Paste HS256 key here>"

oc new-app \
 --name=orders-ms-spring \
 ${OCNEWAPP_OPTION} \
 --image-stream=orders \
 -e MYSQL_HOST=ordersmysql \
 -e MYSQL_PORT=3306 \
 -e MYSQL_DATABASE=ordersdb \
 -e MYSQL_USER=dbuser \
 -e MYSQL_PASSWORD=password \
 -e HS256_KEY=${HS256_KEY}  \
  -l app.kubernetes.io/part-of=order-subsystem

# --as-deployment-config \
#oc new-app \
# --name=orders \
# ${OCNEWAPP_OPTION} \
# --image-stream=orders \
# -e jdbcURL=jdbc:mysql://ordersmysql:3307/${ORDER_DATABASE}?useSSL=true \
# -e dbuser=${ORDER_USER} -e dbpassword=${ORDER_PASSWORD} \
# -e jwksIssuer="https://localhost:9444/oidc/endpoint/OP"

# Reduce attack surface
#oc expose svc/orders-ms-spring \
#  -l app.kubernetes.io/part-of=order-subsystem