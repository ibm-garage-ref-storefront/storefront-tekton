#!/bin/bash
clear

SQ=$(oc get po -n tools | grep sonarqube-sonarqube | cut -f1 -d" ")
echo "Use the following command to setup port-forwarding to sonarqube:"
echo "oc port-forward $SQ -n tools 9000:9000&"

