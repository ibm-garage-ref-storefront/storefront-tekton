#!/bin/bash

# reference: https://github.com/m88i/nexus-operator/blob/main/README.md#openshift

oc project tools

cd /tmp
git clone https://github.com/m88i/nexus-operator

cd /tmp/nexus-operator/
git checkout tags/v0.5.0 

sed -i "s/nexus-operator-system/tools/g" nexus-operator.yaml
oc apply -f nexus-operator.yaml 

sed -i "s/expose: true/expose: false/g" /tmp/nexus-operator/examples/nexus3-redhat.yaml 
oc apply -f examples/nexus3-redhat.yaml 


sleep 10
oc patch nexus.apps.m88i.io/nexus3  \
--patch '{"spec":{"resources":{"requests":{"cpu":"100m"}}}}' --type=merge

echo "use port-forwarding to get to nexus" 

# the account runs under nexus3 as serviceaccount
# oc get -o yaml deployment nexus3  | grep serviceAccountName
oc apply -f examples/scc-persistent.yaml
oc adm policy add-scc-to-user allow-nexus-userid-200 -z nexus3

rm -Rf /tmp/nexus-operator/

cd -