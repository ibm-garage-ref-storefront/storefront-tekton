This directory stores an openshift template which was:
- exported from a running blue compute deployment 
- cleaned up via the clean script
- parameterized.

Procedure:

    oc get -o json secret,cm,deployment,deploymentconfig,svc,route,pvc  > exported-resources.json
    bash clean_template.sh exported-resources.json > blue-compute-template.json
    create -f blue-compute-template.json 
    oc get template -o yaml template-name > blue-compute-template.yaml

Next open blue-compute-template.yaml and modify it to your liking.