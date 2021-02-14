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

