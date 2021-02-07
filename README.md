# 1 Purpose

This repository aims to:
- deploy the full IBM Blue Compute shop with a single command into an Openshift Cluster;
- setup Openshift Pipelines (based on Tekton) to perform builds, deployment and various tests.

Once the blue compute shop is up and running your can choose to explore various aspects:

| Aspect | Description |
| --- | --- |
| [Security](aspects/security/README.MD) | a Tekton Pipeline that builds and scans the microservice for vulnerabilities |
| [Functionality](aspects/functionality/README.MD) | a Tekton Pipeline that build, deploys and performs a functional test of a microservice |
| [Performance](aspects/performance/README.MD) | a Tekton Pipeline that performs a load test on the blue compute shop |
| [Availabilty](aspects/availability/README.MD) | To be decided |
| [Nuts and Bolts](aspects/nuts-and-bolts/README.MD) | For nuts and bolts lovers |

Follow the mandatory [preparation](aspects/general/preparation.md)

# 2 Up and Running in a Minute


## a) Deploy the shop using a template.

```diff
- The template has been tested on Redhat CRC.
+ It should work on IBM cloud when you set the APPLB template parameter.
```
Login to the cluster:

    oc login --token=... --server=...

Note: you can get the oc CLI from the openshift web console.

Get the Application Load Balancer address:

    KVP=$(oc describe deploy router-default -n openshift-ingress | grep ROUTER_CANONICAL_HOSTNAME)
    APPLB=$(echo $KVP|awk '{print $2}')
    echo $APPLB

Deploy the shop using pre-build images (notes: substitute the value for APPLB and NAMESPACE):

    oc new-project full-bc
    NAMESPACE=$(oc project -q)
    oc create -f template/blue-compute-template.yaml 
    oc new-app --template blue-compute-shop \
    -p APPLB=$APPLB \
    -p NAMESPACE=$NAMESPACE

Example on CRC:    

    oc new-app --template blue-compute-shop \
    -p APPLB=apps-crc.testing \
    -p full-bc

Inspect the full-bc namespace console and see the shop come alive.

    xdg-open $(oc whoami --show-console) 2>/dev/null

## b) Configure the shop

Load the database:

    bash scripts/inventory/load-database.sh 

Make a user:

    bash scripts/customers/make_user.sh 

Login to the shop via the route on the web deployment.

Note: it will take a minute or 2 before the inventory database content is reflected in the catalog.

## c) Enjoy

Login to the shop and enjoy:

![Enjoy](images/enjoy.png?raw=true "Title")


# 3 Tear Down

   oc delete project full-bc

