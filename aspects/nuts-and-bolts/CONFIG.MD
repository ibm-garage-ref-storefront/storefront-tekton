# Configure the installer


## a) Edit the configuration file for the setup

    vi ~/config

### a.1) QUAY section

Create a Quay account and create a Quay API key for querying Quay. 

Edit:

    QUAY_USERNAME=
    QUAY_PASSWORD=
    QUAY_EMAIL=
    QUAY_API_TOKEN=

TODO: provide more guidance.


### a.2) IBM Container Registry section

Create an IBM Container Registry account and create an ICR API key for a specific registry. 

Edit:

    ICR_USERNAME=iamapikey
    ICR_API_KEY=
    ICR_EMAIL=
    ICR_REGISTRY_URL=

When you login to the IBM Cloud via the web console you can open the [IBM cloud shell](https://cloud.ibm.com/shell).

Guidance can be found ["here"](https://cloud.ibm.com/docs/Registry?topic=Registry-registry_access). 

Target your region and create a key.

    $ ibmcloud cr region
    You are targeting region 'eu-central', the registry is 'de.icr.io'.

    OK
    $ ibmcloud iam api-key-create blue-compute
    ... details omitted.

### a.3) Sonar Qube section

Login to Sonar Qube and make an access token.

Edit:

    SONAR_QUBE_PAT=

TODO: provide more guidance.
