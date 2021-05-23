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

Example output:

    loading the inventory microservice
    % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                    Dload  Upload   Total   Spent    Left  Speed
    100 11192  100 11192    0     0  32719      0 --:--:-- --:--:-- --:--:-- 32821
    found pod: inventorymysql-1-6ls87
    database initialized succesfully

Make a user:

    bash scripts/customers/make_user.sh 

Login to the shop via the route on the web deployment.

Notes: 
- we suggest that you create the default user foo with the password bar to make automatic testing a bit easier;
- it will take a minute or 2 before the inventory database content is reflected in the catalog;
- creating the user will give some complaints about "Insufficient scope", this can be ignored.

## d) Enjoy

Login to the shop, find the URL via:

    oc get routes | grep web

Enjoy:

![Enjoy](../../images/enjoy.png?raw=true "Title")

You can login to the shop and place an order.



# 2 Tear Down (optional)

   oc delete project full-bc


# 3 Trivia

The template has been developed tested on Redhat CRC.

Example on CRC:    

    oc new-app --template blue-compute-shop \
    -p APPLB=apps-crc.testing \
    -p NAMESPACE=full-bc
