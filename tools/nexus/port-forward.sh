#!/bin/bash
clear

echo "Use the following command to setup port-forwarding to the nexus3:"
echo "oc port-forward svc/nexus3 -n tools 8081:80&"

echo ""

echo "Or consider lowering the drawbridge:"

while true; do
    read -p "Do you wish to expose the nexus3 to the internet (Y/N)?" yn
    case $yn in
        [Yy]* ) 
            oc create route edge --service=nexus3 -n tools; 
            break;;
        [Nn]* ) 
            exit;;
        * ) echo "Please answer yes or no.";;
    esac
done

echo ""
SILVER=$(oc get routes -n tools | grep nexus3 | awk '{ print $2 }')
echo ""
echo "Open a browser to:"
echo "https://${SILVER}/"
echo ""
echo " .. and ... perhaps you want to consider closing the drawbridge when you are done:"
echo ""
echo "oc delete route nexus3 -n tools"