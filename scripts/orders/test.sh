#!/bin/bash
source ~/config

#set -x

echo "testing orders deployment"

# JWT Header
jwt1=$(echo -n '{"alg":"HS256","typ":"JWT"}' | openssl enc -base64);

# JWT Payload
jwt2=$(echo -n "{\"scope\":[\"blue\"],\"user_name\":\"admin\"}" | openssl enc -base64);

# JWT Signature: Header and Payload
jwt3=$(echo -n "${jwt1}.${jwt2}" | tr '+\/' '-_' | tr -d '=' | tr -d '\r\n');

# JWT Signature: Create signed hash with secret key
jwt4=$(echo -n "${jwt3}" | openssl dgst -binary -sha256 -hmac "${HS256_KEY}" | openssl enc -base64 | tr '+\/' '-_' | tr -d '=' | tr -d '\r\n');

# Complete JWT
jwt=$(echo -n "${jwt3}.${jwt4}");

# default JWT admin token:
#export jwt_admin=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzY29wZSI6WyJhZG1pbiJdLCJ1c2VyX25hbWUiOiJmb28ifQ.hZEmuywb637OrP_6AKDiyZ5_mZ1lVJlwzCOG4egLa1c

# default JWT blue token:
#export jwt_blue=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzY29wZSI6WyJibHVlIl0sInVzZXJfbmFtZSI6IiJ9.PGVxVMaxtAL2kh5ik1H6tcKLDv0xeh7klrJvrxEny48

#jwt=$jwt_admin

#echo "---------------------------------------------------------------------"
echo "JWT token:" $jwt
echo "HS256_KEY=$HS256_KEY" 

set -x
#echo "---------------------------------------------------------------------"
# Create an Order
echo "creating order"
export ROUTE=$(oc get route | grep orders | grep -v ordersmysql | awk  '{ print $2}')
curl -i -H "Content-Type: application/json" -H "Authorization: Bearer ${jwt}" -X POST -d '{"itemId":13401, "count":1}' "http://$ROUTE/micro/orders"


#echo "---------------------------------------------------------------------"
# Get all orders 
echo "getting order"
curl -H "Authorization: Bearer ${jwt}" "http://$ROUTE/micro/orders" -o result.json
jq . result.json
rm result.json

#echo "---------------------------------------------------------------------"