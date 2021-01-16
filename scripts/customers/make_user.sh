#!/bin/bash

echo "testing customers deployment"
source ~/config

read -p 'User to create: ' -e -i 'Luke' username

read -p 'Password: ' -e -i 'May-The-Force-Be-With-You' password

echo "Creating user ${username} with password ${password}."

#exit

# OPEN THE DOOR
oc expose svc customer-ms-spring

sleep 7

jwt1=$(echo -n '{"alg":"HS256","typ":"JWT"}' | openssl enc -base64);
#jwt2=$(echo -n "{\"scope\":[\"admin\", \"blue\"],\"user_name\":\"${username}\"}" | openssl enc -base64);
jwt2=$(echo -n "{\"scope\":[\"blue\"],\"user_name\":\"${username}\"}" | openssl enc -base64);
jwt3=$(echo -n "${jwt1}.${jwt2}" | tr '+\/' '-_' | tr -d '=' | tr -d '\r\n');
jwt4=$(echo -n "${jwt3}" | openssl dgst -binary -sha256 -hmac "${HS256_KEY}" | openssl enc -base64 | tr '+\/' '-_' | tr -d '=' | tr -d '\r\n');
jwt=$(echo -n "${jwt3}.${jwt4}");
echo $jwt

#exit 0

# default JWT admin token (hardcoded user_name = foo):
#export jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzY29wZSI6WyJhZG1pbiJdLCJ1c2VyX25hbWUiOiJmb28ifQ.hZEmuywb637OrP_6AKDiyZ5_mZ1lVJlwzCOG4egLa1c

export ROUTE=$(oc get route | grep customer | grep -v couchdb | awk  '{ print $2}')


# create a customer using the admin token
curl -s -v -X POST -i "http://$ROUTE/micro/customer/add" -H "Content-Type: application/json" -H "Authorization: Bearer ${jwt}" -d "{\"username\": \"${username}\", \"password\": \"${password}\", \"firstName\": \"${username}\", \"lastName\": \"bar\", \"email\": \"${username}@jedi-masters.org\"}"

# curl -k -d "grant_type=password&client_id=bluecomputeweb&client_secret=bluecomputewebs3cret&username=foo&password=bar&scope=openid" http://$ROUTE/oidc/endpoint/OP/token

# search a customer using the admin token
#curl -s -X GET "http://$ROUTE/micro/customer/search?username=${TEST_USER}" -H 'Content-type: application/json' -H "${jwt}" 
curl -s -v -X GET "http://$ROUTE/micro/customer/search?username=${username}" -H 'Content-type: application/json' -H "Authorization: Bearer ${jwt}" | jq .


# Give it the blue token
# ----------------------------------------------------------------------------------

# extract the id 
id=$(curl -s -X GET "http://$ROUTE/micro/customer/search?username=${username}" -H 'Content-type: application/json' -H "Authorization: Bearer ${jwt}" | jq -r ". | ._id")
echo "${username} user id equals: $id"

# generate the token with the blue skope
jwt1=$(echo -n '{"alg":"HS256","typ":"JWT"}' | openssl enc -base64);
jwt2=$(echo -n "{\"scope\":[\"blue\"],\"user_name\":\"${username}\"}" | openssl enc -base64);
jwt3=$(echo -n "${jwt1}.${jwt2}" | tr '+\/' '-_' | tr -d '=' | tr -d '\r\n');
jwt4=$(echo -n "${jwt3}" | openssl dgst -binary -sha256 -hmac "${HS256_KEY}" | openssl enc -base64 | tr '+\/' '-_' | tr -d '=' | tr -d '\r\n');
jwt_blue=$(echo -n "${jwt3}.${jwt4}");

# Can I get the details using the blue token?
curl -s -X GET "http://$ROUTE/micro/customer/search?username=${username}" -H "Authorization: Bearer ${jwt_blue}" | jq .

# CLOSE THE DOOR
oc delete route customer-ms-spring
