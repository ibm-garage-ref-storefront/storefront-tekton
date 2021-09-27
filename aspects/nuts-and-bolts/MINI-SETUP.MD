# The Prevail 2021 setup

## Find your RHOCP user

Find your user:

    oc whoami

Example output:

    IAM#kitty-catt@example.com


### A) Setup the tools namespace

Edit the configuration file:  

    # if you like vi
    vi ~/config.bc-full

    # if you like nano (use ctl O to save, and ctl X to exit)
    nano ~/config.bc-full

If you prefer a graphical environment then you could login to the VNC console. This is not preferred as the API tokens that we have to edit later during the lab are long and cannot be pasted through VNC.

Notes:
- Set your User as value in OCP_ADMIN (example value `IAM#kitty-catt@example.com`). Your user has the cluster-role in the IBM Lab Environment;
- Set your User as value in OCP_USER (example value `IAM#kitty-catt@example.com`). This user will become project admin for various projects on your RHOCP cluster;
- Modify SLACK_URL and SLACK_CHANNEL when you have a slack channel that you can post to (optional).

Install the tools:

    bash tools/setup.sh 

Note:
- it will take about 10 to 15 minutes until the setup completes on the IBM Lab Environment.
- there will be the occasional warning. These can be ignored.

Inspect the tools namespace: 

![Deploy](../../images/tools-namespace.png?raw=true "Title")

Inspect the tools and see if you can login

| Aspect | Description | Default Credentials |
| --- | --- | --- |
| sonarqube| source vulnerability scanner | admin / admin
| nexus3 | maven artifact repository for builds| admin / admin123
| silver-platter | maven site reports for dependency vulnerability scanning | aot-user / ibm-prevail-2021
| grafana | jmeter performance dashboard | root / secret (anonymous access enabled), go to dashboard, manage, tools


### B) Setup the tools-images namespace


    bash scripts/tools-images/setup.sh 


### C) Setup the pipelines namespace

Setup port-forwarding:

    bash tools/sonarqube/port-forward.sh

Login to sonarqube via the [forwarded port](http://localhost:9000) ("right-click and open this link").

It may take half a minute to get connected.

Make a SONAR_QUBE_PAT via create new project and generate a key. 

Edit the configuration file, and modify SONAR_QUBE_PAT:

    vi ~/config.bc-full

Initialize the pipeline project / namespace:


    bash scripts/pipeline/mini-setup.sh

# Checkpoint

Login to the pipelines project and see that you have access to the pipelines.

Via the GUI:

![Deploy](../../images/inspect-pipelines.png?raw=true "Title")

Or via the CLI:

    tkn pipeline list

Inspect the persistent volume claims and see them transition from state Pending to Bound:

    oc get pvc

Inspect the images in the tools namespace:

    if [ $(oc get is -n tools | grep 5000 | wc -l) -eq 3 ] ; then echo OK ; else echo NoK ; fi

There must be 3 images. If there are less then inspect:

    oc get is -n tools

And repair if necessary:    

    cd tools/stackrox/
    tools/stackrox/build_stackrox_image.sh
    cd -

    cd tools/jmeter-performance-test/
    tools/jmeter-performance-test/build_jmeter_image.sh
    cd -

# Trivia

This repo was developed on Redhat CRC where 2 users exist (kubeadmin and developer). 

On CRC the setup is run under kubeadmin. On that environment you can make distinction between a cluster-admin and a project admin.

It is not possible to add additional users on the IBM Lab environment.
