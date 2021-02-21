#oc delete configmap sonarqube-config 2>/dev/null
#oc create configmap sonarqube-config \
#    --from-literal SONARQUBE_URL='http://sonarqube-sonarqube.tools.svc.cluster.local:9000'

oc delete secret sonarqube-access 2>/dev/null
oc create secret generic sonarqube-access \
    --from-literal SONARQUBE_PROJECT="GENERIC-PROJECT" \
    --from-literal SONARQUBE_URL='http://sonarqube-sonarqube.tools.svc.cluster.local:9000' \
    --from-literal SONARQUBE_LOGIN=SONAR_QUBE_PAT 
