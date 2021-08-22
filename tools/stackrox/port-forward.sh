#!/bin/bash
clear

echo "Use the following command to setup port-forwarding to stackrox:"
echo "oc port-forward svc/central -n stackrox 8443:443&"

echo ""

echo "Or consider lowering the drawbridge:"

while true; do
    read -p "Do you wish to expose stackrox to the internet (Y/N)?" yn
    case $yn in
        [Yy]* ) 
            oc create route passthrough --service=central -n stackrox --port=8443; 
            break;;
        [Nn]* ) 
            exit;;
        * ) echo "Please answer yes or no.";;
    esac
done

echo ""
STACK=$(oc get routes -n stackrox | grep central | awk '{ print $2 }')
echo ""
echo "Open a browser to:"
echo "https://${STACK}/"
echo ""
echo " .. and ... perhaps you want to consider closing the drawbridge when you are done:"
echo ""
echo "oc delete route central -n stackrox"