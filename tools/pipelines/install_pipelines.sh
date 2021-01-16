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
  channel: ocp-4.6
  name: openshift-pipelines-operator-rh
  source: redhat-operators
  sourceNamespace: openshift-marketplace
EOF

echo "note: we are living in December 2020 now, please update the channel version as things unfold."