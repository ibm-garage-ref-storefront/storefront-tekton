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

TODO: provide more guidance.


### a.3) Sonar Qube section

Login to Sonar Qube and make an access token.

Edit:

    SONAR_QUBE_PAT=

TODO: provide more guidance.
