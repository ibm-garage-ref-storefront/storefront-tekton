echo "###################################################################"
source ~/config

oc new-project $NAMESPACE

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

PS3='What is your target environment: '
options=("IBM DTE" "CRC" "Quit")
select opt in "${options[@]}"
do
    case $opt in
        "IBM DTE")
            echo "you chose Openshift on IBM DTE"
            # Make a secure route

            mkdir -pv /tmp/$WORKSPACE/certs
            cd /tmp/$WORKSPACE/certs

            CERTS_SECRET=$(oc get secrets -n ibm-cert-store | grep "tls" | grep "dte" | awk '{print $1 }')

            oc extract secret/$CERTS_SECRET -n ibm-cert-store --confirm

            oc create route edge --service=silver-platter --cert=tls.crt --key=tls.key --port=8080

            # automatically level up HTTP to HTTPS
            oc annotate route silver-platter --overwrite haproxy.router.openshift.io/hsts_header="max-age=31536000;includeSubDomains;preload"
            rm -Rf /tmp/$WORKSPACE/certs
            break
            ;;
        "CRC")
            echo "you chose CRC"
            # no need for encryption
            oc expose svc silver-platter
            break
            ;;
        "Quit")
            break
            ;;
        *) echo "invalid option $REPLY";;
    esac
done