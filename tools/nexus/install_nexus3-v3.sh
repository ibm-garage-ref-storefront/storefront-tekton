#!/bin/bash

#cat banner.txt

# reference: https://github.com/m88i/nexus-operator/blob/main/README.md#openshift

oc project tools

cd /tmp
git clone https://github.com/sonatype/operator-nxrm3

cd /tmp/operator-nxrm3/helm-charts/sonatype-nexus
git checkout tags/3.41.1-1

helm install -f ./values.yaml nexus .

nexus=$(oc get po -n tools | grep nexus3- | cut -f1 -d" ")
echo "Use the following command to setup port-forwarding to nexus:"
echo "oc port-forward $nexus -n tools 8081:8081&"

rm -Rf /tmp/operator-nxrm3/

cd -