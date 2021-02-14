#!/bin/bash
source ~/config

oc new-project tools

# Allow project full-bc to pull the jmeter image
oc policy add-role-to-group system:image-puller system:serviceaccounts:${NAMESPACE}

# Setup Openshift pipelines
echo "###################################################################"
cd pipelines
./install_pipelines.sh
cd ..
echo ""

# Setup sonarqube
echo "###################################################################"
cd sonarqube
./install_sonarqube.sh
cd ..
echo ""

# Setup httpd
echo "###################################################################"
cd httpd
./silver-platter.sh 
cd ..
echo ""
