#!/bin/bash

echo 'Enter archiva password:'
read w1 
#echo ${w1}

echo 'Enter nexus3 password:'
read w2 
#echo ${w2}

ARTIFACTS="com.ibm.ccbhs.libs:LIB_Logger:1.0.8.0"
ARTIFACTS+="|com.ibm.ccbhs.libs:LIB_AppConfig:2.0.0.1"
ARTIFACTS+="|com.ibm.ccbhs.libs:LIB_Context:1.1.0.0"
ARTIFACTS+="|com.ibm.ccbhs.libs:LIB_XMLParser:1.1.6.1"

ARTIFACTS+="|com.ibm.ccbhs.libs:LIB_Timers:1.1.0.7"
ARTIFACTS+="|com.ibm.ccbhs.libs:LIB_StartupRecovery_Generic:8.0.0.0"
ARTIFACTS+="|com.ibm.ccbhs.libs:jdom:1.1.1"
ARTIFACTS+="|com.ibm.ccbhs.libs:quartz:1.6.5"


# TODO: add the rest

java -jar ~/Downloads/maven-repository-provisioner-1.4.1-jar-with-dependencies.jar \
 -a ${ARTIFACTS} \
 -s "http://9.212.156.201:8082/repository/internal" \
 -su admin \
 -sp ${w1} \
 -t "http://localhost:8081/repository/maven-releases/" \
 -u admin \
 -p ${w2} \
 -includeSources false \
 -includeJavadoc false \
 -checkTarget false \
 -cacheDirectory /tmp/local-cache
