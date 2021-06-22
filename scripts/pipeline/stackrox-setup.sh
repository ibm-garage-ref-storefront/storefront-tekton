#!/bin/bash -e

clear

source ~/config.bc-full

oc project pipelines

oc apply -f tekton-resources/tools-images/ubi-image.yaml





