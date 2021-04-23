oc project tools

#oc get packagemanifests -n openshift-marketplace --sort-by=.metadata.name | grep openshift-pipelines-operator-rh
#oc get packagemanifest -o jsonpath='{range .status.channels[*]}{.name}{"\n"}{end}{"\n"}' -n openshift-marketplace openshift-pipelines-operator-rh
#oc get packagemanifest -o jsonpath='{range .status.channels[*]}{.name}{"\n"}{end}{"\n"}' -n openshift-marketplace openshift-pipelines-operator-rh

oc apply -f - <<EOF
apiVersion: operators.coreos.com/v1alpha1
kind: Subscription
metadata:
  name: openshift-pipelines-operator
  namespace: openshift-operators
spec:
  channel: preview
  name: openshift-pipelines-operator-rh
  source: redhat-operators
  sourceNamespace: openshift-marketplace
EOF

echo "this channel was configured in April 2021, update when things unfold."