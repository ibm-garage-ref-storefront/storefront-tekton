# Preparation

## a) Get an OCP 4 cluster that provides Openshift Pipelines 

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

