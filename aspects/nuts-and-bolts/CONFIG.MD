# Configure the installer


## a) Edit the configuration file for the setup

    vi ~/config

### a.1) config - QUAY section

Create a Quay account and create a Quay API key for querying Quay. TODO: provide more guidance.

### a.2) config - IBM Container Registry section

Create an IBM Container Registry account and create an ICR API key for a specific registry. TODO: provide more guidance.

## b) edit the storage class

Comment out the storageClassName on CRC and comment it in on IBM Cloud:

    vi tools/httpd/httpd-pvc.yaml

