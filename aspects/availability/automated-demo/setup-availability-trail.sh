#!/bin/sh

# set -x

clear

## Environment
PROJECT_NAME=istio-system
APP_PROJECT_NAME=bookinfo


## Login to OpenShift

echo '\nChecking if you are already logged-in to OpenShift Cluster'
oc whoami

if [ $? == 1 ] 
then
    echo '\nYou are not logged-in. Login to OpenShift Cluster (oc login)\n'
    exit 0
fi
echo "\nYou are already logged-in.\n"

while true; do
    PS3="Please enter your choice: "
    options=("install Elastic Search Operator" "install Jaeger Operator" "install Kiali Operator" "install Service Mesh Operator" "create Project" "create Service-Mesh Control Plane Service" "create Service-Mesh Member Roll Service" "deploy Sample Application" "access the Sample Application" "install Chaos Toolkit and its Kubernetes extension" "Quit")

    select opt in "${options[@]}"
    do
        case $opt in
            "install Elastic Search Operator")
                echo "\nElastic Search Operator"
                cd scripts
                ./install-allNamespaces.sh elasticsearch-operator
                cd ..
                break
                ;;  
            "install Jaeger Operator")
                echo "\nJaeger Operator"
                cd scripts
                ./install-allNamespaces.sh jaeger-product
                cd ..
                break
                ;;  
            "install Kiali Operator")
                echo "\nKiali Operator"
                cd scripts
                ./install-allNamespaces.sh kiali-ossm
                cd ..
                break
                ;;  
            "install Service Mesh Operator")
                echo "\nService Mesh Operator"
                cd scripts
                ./install-allNamespaces.sh servicemeshoperator
                cd ..
                break
                ;;   
            "create Project")
                echo "\nCreating Project - $PROJECT_NAME"
                oc new-project $PROJECT_NAME
                echo "\nProject created\n"
                break
                ;; 
            "create Service-Mesh Control Plane Service")
                echo "\nService-Mesh Control Plane Service"
                cd scripts
                cp servicemesh-control-plane-service.yaml.template servicemesh-control-plane-service.yaml
                sed -i "" "s/PROJECT_NAME/$PROJECT_NAME/g" servicemesh-control-plane-service.yaml
                oc apply -f servicemesh-control-plane-service.yaml
                cd ..
                echo "\nService instance created\n"
                break
                ;; 
            "create Service-Mesh Member Roll Service")
                echo "\nService-Mesh Member Roll Service"
                cd scripts
                cp servicemesh-member-roll-service.yaml.template servicemesh-member-roll-service.yaml
                sed -i "" "s/PROJECT_NAME/$PROJECT_NAME/g" servicemesh-member-roll-service.yaml
                sed -i "" "s/APP-PROJECT-NAME/$APP_PROJECT_NAME/g" servicemesh-member-roll-service.yaml
                oc apply -f servicemesh-member-roll-service.yaml
                cd ..
                echo "\nService instance created\n"
                break
                ;;
            "deploy Sample Application")
                echo "\nDeploy Sample Application"
                echo "\nCreating new project - $APP_PROJECT_NAME"
                oc new-project $APP_PROJECT_NAME
                oc apply -f https://raw.githubusercontent.com/Maistra/istio/maistra-2.0/samples/bookinfo/platform/kube/bookinfo.yaml
                sleep 15
                oc expose svc/productpage
                
                INGRESS_HOST=`oc get routes -n $PROJECT_NAME istio-ingressgateway |grep ingress | awk '{print $2}'`
                export INGRESS_HOST=$INGRESS_HOST

                oc create -f https://raw.githubusercontent.com/Maistra/istio/maistra-2.0/samples/bookinfo/networking/bookinfo-gateway.yaml
                echo "\n\nApplication deployed\n"
                break
                ;;
            "access the Sample Application")
                echo "\nAccess the Sample Application"
                echo "\nCheck Pods:"
                oc get pods
                echo "\nGet route:"
                oc get routes -n $PROJECT_NAME istio-ingressgateway 

                INGRESS_HOST=`oc get routes -n $PROJECT_NAME istio-ingressgateway |grep ingress | awk '{print $2}'`
                export INGRESS_HOST=$INGRESS_HOST

                echo "\nAccess the app at http://$INGRESS_HOST/productpage \n"
                break
                ;;
            "install Chaos Toolkit and its Kubernetes extension")
                echo "\nInstall Chaos Toolkit"
                python3 -m venv ~/.venvs/chaostk
                source ~/.venvs/chaostk/bin/activate
                pip install -U chaostoolkit
                sleep 10
                echo "\nInstalling Chaos Toolkit extension"
                pip install -U chaostoolkit-kubernetes
                chaos discover chaostoolkit-kubernetes    
                echo "\nChaos toolkit and its extension is installed. You can try running the command `chaos --help`."
                echo "\nIf `chaos` command does not work, please run the command `source ~/.venvs/chaostk/bin/activate` and then execute chaos.\n"  
                break
                ;;
            "Quit")
                echo "Exiting!!\n"
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
