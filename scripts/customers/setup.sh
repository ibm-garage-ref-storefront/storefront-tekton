#!/bin/bash

echo "setup customers"
echo ""
source ~/config

# Admin JWT Token
jwt1=$(echo -n '{"alg":"HS256","typ":"JWT"}' | openssl enc -base64);
jwt2=$(echo -n "{\"scope\":[\"admin\"],\"user_name\":\"${TEST_USER}\"}" | openssl enc -base64);
jwt3=$(echo -n "${jwt1}.${jwt2}" | tr '+\/' '-_' | tr -d '=' | tr -d '\r\n');
jwt4=$(echo -n "${jwt3}" | openssl dgst -binary -sha256 -hmac "${HS256_KEY}" | openssl enc -base64 | tr '+\/' '-_' | tr -d '=' | tr -d '\r\n');
jwt=$(echo -n "${jwt3}.${jwt4}");

echo "JWT admin token:"
echo $jwt
echo ""

# Customer JWT Token
jwt1=$(echo -n '{"alg":"HS256","typ":"JWT"}' | openssl enc -base64);
jwt2=$(echo -n "{\"scope\":[\"blue\"],\"user_name\":\"${CUSTOMER_ID}\"}" | openssl enc -base64);
jwt3=$(echo -n "${jwt1}.${jwt2}" | tr '+\/' '-_' | tr -d '=' | tr -d '\r\n');
jwt4=$(echo -n "${jwt3}" | openssl dgst -binary -sha256 -hmac "${HS256_KEY}" | openssl enc -base64 | tr '+\/' '-_' | tr -d '=' | tr -d '\r\n');
jwt_blue=$(echo -n "${jwt3}.${jwt4}");

echo "JWT blue token:"
echo $jwt_blue
echo ""


echo "verify both tokens via http://jwt.io with HS256_KEY:"
echo "$HS256_KEY" 
echo ""

# Start a CouchDB Container with a database user, a password, and create a new database
#docker run --name customercouchdb -p 5985:5984 -e COUCHDB_USER=admin -e COUCHDB_PASSWORD=passw0rd -d couchdb:2.1.2

#Then visit http://127.0.0.1:5985/_utils/#login

# DANGER 1: A root pod from the wild!
# Limit the danger to this deployment.
#echo "DANGER: a root pod from the wild!"
#sleep 10

#oc create sa couchdb
#oc adm policy add-scc-to-user anyuid -z couchdb

# DANGER 2: an easy to guess login.
echo "DANGER: an easy to guess login in the default installation configuration!"
sleep 5

# Level up from version 2 to 3 makes running as root redundant
oc new-app --name=customercouchdb \
   -e COUCHDB_USER=$COUCHDB_USER \
   -e COUCHDB_PASSWORD=$COUCHDB_PASSWORD \
   --docker-image=couchdb:3.1.1  \
  -l app.kubernetes.io/part-of=customer-subsystem

echo "WARNING: CouchDB is currently ephemeral! (the customer database does not survive a restart)"
sleep 5

#oc patch deployment/customercouchdb --patch '{"spec":{"template":{"spec":{"serviceAccountName": "couchdb"}}}}'

#oc expose svc customercouchdb --port=5984  \
#  -l app.kubernetes.io/part-of=customer-subsystem



