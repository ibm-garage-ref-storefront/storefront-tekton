#!/bin/bash
source ~/config.bc-full 

clear
START_TIME=$(date +%H:%M:%S)
HERE=$(pwd)
echo "working from ${HERE}"

oc new-project tools

# Allow project full-bc to pull the jmeter image
oc policy add-role-to-group system:image-puller system:serviceaccounts:${NAMESPACE}

# Speed optimisations
oc apply -f tools/httpd/httpd-pvc.yaml
oc apply -f tools/httpd/iam-pvc.yaml
oc apply -f tools/httpd/webdav-pvc.yaml 
oc apply -f tools/jmeter-performance-test/influxdb/influxdb-data.yaml
oc patch configs.imageregistry.operator.openshift.io/cluster --patch '{"spec":{"defaultRoute":true}}' --type=merge

# Setup Openshift pipelines
echo "###################################################################"
cd ${HERE}/tools/pipelines
cat banner.txt
./install_pipelines.sh
echo ""

# Setup sonarqube
echo "###################################################################"
cd ${HERE}/tools/sonarqube
cat banner.txt
./install_sonarqube.sh
echo ""

# Setup nexus
echo "###################################################################"
cd ${HERE}/tools/nexus
cat banner.txt
./install_nexus3-v2.sh
echo ""

# Setup jmeter-performance-test
echo "###################################################################"
cd ${HERE}/tools/jmeter-performance-test
./build_jmeter_image.sh  
./install_jmeter_framework.sh
echo ""

# Setup stackrox
echo "###################################################################"
cd ${HERE}/tools/stackrox
cat banner.txt
./build_stackrox_image.sh  
./install_stackrox.sh
echo ""

# Setup httpd
echo "###################################################################"
cd ${HERE}/tools/httpd
./silver-platter-webdav.sh  
echo ""


# Import the openshift cli into the Lab environment
oc import-image cli -n openshift 

# view cannot create pods/portforward
oc policy add-role-to-user admin ${OCP_USER}
oc policy add-role-to-user admin system:serviceaccount:pipelines:pipeline 

# Checks
echo "###################################################################"

IMG=$(oc get is | grep jmeter-prevail-2021 | awk ' { print $1 } ')
if [ $IMG == "jmeter-prevail-2021" ] ; then
    echo "jmeter-prevail-2021 is present"
else
    echo "rinse and repeat for jmeter-prevail-2021 image"
    cd ${HERE}/tools/jmeter-performance-test
    ./build_jmeter_image.sh  
fi

IMG=$(oc get is | grep stackrox-ubi | awk ' { print $1 } ')
if [ $IMG == "stackrox-ubi" ] ; then
    echo "stackrox-ubi is present"
else
    echo "rinse and repeat for stackrox-ubi image"
    cd ${HERE}/tools/stackrox
    ./build_stackrox_image.sh  
fi

cd ${HERE}
END_TIME=$(date +%H:%M:%S)

echo "###################################################################"
echo "Start: ${START_TIME} - Finish: ${END_TIME}"
echo "tools setup = COMPLETED"