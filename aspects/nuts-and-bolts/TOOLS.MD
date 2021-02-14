# The Tools namespace

With the [configuration preparation](CONFIG.MD) in place we can now initialize the tools namespace.

When the script is run, then it will :
1. add a policy to allow access for the service accounts in the full-bc project to the JMeter image.
2. install the openshift pipeline operator;
3. install sonarqube;
4. install an apache httpd server called the silver platter where reports are stored of maven site scans, and jmeter runs.

The example given is for CRC. The should work on any Openshift Cluster where you have access to the admin role.

# a) Edit the storage class

Comment out the storageClassName on CRC and comment it in on IBM Cloud:

    vi tools/httpd/httpd-pvc.yaml

# b) Login with the admin role

    crc console --credentials
    oc login -u kubeadmin  https://api.crc.testing:6443

# c) Setup Tools

    cd tools && \
    bash setup.sh && \
    cd .. 

### c.1) Change the sonarqube admin password.

If you have chosen to expose the route to sonarqube on anything but a simple CRC installation, then change the sonarqube admin password.

    oc get routes


### c.2) Make a user to access the silver platter

    bash tools/httpd/provide_access.sh

Note: the site scan will reveal vulnerabilities in the dependencies and source. That something to consider when you were to apply such a setup on your customers code, ... 

Test access to the silver platter on the following link on [CRC](http://silver-platter-tools.apps-crc.testing/) 

On IBM DTE the equivalent is:

    SP=$(oc get route | grep silver-platter | awk '{ print $2 }')
    echo https://$SP
