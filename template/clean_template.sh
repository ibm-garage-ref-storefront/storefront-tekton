#!/bin/bash

cat $1 | jq '[.items[] | 
  del( 
    .status,
    .metadata.managedFields,
    .metadata.selfLink,
    .metadata.resourceVersion,
    .metadata.uid,
    .metadata.annotations."openshift.io/generated-by",
    .metadata.generation,
    .metadata.namespace,
    .metadata.creationTimestamp,
    ( select(.kind == "BuildConfig") .spec.triggers[].imageChange.lastTriggeredImageID ),
    ( select(.kind == "DeploymentConfig") .spec.triggers[].imageChangeParams.lastTriggeredImage ),
    ( select(.kind == "Service") .spec.clusterIP )
  )] |
  { 
    apiVersion: "template.openshift.io/v1",
    kind: "Template", 
    metadata: { name: "template-name"},
    objects: ., 
  }'