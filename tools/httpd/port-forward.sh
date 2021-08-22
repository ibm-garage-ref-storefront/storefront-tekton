#!/bin/bash
clear

#SQ=$(oc get po -n tools | grep silver-platter | grep -v deploy | cut -f1 -d" ")
echo "Use the following command to setup port-forwarding to the silver platter:"
echo "oc port-forward svc/silver-platter -n tools 8080:8080&"

echo ""

echo "Or consider lowering the drawbridge:"

while true; do
    read -p "Do you wish to expose the silver-platter to the internet (Y/N)?" yn
    case $yn in
        [Yy]* ) 
            oc create route edge --service=silver-platter; 
            break;;
        [Nn]* ) 
            exit;;
        * ) echo "Please answer yes or no.";;
    esac
done

echo ""
SILVER=$(oc get routes -n tools | grep silver-platter | awk '{ print $2 }')
echo ""
echo "Open a browser to:"
echo "https://${SILVER}/"
echo ""
echo " .. and ... perhaps you want to consider closing the drawbridge when you are done:"
echo ""
echo "oc delete route silver-platter"