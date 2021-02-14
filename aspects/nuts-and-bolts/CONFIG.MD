# Configure the installer

## a) Clone the Repo

    git clone https://github.com/ibm-garage-ref-storefront/storefront-tekton
    cd storefront-tekton   
    cp scripts/config ~/config.bc-full
    ln -sf ~/config.bc-full ~/config


## b) Edit the configuration file for the setup

    vi ~/config

### b.1) 

## c) storage class

Comment out the storageClassName on CRC and comment it in on IBM Cloud:

    vi tools/httpd/httpd-pvc.yaml

