# Welcome to IBM Prevail 2021

We will inspect the running status of the blue compute shop via stackrox.

## Pre-requisites

### a) Deploy the IBM Blue Compute shop

[Deploy](../functionality/DEPLOY-FULL-BC.MD) the IBM Blue Compute shop if you have not allready done so.

### b) Install the tooling and pipelines

[Install](../nuts-and-bolts/MINI-SETUP.MD) the tooling if you have not allready done so.


# StackRox Cluster Monitoring

The tools setup will have installed stackrox. 

Verify using:

    watch oc get po -n stackrox

Output:

Every 2.0s: oc get po -n stackrox             kitty-catt-server.ibm.com: Sun Jul  4 12:24:21 2021

NAME                          READY   STATUS    RESTARTS   AGE
central-7df8c69d6b-lvdsb      1/1     Running   0          2m33s
scanner-7dd9877c46-h2b7r      1/1     Running   0          2m33s
scanner-7dd9877c46-jrnmp      1/1     Running   0          2m33s
scanner-7dd9877c46-kq5x2      1/1     Running   0          2m33s
scanner-db-74f5b84444-z65wv   1/1     Running   0          2m33s

