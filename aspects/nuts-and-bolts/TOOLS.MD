## b) Setup Tools

    cd tools && \
    bash setup.sh && \
    cd .. 

When the script is run, then it will install:
1. the openshift pipeline operator
2. sonarqube. 
3. create an apache httpd server called the silver platter where reports are stored of maven site scans, and jmeter runs.


### b.1) Make a user 

    bash tools/httpd/provide_access.sh

Note: the site scan will reveal vulnerabilities in the dependencies and source. That something to consider when you were to apply such a setup on your customers code, ... 

Test access to the silver platter on the following link on [CRC](http://silver-platter-tools.apps-crc.testing/) 

On IBM DTE the equivalent is:

    SP=$(oc get route | grep silver-platter | awk '{ print $2 }')
    echo https://$SP
