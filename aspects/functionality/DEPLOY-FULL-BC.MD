# Up and Running in a Minute

The following animation shows the installation and configuration of the full IBM blue compute shop.

![Deploy](../../images/deploy-in-a-minute.gif?raw=true "Title")


## a) Deploy the shop using a template.

Login to the cluster:

    oc login --token=... --server=...

Note: you can get the oc CLI from the openshift web console.

Get the Application Load Balancer address:

    KVP=$(oc describe deploy router-default -n openshift-ingress | grep ROUTER_CANONICAL_HOSTNAME)
    APPLB=$(echo $KVP|awk '{print $2}')
    echo $APPLB

Example output for the prevail workshop environment:

    $ echo $APPLB
    prevail-wrkshp-new-roks-915b3b336cabec458a7c7ec2aa7c625f-0000.ams03.containers.appdomain.cloud

Deploy the shop using pre-build images (notes: substitute the value for APPLB and NAMESPACE):

    oc new-project full-bc
    NAMESPACE=$(oc project -q)
    oc create -f template/blue-compute-template.yaml 
    oc new-app --template blue-compute-shop \
    -p APPLB=$APPLB \
    -p NAMESPACE=$NAMESPACE


## b) Check the Deployment

Inspect the full-bc namespace via the web console and see the shop come alive.

You can find the ULR of the openshift cluster, via:

    oc whoami --show-console

Alternatively, check the deployment state via the console:

    watch oc get po

It will take about 5 minutes before the pods all get into the running state. 
They are is waiting until storage gets assigned. 
Once that completes, the mysql and mariadb pods will be able to start. 
And next the inventory and order micros can connect to it, and will come alive.


## c) Configure the shop

Load the database:

    bash scripts/inventory/load-database.sh 

Make a user:

    bash scripts/customers/make_user.sh 

Login to the shop via the route on the web deployment.

Note: it will take a minute or 2 before the inventory database content is reflected in the catalog.

## d) Enjoy

Login to the shop and enjoy:

![Enjoy](../../images/enjoy.png?raw=true "Title")


# 2 Tear Down (optional)

   oc delete project full-bc

# Trivia

The template has been developed tested on Redhat CRC.

Example on CRC:    

    oc new-app --template blue-compute-shop \
    -p APPLB=apps-crc.testing \
    -p NAMESPACE=full-bc
