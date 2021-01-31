# 1 Purpose

This repository aims to deploy the full IBM Blue Compute shop with a single command into an Openshift Cluster. 

Once the blue compute shop is up and running your can choose to explore various aspects:

| Aspect | Description |
| --- | --- |
| [Security](aspects/security/README.MD) | a Tekton Pipeline that builds and scans the microservice for vulnerabilities |
| [Functionality](aspects/functionality/README.MD) | a Tekton Pipeline that build, deploys and performs a functional test of a microservice |
| [Performance](aspects/performance/README.MD) | a Tekton Pipeline that performs a load test on the blue compute shop |
| [Availabilty](aspects/availability/README.MD) | To be decided |
| [Nuts and Bolts](aspects/nuts-and-bolts/README.MD) | For nuts and bolts lovers |


# 2 Preparation

Get yourself a free Openshift 4 cluster for a couple of hours:

[IBM Open Labs](https://developer.ibm.com/openlabs/openshift)

Or ... go where the wild ducks fly and get CRC:

[Redhat CRC](https://developers.redhat.com/products/codeready-containers/overview)

Note on CRC:
- CRC was installed on RHEL 7;
- this repo was tested a 4-core i7 with hyperthreading and 32 GB RAM;
- About 2 vCPU are used by CRC;
- the memory was set to 16 GB and approximatly 12 GB of RAM is used by CRC.

Get the login (right top side of the OCP console, IAM, copy login command).

Login to the cluster:

    oc login --token=... --server=...

Note: you can get the oc CLI from the openshift web console.

# 2 Up and Running in a Minute

## a) Configuration

    git clone https://github.com/ibm-garage-ref-storefront/storefront-tekton
    cd storefront-tekton   
    cp scripts/config ~/config.bc-full
    ln -sf ~/config.bc-full ~/config
    vi ~/config

## b) Deploy the shop using a template.

```diff
- The template has been tested on Redhat CRC.
+ It should work on IBM cloud when you set the APPLB template parameter.
```

Get the Application Load Balancer address:

    APPLB=$(oc describe  deployment router-default -n openshift-ingress | grep ROUTER_CANONICAL_HOSTNAME |awk '{print $2}')
    echo $APPLB

Deploy the shop using pre-build images (substitute the value for APPLB):

    oc new-project full-bc
    oc create -f template/blue-compute-template.yaml 
    oc new-app --template blue-compute-shop -p APPLB=$APPLB

Example on CRC:    

    oc new-app --template blue-compute-shop -p APPLB=apps-crc.testing

Inspect the full-bc namespace console and see the shop come alive.

    oc whoami --show-console

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

