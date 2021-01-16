#!/bin/bash

read -p "Enter the username: " UNAME

SP=$(oc get po | grep silver-platter | awk '{ print $1 }')
oc rsh $SP bash -c "htpasswd -c /etc/httpd/conf/.htpasswd ${UNAME}"
