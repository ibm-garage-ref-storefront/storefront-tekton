#!/bin/bash
source ~/config

echo "deploy auth service for OAuth 2.0 authentication"

oc new-app --name=auth-ms-spring \
  -e HS256_KEY=${HS256_KEY} \
  -e CUSTOMER_URL="http://customer-ms-spring:8080/micro/customer/search" \
  --image-stream=auth \
  -l app.kubernetes.io/part-of=auth-subsystem

oc expose svc/auth-ms-spring --port=8080 \
  -l app.kubernetes.io/part-of=auth-subsystem