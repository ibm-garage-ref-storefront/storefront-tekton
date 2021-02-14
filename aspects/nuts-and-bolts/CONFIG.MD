# Configure the installer

## a) Clone the Repo

    git clone https://github.com/ibm-garage-ref-storefront/storefront-tekton
    cd storefront-tekton   
    cp scripts/config ~/config.bc-full
    ln -sf ~/config.bc-full ~/config


## b) Edit the configuration file for the setup

    vi ~/config

### b.1) config - QUAY section

Create a Quay account and create a Quay API key for querying Quay. TODO: provide more guidance.

### b.2) config - IBM Container Registry section

Create an IBM Container Registry account and create an ICR API key for a specific registry. TODO: provide more guidance.

## c) edit the storage class

Comment out the storageClassName on CRC and comment it in on IBM Cloud:

    vi tools/httpd/httpd-pvc.yaml

