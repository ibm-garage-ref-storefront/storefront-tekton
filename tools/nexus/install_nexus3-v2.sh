#!/bin/bash

# reference: https://github.com/m88i/nexus-operator/blob/main/README.md#openshift

oc project tools

cd /tmp

git clone https://github.com/m88i/nexus-operator
cd /tmp/nexus-operator/

sed -i "s/nexus-operator-system/tools/g" nexus-operator.yaml
oc apply -f nexus-operator.yaml 

oc apply -f examples/nexus3-redhat.yaml 

# the account runs under nexus3 as serviceaccount
# oc get -o yaml deployment nexus3  | grep serviceAccountName
oc apply -f examples/scc-persistent.yaml
oc adm policy add-scc-to-user allow-nexus-userid-200 -z nexus3

cd -