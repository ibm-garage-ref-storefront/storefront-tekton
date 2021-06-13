# Welcome to IBM Prevail 2021

The IBM Blue Compute shop will be tested on its functionality. The pipeline is stubbed except for the functional test.

## Pre-requisites

### a) Deploy the IBM Blue Compute shop

[Deploy](../functionality/DEPLOY-FULL-BC.MD) the IBM Blue Compute shop if you have not allready done so.

### b) Install the tooling and pipelines

[Install](../nuts-and-bolts/MINI-SETUP.MD) the tooling if you have not allready done so.

### c) Scan and Import the Images

[Scan and Import](../nuts-and-bolts/SCAN.MD) the images that are used by the tool-chain if you have not allready done so.


# The functionality section of the pipeline

The peformance pipeline looks similar to the security pipeline.  Actually, it is the same.

![Fail](../../images/functionality-pipeline.png?raw=true "Title")

There is one difference: all tasks except for the functional test have been stubbed.


## Lets run the functionality pipeline

The functional test plan will login to the blue compute shop with user foo and order a calculator. Every time that you run the functional test you will see an additional entry in the order history of user foo.

![Fail](../../images/order-a-calculator.png?raw=true "Title")

Nough said, lets run it:

    oc create -f tekton-pipeline-run/customer-functionality-pipeline-ibm-prevail-2021-build-breaker.yaml
    scripts/watch-the-pipeline-run.sh

Low and behold, the jmeter functionality test stopped the pipeline run:

![Fail](../../images/functionality-breaks.png?raw=true "Title")

There's got to be an error.

Login to the silver-platter and see what is the matter:

    SPR=$(oc get routes.route.openshift.io -n tools | grep silver | awk '{ print $2 }' )
    echo http://$SPR 

Login with the user and password as described in the tools setup, and navigate to the report.

![Fail](../../images/functionality-breaks.png?raw=true "Title")    

See if you can find out what went wrong. 

Remember the order history? Is there something missing?  .. JMeter detected it ..