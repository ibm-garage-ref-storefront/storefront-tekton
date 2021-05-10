#!/bin/bash

read -p "Enter a username: " UNAME

SP=$(oc get po | grep silver-platter | grep -v deploy | awk '{ print $1 }')
#oc rsh $SP bash -c "htpasswd -c /etc/www/iam/.htpasswd ${UNAME}"

oc rsh $SP bash -c "htpasswd /etc/www/iam/.htpasswd ${UNAME}"
