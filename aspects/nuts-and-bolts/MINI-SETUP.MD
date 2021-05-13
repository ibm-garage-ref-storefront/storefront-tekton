# The Prevail 2021 setup

### A) Setup the tools namespace

In the current version of this repo we are working on Redhat CRC. It should work on a regular OCP cluster with some care. 

    oc login -u kubeadmin -p <password> https://api.crc.testing:6443
    git clone https://github.com/ibm-garage-ref-storefront/storefront-tekton
    cd storefront-tekton   
    cp scripts/config ~/config.bc-full

Edit the configuration file, and modify OCP_USER and OCP_ADMIN unless you are running on CRC:

    vi ~/config.bc-full

Install the tools:

    bash tools/setup.sh 

Inspect the tools namespace: 

![Deploy](../../images/tools-namespace.png?raw=true "Title")


### B) Setup the tools-images namespace

    oc login -u kubeadmin -p <password> https://api.crc.testing:6443
    bash scripts/tools-images/setup.sh 


### C) Setup the pipelines namespace

Login to sonarqube and make a SONAR_QUBE_PAT:

    bash tools/sonarqube/port-forward.sh

Edit the configuration file, and modify SONAR_QUBE_PAT:

    vi ~/config.bc-full

Initialize the pipeline project / namespace:

    oc login -u kubeadmin -p <password> https://api.crc.testing:6443
    bash scripts/pipeline/mini-setup.sh