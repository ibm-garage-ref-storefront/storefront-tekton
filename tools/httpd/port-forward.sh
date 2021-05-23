#!/bin/bash
clear

SQ=$(oc get po -n tools | grep silver-platter | grep -v deploy | cut -f1 -d" ")
echo "Use the following command to setup port-forwarding to the silver platter:"
echo "oc port-forward $SQ -n tools 8080:8080&"

