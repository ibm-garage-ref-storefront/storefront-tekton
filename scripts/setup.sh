#!/bin/bash
source ~/config

export HERE=${PWD}
echo "Working from $HERE"

source ~/config

oc new-project $NAMESPACE

echo "temporary artifacts are stored in: " /tmp/$WORKSPACE

if [ -d /tmp/$WORKSPACE ] 
then
    echo "Directory /tmp/$WORKSPACE allready exists, cleaning up." 
    rm -rfi /tmp/$WORKSPACE
    mkdir -pv /tmp/$WORKSPACE
else
    echo "Directory /tmp/$WORKSPACE does not exists."
    mkdir -pv /tmp/$WORKSPACE    
fi

echo "-----------------------------------------------------------------------------"
bash $HERE/scripts/pipeline/setup.sh
echo ""

echo "-----------------------------------------------------------------------------"
bash $HERE/scripts/catalog/setup.sh
echo ""

echo "-----------------------------------------------------------------------------"
export COUCHDB_USER=$COUCHDB_USER
export  COUCHDB_PASSWORD=$COUCHDB_PASSWORD
bash $HERE/scripts/customers/setup.sh
echo ""

echo "-----------------------------------------------------------------------------"
bash $HERE/scripts/orders/setup.sh
echo ""

echo "-----------------------------------------------------------------------------"
bash $HERE/scripts/inventory/setup.sh
echo ""

echo "-----------------------------------------------------------------------------"
bash $HERE/scripts/web/setup.sh
echo ""

echo "-----------------------------------------------------------------------------"
bash $HERE/scripts/auth/setup.sh
echo ""

