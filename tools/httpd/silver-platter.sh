echo "###################################################################"
source ~/config

oc apply -f httpd-pvc.yaml 
PVC_STATE="unknown"

until [ $PVC_STATE == "Bound" ]; do
    PVC_STATE=$(oc get pvc | grep httpd-pvc | awk '{print $2 }')
    echo "httpd-pvc provisioning: " $PVC_STATE
    sleep 5
done

oc new-app --name=silver-platter --image-stream="openshift/httpd:2.4" 
oc set volume deployment/silver-platter --add --name=httpd --type=persistentVolumeClaim --claim-name='httpd-pvc' --mount-path=/var/www/html

POD_STATE="unknown"
until [ $POD_STATE == "Running" ]; do
    POD_STATE=$(oc get po | grep silver-platter | awk '{print $3 }')
    echo "pod state: " $POD_STATE
    sleep 5
done

SP=$(oc get po | grep silver-platter | awk '{ print $1 }')
echo $SP
sleep 15

oc rsh $SP bash -c "mkdir -pv /var/www/html/sites"
oc rsh $SP bash -c "mkdir -pv /var/www/html/jmeter"
oc cp index.html $SP:/var/www/html/index.html -c silver-platter
oc cp .htaccess $SP:/var/www/html/.htaccess -c silver-platter

oc create route edge silver-platter --service=silver-platter --hostname=silver-platter-tools.apps-crc.testing
oc annotate route silver-platter --overwrite haproxy.router.openshift.io/hsts_header="max-age=31536000;includeSubDomains;preload"

