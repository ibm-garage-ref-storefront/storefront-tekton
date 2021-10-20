# !/bin/sh
# set -x

# CLIs required:
# * oc

# Before running this script:
# * login to your OpenShift Cluster
# * Use this command to get operator name - oc get packagemanifests -n openshift-marketplace

# Set Variables
OPERATOR_NAME=$1 
FILE=operator-desc.yaml 

# Checking if user is logged-in to OpenShift Cluster
# echo "oc whoami"
oc whoami

if [ $? == 1 ] 
then
    echo 'You are not logged-in. Login to OpenShift Cluster (oc login)'
    exit 0
fi

OPERATOR_INFO=`oc get packagemanifests -n openshift-marketplace|grep $OPERATOR_NAME`
echo "**Operator Info:"
echo
echo "$OPERATOR_INFO"

if [ -f "$FILE" ]; then
    rm -f $FILE
fi

## Fetching the operator details..."
oc describe packagemanifests $OPERATOR_NAME -n openshift-marketplace > $FILE
# echo "$FILE created"

## Creating Subscription object YAML..."
SUBSCRIPTION_FILE=subscription.yaml
cp subscription.yaml.template $SUBSCRIPTION_FILE

## replace operator-name
operator_name=`cat $FILE | grep -E '^Name\b' | cut -d ':' -f 2 | xargs`
sed -i s#operator_name#$operator_name#g $SUBSCRIPTION_FILE

## replace source-name
source_name=`cat $FILE | grep 'Catalog Source:' | cut -d ':' -f 2 | xargs`
sed -i s#source-name#$source_name#g $SUBSCRIPTION_FILE

## replace channel-name
channel_name=`cat $FILE | grep 'Default Channel:' | cut -d ':' -f 2 | xargs`
sed -i s#channel-name#$channel_name#g" $SUBSCRIPTION_FILE

## replace namespace-name
# echo "namespace name = openshift-operators"
sed -i s#namespace_name#openshift-operators#g" $SUBSCRIPTION_FILE

echo
echo
echo "**Installing operator $OPERATOR_NAME: "
oc apply -f $SUBSCRIPTION_FILE

sleep 15
echo
echo "Operator installed successfully."
