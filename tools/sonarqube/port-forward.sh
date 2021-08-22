#!/bin/bash
clear

oc project tools
echo ""

SQ=$(oc get po -n tools | grep sonarqube-sonarqube | awk '{ print $1 }')
echo "Use the following command to setup port-forwarding to sonarqube:"
echo "oc port-forward $SQ -n tools 9000:9000&"
echo ""

echo "Or consider lowering the drawbridge:"

while true; do
    read -p "Do you wish to expose sonarqube to the internet (Y/N)?" yn
    case $yn in
        [Yy]* ) 
            oc create route edge --service=sonarqube-sonarqube; 
            break;;
        [Nn]* ) 
            exit;;
        * ) echo "Please answer yes or no.";;
    esac
done

echo ""
SQR=$(oc get routes -n tools | grep sonarqube-sonarqube | awk '{ print $2 }')
echo ""
echo "Open a browser to:"
echo "https://${SQR}/"
echo ""
echo "make the sonarqube PAT .. and ... perhaps you want to consider closing the drawbridge:"
echo ""
echo "oc delete route sonarqube-sonarqube"



