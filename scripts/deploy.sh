#!/bin/bash
source ~/config

echo "deploying microservices"
export HERE=${PWD}
echo "Working from $HERE"


bash $HERE/scripts/catalog/deploy.sh
bash $HERE/scripts/inventory/deploy.sh
bash $HERE/scripts/orders/deploy.sh

# NOTE: there is a required sequence of deploying 
# - web requires auth to be deployed first as it needs to set the generated route to auth in its env

bash $HERE/scripts/customers/deploy.sh
bash $HERE/scripts/auth/deploy.sh
bash $HERE/scripts/web/deploy.sh
