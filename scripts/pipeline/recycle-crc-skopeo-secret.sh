#!/bin/bash

source ~/config
echo "Recycle crc-creds-skopeo secret"

mkdir -pv /tmp/$WORKSPACE/

cp skopeo/crc-secret.yaml /tmp/$WORKSPACE/crc-secret.yaml

oc delete secret crc-creds-skopeo

CRC_USER=$(oc whoami)
CRC_PASSWORD=$(oc whoami -t)
sed -i "s/CRC_USER/${CRC_USER}/g" /tmp/$WORKSPACE/crc-secret.yaml
sed -i "s/CRC_PASSWORD/${CRC_PASSWORD}/g" /tmp/$WORKSPACE/crc-secret.yaml
oc apply -f  /tmp/$WORKSPACE/crc-secret.yaml
