# Welcome to IBM Prevail 2021

The IBM Blue Compute shop will be performance tested. The pipeline is stubbed except for the performance test.

## Pre-requisites

### a) Deploy the IBM Blue Compute shop

[Deploy](../functionality/DEPLOY-FULL-BC.MD) the IBM Blue Compute shop if you have not allready done so.

### b) Install the tooling and pipelines

[Install](../nuts-and-bolts/MINI-SETUP.MD) the tooling if you have not allready done so.

### c) Scan and Import the Images

[Scan and Import](../nuts-and-bolts/SCAN.MD) the images that are used by the tool-chain if you have not allready done so.


# The performance section of the pipeline

The peformance pipeline looks similar to the security pipeline.  Actually, it is the same.

![Fail](../../images/performance-pipeline.png?raw=true "Title")

There is one difference: all tasks except for the performance test have been stubbed.


## Lets run the performance pipeline

Lets create a run with 5 parallel users, each executing the JMeter testplan 25 times.

    oc create -f tekton-pipeline-run/customer-performance-pipeline-ibm-prevail-2021.yaml 
    scripts/watch-the-pipeline-run.sh  

It is possible to watch the pipeline run via the graphical console as well.

![Fail](../../images/performance-test-run.png?raw=true "Title")


## Inspect the performance dashboard.

![Fail](../../images/performance-test.png?raw=true "Title")


## Ramp it up

Lets create another run with 10 parallel users, each executing the JMeter testplan 25 times.

    oc create -f tekton-pipeline-run/customer-performance-pipeline-ibm-prevail-2021-10-users.yaml 

## Add or Configure a Performance Build Breaker:

On the customer-ms-spring repo, open the jmeter testplan and configure the performance build breaker:

![Fail](../../images/performance-build-breaker-1.png?raw=true "Title")

It is set to break the build when response times are encountered below 30 ms.

Run it:

    oc create -f tekton-pipeline-run/customer-performance-pipeline-ibm-prevail-2021-performance-build-breaker.yaml 
    scripts/watch-the-pipeline-run.sh 

In the output of the Pipeline Run you will find that a certain percentage of the calls fails to meet the response duration assertion of 30 milli-seconds. 

Example line:

    [performance-test : jmeter-it] summary +    292 in 00:00:30 =    9.7/s Avg:    11 Min:     1 Max:   194 Err:    12 (4.11%) Active: 10 Started: 10 Finished: 0

The pipeline run will now fail to complete. 

![Fail](../../images/performance-build-breaker-3.png?raw=true "Title")

Also Grafana will display the errors:

![Fail](../../images/performance-build-breaker-2.png?raw=true "Title")

During the performance test

Run:

    watch oc adm top nodes