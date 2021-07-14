# Up and Running in a Minute

The following animation shows the installation and configuration of the full IBM blue compute shop.

![Deploy](../../images/deploy-in-a-minute.gif?raw=true "Title")

The blue compute shop is run by by the rebels on the fourth moon of a planet called Yavin.


## a) Deploy the shop using a template.

Login to the cluster:

    oc login --token=... --server=...

Note: you can get the oc CLI from the openshift web console.

Get the Application Load Balancer address:

    KVP=$(oc describe deploy router-default -n openshift-ingress | grep ROUTER_CANONICAL_HOSTNAME)
    APPLB=$(echo $KVP|awk '{print $2}')
    echo $APPLB

Example output for the prevail workshop environment:

    prevail-wrkshp-new-roks-915b3b336cabec458a7c7ec2aa7c625f-0000.ams03.containers.appdomain.cloud

The customer-ms-spring microservice is deliberately deployed as a root pod for educational purposes. For this we have to grant extra permissions.

    oc new-project full-bc
    oc adm policy add-scc-to-user anyuid -z customer-ms-spring-sa

Deploy the shop using pre-build images (notes: substitute the value for APPLB and NAMESPACE):

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
The backing services (e.g. mysql) of them will be in state "Pending" until storage gets assigned. Some of them (e.g. the inventory ms) will flip into the "Error" state because they depend on their backing Deployments to be up and "Running". After 4 or 5 minutes the shop will be in state "Running".

Expected result:

    NAME                                   READY   STATUS      RESTARTS   AGE
    auth-ms-spring-cff7b487-m4rdk          1/1     Running     0          7m11s
    catalog-ms-spring-6956b7bfdb-smfvw     1/1     Running     0          7m11s
    catalogelasticsearch-c8944d99f-rjj9c   1/1     Running     0          7m11s
    customer-ms-spring-569d6f6cfd-zcsxb    1/1     Running     0          7m11s
    customercouchdb-767c98c59-hdpzm        1/1     Running     0          7m11s
    inventory-ms-spring-5d4fc4768f-tcsr6   1/1     Running     3          7m11s
    inventorymysql-1-deploy                0/1     Completed   0          7m9s
    inventorymysql-1-vwtpp                 1/1     Running     0          6m24s
    orders-ms-spring-8654cc8dd6-rhj8s      1/1     Running     3          7m11s
    ordersmysql-1-deploy                   0/1     Completed   0          7m9s
    ordersmysql-1-fdzqd                    1/1     Running     0          5m34s
    web-688d87d9c5-bhdws                   1/1     Running     0          7m11s

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
- we suggest that you create the default user foo with the password bar because that user is used in the testplan to order a calculator from the shop;
- it will take a minute or 2 before the inventory database content is reflected in the catalog;
- creating the user will give some complaints about "Insufficient scope", this can be ignored.

## d) Enjoy

Login to the shop, find the URL via:

    oc get routes | grep web

Enjoy:

![Enjoy](../../images/enjoy.png?raw=true "Title")

You can login to the shop and place an order.

![Order](../../images/place-order.png?raw=true "Title")


## e) Get into the root pod

    oc rsh $(oc get po -l deployment=customer-ms-spring --output custom-columns=:.metadata.name)

Examine who you are:

    id

Expected output:

    sh-4.2# id
    uid=0(root) gid=0(root) groups=0(root)    

Explore the env:

    env | grep PASS

Expected output:

    sh-4.2# env | grep PASS
    COUCHDB_PASSWORD=passw0rd

Install some tools:

    yum install -y tcpdump
    yum install -y nmap
    yum install -y jq

Get the CouchDB address:

    CD_HOST=$(env | grep CUSTOMERCOUCHDB_SERVICE_HOST | cut -d"=" -f2)
    CD_USER=$(env | grep COUCHDB_USERNAME | cut -d"=" -f2)
    CD_PASSWORD=$(env | grep COUCHDB_PASSWORD | cut -d"=" -f2)

And there we go:

    curl http://${CD_USER}:${CD_PASSWORD}@${CD_HOST}:5984/_all_dbs

Expected result:

    sh-4.2# curl -s http://${CD_USER}:${CD_PASSWORD}@${CD_HOST}:5984/_all_dbs
    ["customers"]

Get the content of the database:

    curl -s http://${CD_USER}:${CD_PASSWORD}@${CD_HOST}:5984/customers/_all_docs?include_docs=true|jq

Then something happens:

![Order](../../images/potential-data-breach.png?raw=true "Title")

Let us hope for Jedi Master foo and his Friends that they do not re-use the passwords on other sites in the Galaxy. 

Also, the blue compute shop company is at risk as the safety of the shop is held by the last defenses.

If the hacker were able to perform remote code execution ..

Suddenly it feels chilly on Yavin 4 ..

Can developer Cody defend the shop? 


# 2 Tear Down (optional)

   oc delete project full-bc


# 3 Trivia

The template has been developed tested on Redhat CRC.

Example on CRC:    

    oc new-app --template blue-compute-shop \
    -p APPLB=apps-crc.testing \
    -p NAMESPACE=full-bc
