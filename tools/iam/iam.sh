#!/bin/bash

# the book:
#yum install -y httpd-utils

# RHEL 8.4:
#yum provides \*bin/htpasswd
#sudo yum install -y httpd-tools

#htpasswd -c -B -b htpasswd.sec developer developer
oc create secret generic htpasswd-secret --from-file htpasswd=htpasswd.sec -n openshift-config
oc replace -f oauth.yaml 

# RHOCP on IBM Cloud does not allow it ;)