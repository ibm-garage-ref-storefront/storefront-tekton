#!/bin/sh

# set -x

clear

## Environment
PROJECT_NAME=istio-system
APP_PROJECT_NAME=bookinfo


## Login to OpenShift

echo
echo 'Checking if you are already logged-in to OpenShift Cluster'
oc whoami

if [ $? == 1 ] 
then
    echo 
    echo 'You are not logged-in. Login to OpenShift Cluster (oc login)'
    exit 0
fi
echo
echo "You are already logged-in."
echo

while true; do
    PS3="Please enter your choice: "
    options=("install Elastic Search Operator" "install Jaeger Operator" "install Kiali Operator" "install Service Mesh Operator" "create Project" "create Service-Mesh Control Plane Service" "create Service-Mesh Member Roll Service" "deploy Sample Application" "access the Sample Application" "install Chaos Toolkit and its Kubernetes extension" "Quit")

    select opt in "${options[@]}"
    do
        case $opt in
            "install Elastic Search Operator")
                echo
                echo "Elastic Search Operator"
                cd scripts
                ./install-allNamespaces.sh elasticsearch-operator
                cd ..
                break
                ;;  
            "install Jaeger Operator")
                echo
                echo "Jaeger Operator"
                cd scripts
                ./install-allNamespaces.sh jaeger-product
                cd ..
                break
                ;;  
            "install Kiali Operator")
                echo
                echo "Kiali Operator"
                cd scripts
                ./install-allNamespaces.sh kiali-ossm
                cd ..
                break
                ;;  
            "install Service Mesh Operator")
                echo
                echo "Service Mesh Operator"
                cd scripts
                ./install-allNamespaces.sh servicemeshoperator
                cd ..
                break
                ;;   
            "create Project")
                echo
                echo "Creating Project - $PROJECT_NAME"
                oc new-project $PROJECT_NAME
                echo "Project created"
                echo
                break
                ;; 
            "create Service-Mesh Control Plane Service")
                echo
                echo "Service-Mesh Control Plane Service"
                cd scripts
                cp servicemesh-control-plane-service.yaml.template servicemesh-control-plane-service.yaml
                sed -i s#PROJECT_NAME#$PROJECT_NAME#g servicemesh-control-plane-service.yaml
                oc apply -f servicemesh-control-plane-service.yaml
                cd ..
                echo
                echo "Service instance created"
                echo
                break
                ;; 
            "create Service-Mesh Member Roll Service")
                echo
                echo "Service-Mesh Member Roll Service"
                cd scripts
                cp servicemesh-member-roll-service.yaml.template servicemesh-member-roll-service.yaml
                sed -i s#PROJECT_NAME#$PROJECT_NAME#g servicemesh-member-roll-service.yaml
                sed -i s#APP-PROJECT-NAME#$APP_PROJECT_NAME#g servicemesh-member-roll-service.yaml
                oc apply -f servicemesh-member-roll-service.yaml
                cd ..
                echo
                echo "Service instance created"
                echo
                break
                ;;
            "deploy Sample Application")
                echo
                echo "Deploy Sample Application"
                echo
                echo "Creating new project - $APP_PROJECT_NAME"
                oc new-project $APP_PROJECT_NAME
                oc apply -f https://raw.githubusercontent.com/Maistra/istio/maistra-2.0/samples/bookinfo/platform/kube/bookinfo.yaml
                sleep 15
                oc expose svc/productpage
                
                INGRESS_HOST=`oc get routes -n $PROJECT_NAME istio-ingressgateway |grep ingress | awk '{print $2}'`
                export INGRESS_HOST=$INGRESS_HOST

                oc create -f https://raw.githubusercontent.com/Maistra/istio/maistra-2.0/samples/bookinfo/networking/bookinfo-gateway.yaml
                echo
                echo "Application deployed"
                echo
                break
                ;;
            "access the Sample Application")
                echo
                echo "Access the Sample Application"
                echo
                echo "Check Pods:"
                oc get pods
                echo
                echo "Get route:"
                oc get routes -n $PROJECT_NAME istio-ingressgateway 

                INGRESS_HOST=`oc get routes -n $PROJECT_NAME istio-ingressgateway |grep ingress | awk '{print $2}'`
                export INGRESS_HOST=$INGRESS_HOST

                echo
                echo "Access the app at http://$INGRESS_HOST/productpage "
                echo
                break
                ;;
            "install Chaos Toolkit and its Kubernetes extension")
                echo
                echo "Install Chaos Toolkit"
                python3 -m venv ~/.venvs/chaostk
                source ~/.venvs/chaostk/bin/activate
                pip install -U chaostoolkit
                sleep 10
                echo
                echo "Installing Chaos Toolkit extension"
                pip install -U chaostoolkit-kubernetes
                chaos discover chaostoolkit-kubernetes 
                echo
                echo "Chaos toolkit and its extension is installed. You can try running the command `chaos --help`."
                echo "If `chaos` command does not work, please run the command `source ~/.venvs/chaostk/bin/activate` and then execute chaos."
                echo
                break
                ;;
            "Quit")
                echo "Exiting!!"
                echo
                break
                ;;
            *) echo "invalid option";;
        esac
    done
    if [ "$opt" == "Quit" ] 
    then
        exit;
    fi
done
