mkdir -pv ~/bin
curl -k https://mirror.openshift.com/pub/openshift-v4/clients/helm/latest/helm-linux-amd64 -o ~/bin/helm
chmod 755 ~/bin/helm

# CHECKPOINT
~/bin/helm version

curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl" -o ~/bin/kubectl

kubectl create serviceaccount --namespace kube-system tiller
kubectl create clusterrolebinding tiller-cluster-rule --clusterrole=cluster-admin --serviceaccount=kube-system:tiller

#helm init
#kubectl patch deploy --namespace kube-system tiller-deploy -p '{"spec":{"template":{"spec":{"serviceAccount":"tiller"}}}}'

~/bin/helm repo add oteemo https://oteemo.github.io/charts/
~/bin/helm repo update

# CHECKPOINT:

~/bin/helm repo list

# CHECKPOINT
#NAME  	URL                                             
#oteemo	https://oteemo.github.io/charts/   

# install sonar qube in the existing tools namespace
oc project tools
oc create serviceaccount sonarqube -n tools
oc adm policy add-scc-to-user anyuid system:serviceaccount:tools:default
oc adm policy add-scc-to-user privileged system:serviceaccount:tools:default
oc adm policy add-scc-to-user privileged system:serviceaccount:tools:sonarqube

# Run the following command on DTE console to install sonarqube
# https://artifacthub.io/packages/helm/oteemo-charts/sonarqube

# note: version 6.6.0 reveals detailed vulnerabilities
#~/bin/helm install sonarqube oteemo/sonarqube --version 6.6.0

helm search repo oteemo/sonarqube --versions

# version 6.6.0 shows the detailed vulnerabilities
~/bin/helm install sonarqube oteemo/sonarqube --version 6.6.0

PS3='What is your target environment: '
options=("IBM DTE" "CRC" "Quit")
select opt in "${options[@]}"
do
    case $opt in
        "IBM DTE")
            echo "you chose Openshift on IBM DTE"

            # WARNING: DO NOT EXPOSE SONARQUBE on the public cloud environments.
            # https://www.zdnet.com/article/fbi-hackers-stole-source-code-from-us-government-agencies-and-private-companies/

            SQ=$(oc get po -n tools | grep sonarqube-sonarqube | cut -f1 -d" ")
            echo "Use the following command to setup portforwarding to sonarqube:"
            echo "oc port-forward $SQ -n tools 9000:9000&"

            break
            ;;
        "CRC")
            echo "you chose CRC"
            oc expose svc sonarqube-sonarqube --hostname=sonar-tools.apps-crc.testing
            break
            ;;
        "Quit")
            break
            ;;
        *) echo "invalid option $REPLY";;
    esac
done

#~/bin/helm install sonarqube oteemo/sonarqube \
#  --set ingress.enabled=true \
#  --set ingress.hosts[0].name=sonar-tools.apps-crc.testing

#helm install oteemocharts/sonarqube --set OpenShift.enabled=true,\
#                                          serviceAccount.create=true,\
#                                          postgresql.serviceAccount.enabled=true,\
#                                          postgresql.securityContext.enabled=false,\
#                                          postgresql.volumePermissions.enabled=true,\
#                                          postgresql.volumePermissions.securityContext.runAsUser="auto"

# the new command should create the service account, but does not work 
echo "sleeping for 20 seconds .. chill down .." 
sleep 20
oc patch deployment/sonarqube-sonarqube --patch '{"spec":{"template":{"spec":{"serviceAccountName": "sonarqube"}}}}'


#echo "The internal SONARQUBE_URL in boot.sh should look like:" 
#export SONARQUBE_URL='http://sonarqube-sonarqube.tools.svc.cluster.local:9000'