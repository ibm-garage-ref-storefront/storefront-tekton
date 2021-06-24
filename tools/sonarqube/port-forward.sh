#!/bin/bash
clear

SQ=$(oc get po -n tools | grep sonarqube-sonarqube | awk '{ print $1 }')
echo "Use the following command to setup port-forwarding to sonarqube:"
echo "oc port-forward $SQ -n tools 9000:9000&"

