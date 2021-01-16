#!/bin/bash

echo "deploy customers"
source ~/config

#appsody run --docker-options "\
# -e COUCHDB_PORT=5985 \
# -e COUCHDB_HOST=host.docker.internal \
# -e COUCHDB_PROTOCOL=http \
# -e COUCHDB_USERNAME=admin \
# -e COUCHDB_PASSWORD=passw0rd \
# -e COUCHDB_DATABASE=customers 
# -e HS256_KEY=E6526VJkKYhyTFRFMC0pTECpHcZ7TGcq8pKsVVgz9KtESVpheEO284qKzfzg8HpWNBPeHOxNGlyudUHi6i8tFQJXC8PiI48RUpMh23vPDLGD35pCM0417gf58z5xlmRNii56fwRCmIhhV7hDsm3KO2jRv4EBVz7HrYbzFeqI45CaStkMYNipzSm2duuer7zRdMjEKIdqsby0JfpQpykHmC5L6hxkX0BT7XWqztTr6xHCwqst26O0g8r7bXSYjp4a"

oc new-app --name=customer-ms-spring \
 -e COUCHDB_PORT=5984 \
 -e COUCHDB_HOST=customercouchdb \
 -e COUCHDB_PROTOCOL=http \
 -e COUCHDB_USERNAME=${COUCHDB_USER} \
 -e COUCHDB_PASSWORD=${COUCHDB_PASSWORD} \
 -e COUCHDB_DATABASE=customers \
 -e HS256_KEY=${HS256_KEY} \
  --image-stream=customer  \
  -l app.kubernetes.io/part-of=customer-subsystem

# Reduce attack surface
#oc expose svc/customer-ms-spring --port=8080 \
#  -l app.kubernetes.io/part-of=customer-subsystem

# The customer-ms-spring service runs on port 8082, ... need to patch port

echo "TODO: patch customer-ms-spring port to target port 8082 !!!"

