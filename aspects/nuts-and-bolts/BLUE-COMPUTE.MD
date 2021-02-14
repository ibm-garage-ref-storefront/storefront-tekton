# Setting up the Blue Compute namespace.

# a) (Optional) Configure the Pipeline Resources

When you want build your own forks ... then configure the yaml files in tekton-resources.

# b) Login as developer

    crc console --credentials
    oc login -u developer -p developer https://api.crc.testing:6443

# c) initialize the namespace

    bash scripts/setup-pipelines.sh

Choose forks when you want to build from your own forks.