#!/bin/bash

echo "###################################################################"
#source ~/config.pnst

oc project tools

echo "Setting the silver platter in the tools namespace."

oc new-app \
 --name=silver-platter \
 --as-deployment-config \
 --image-stream="openshift/httpd:2.4" 

# We will be using RWO pvc's
oc patch dc/silver-platter --patch '{"spec":{"strategy":{"type":"Recreate"}}}'
oc patch dc/silver-platter --type=json --patch '[{"op":"remove", "path": "/spec/strategy/rollingParams"}]'

echo "Setting the silver platter storage with ReadWriteOnce storage."
oc apply -f httpd-pvc.yaml
oc apply -f iam-pvc.yaml
oc apply -f webdav-pvc.yaml 

PVC_STATE="unknown"

until [ "$PVC_STATE" == "Bound" ]; do
    PVC_STATE=$(oc get pvc | grep httpd-pvc | awk '{print $2 }')
    echo "httpd-pvc provisioning: " $PVC_STATE
    sleep 5
done

# assume when httpd pvc is ready, then iam pvc is as well
oc set triggers dc/silver-platter --from-config=false
oc set volume dc/silver-platter --add --name=httpd --type=persistentVolumeClaim --claim-name='httpd-pvc' --mount-path=/var/www/html
oc set volume dc/silver-platter --add --name=iam --type=persistentVolumeClaim --claim-name='iam-pvc' --mount-path=/etc/www/iam
oc set volume dc/silver-platter --add --name=webdav --type=persistentVolumeClaim --claim-name='webdav-pvc' --mount-path=/var/www/webdav
oc set triggers dc/silver-platter auto

sleep 5

POD_STATE="unknown"
until [ "$POD_STATE" == "Running" ]; do
    POD_STATE=$(oc get po | grep silver-platter | grep -v deploy | awk '{print $3 }')
    echo "pod state: " $POD_STATE
    sleep 5
done

SP=$(oc get po | grep silver-platter | grep -v deploy | awk '{ print $1 }')
echo $SP
sleep 15

oc rsh $SP bash -c "mkdir -pv /var/www/webdav/sites"
oc rsh $SP bash -c "mkdir -pv /var/www/webdav/jmeter"
oc rsh $SP bash -c "cd /var/www/html && ln -sf /var/www/webdav/sites sites"
oc rsh $SP bash -c "cd /var/www/html && ln -sf /var/www/webdav/jmeter jmeter"

oc cp index.html $SP:/var/www/html/index.html -c silver-platter
oc cp .htaccess $SP:/var/www/html/.htaccess -c silver-platter

# create the webdav transport user for the maven site reports (change password for wagon user):
oc rsh $SP bash -c "htpasswd -bc /etc/www/iam/.htpasswd aot-user ibm-prevail-2021"

echo "Create a user to access the silver platter, use the following command:"
echo "bash scripts/httpd/provide-access.sh"


# note: consider mounting the .htpasswd on a seperate PV

# Make sure that security is in place before you increase the attack surface.
#oc expose svc silver-platter
oc create route edge silver-platter --service=silver-platter --hostname=silver-platter-tools.apps-crc.testing
oc annotate route silver-platter --overwrite haproxy.router.openshift.io/hsts_header="max-age=31536000;includeSubDomains;preload"

# The CM intentention is to be used in JMeter Tekton Task to provide the link to the report in the post that is done in the slack channel. 
SPR=$(oc get routes.route.openshift.io | grep silver | awk '{ print $2 }' )
oc create configmap silver-platter-cm --from-literal route=http://$SPR 
oc extract configmap/silver-platter-cm --to=-

# Enable webdav
oc create configmap webdav-conf --from-file=webdav.conf
oc set volume dc silver-platter \
--add \
--name=webdav-conf \
--type=configmap \
--mount-path=/etc/httpd/conf.d/webdav.conf \
--configmap-name=webdav-conf \
--sub-path=webdav.conf 

oc set volumes dc silver-platter --all
