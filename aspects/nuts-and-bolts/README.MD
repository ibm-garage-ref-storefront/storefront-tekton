# Nuts and Bolts

# Configure the installer

## a) Configuration

    git clone https://github.com/ibm-garage-ref-storefront/storefront-tekton
    cd storefront-tekton   
    cp scripts/config ~/config.bc-full
    ln -sf ~/config.bc-full ~/config
    vi ~/config

### a.1) Preparation on CRC

Comment out the storageClassName on CRC and commented in on IBM Cloud:

    vi tools/httpd/httpd-pvc.yaml




## c) Pipeline Resources

Configure the yaml files in tekton-resources when you want to push to your own quay account of build from your own forks. Otherwise use the defaults.


## d) Setup Application Foundations

The following commands will setup the namespace full-bc on your OCP4 cluster.

    bash scripts/setup.sh

Note: only building the forks was tested at this time.

When the script is run, then it will install:
1. the pipelines (with all tekton ***);
2. the foundational databases and load them (it will take about 1 or 2 minutes until the database is ready). 

Check what you can build with:

    tkn resource list | grep source
    tkn resource list | grep internal
    tkn resource list | grep external


# 3 Lets GO!

## a) Build the microservices

Build the container images via the 

    bash scripts/build.sh

Wait till the tekton "pipelineruns" go from state "Running" to state "Succeeded": 

    watch "tkn pipelinerun list"

Note: you can get the tekton CLI from the openshift web console.

Note: when you pushed your builds out to quay, then you need to make them available to openshift:

    oc import-image auth --from=quay.io/kitty_catt/auth --confirm
    oc import-image catalog --from=quay.io/kitty_catt/catalog --confirm
    oc import-image customer --from=quay.io/kitty_catt/customer --confirm
    oc import-image inventory --from=quay.io/kitty_catt/inventory --confirm
    oc import-image orders --from=quay.io/kitty_catt/orders --confirm
    oc import-image web --from=quay.io/kitty_catt/web --confirm

Check it:

    oc get is

## b) Deploy the microservices

Deploy the microservices.

    bash scripts/deploy.sh


Note: in the OCP console you can inspect the status of the deployments in the namespace (default = full-bc)

    oc whoami --show-console


## c) Make a customer

    bash scripts/customers/make_user.sh

## d) Login and order

Login to the store with the user that you have created and order something from the shop.

## e) Enjoy

Login to the shop and enjoy:

![Enjoy](images/enjoy.png?raw=true "Title")

# notes:
(CouchDB)[http://customercouchdb-full-bc.apps-crc.testing/_utils/]
