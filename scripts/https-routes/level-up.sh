#!/bin/bash

source ~/config
HERE=$(pwd)

echo "Levelling up the routes from HTTP to HTTPS."

oc delete route web
oc delete route auth-ms-spring
mkdir -pv /tmp/$WORKSPACE/certs
cd /tmp/$WORKSPACE/certs

CERTS_SECRET=$(oc get secrets -n ibm-cert-store | grep "tls" | grep "dte" | awk '{print $1 }')

oc extract secret/$CERTS_SECRET -n ibm-cert-store --confirm

oc create route edge --service=web --cert=tls.crt --key=tls.key --port=3000
oc create route edge --service=auth-ms-spring --cert=tls.crt --key=tls.key --port=8080

oc annotate route web router.openshift.io/cookie_name="bluecompute-cookie"
oc annotate route web --overwrite haproxy.router.openshift.io/hsts_header="max-age=31536000;includeSubDomains;preload"

# Give it some time to manifest the route to the auth service
sleep 10
export ROUTE=$(oc get route | grep auth-ms-spring | awk  '{ print $2}')
echo "ROUTE=>$ROUTE<"
sleep 10

cp $HERE/scripts/web/production-input-secure.json \
   $HERE/scripts/web/production.json

sed -i "s/auth-ms-spring:8080/$ROUTE/" $HERE/scripts/web/production.json

oc delete cm config 2>/dev/null

oc create cm config \
 --from-file=$HERE/scripts/web/production.json \
 --from-file=$HERE/scripts/web/default.json \
 --from-file=$HERE/scripts/web/checks

oc set volume deployment/web --remove --name=production-config
sleep 10
oc set volume deployment/web --add --type=configmap --mount-path=/project/user-app/config/ --configmap-name=config --name=production-config 

rm $HERE/scripts/web/production.json
rm -Rf /tmp/$WORKSPACE/certs

# return 
cd -

