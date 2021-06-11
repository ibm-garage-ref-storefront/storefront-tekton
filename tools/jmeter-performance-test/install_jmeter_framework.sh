oc project tools

oc get packagemanifests -n openshift-marketplace | grep grafana

oc apply -f operator-group.yaml

# Install Grafana
oc apply -f - <<EOF
apiVersion: operators.coreos.com/v1alpha1
kind: Subscription
metadata:
  name: openshift-grafana-operator
  namespace: tools
spec:
  channel: alpha
  name: grafana-operator
  source: community-operators
  sourceNamespace: openshift-marketplace
EOF

#-------------------------------------------------------------------------
# Wait until the Graphana Operator is running
POD=$(oc get po | grep grafana-operator | awk '{print $3}')
echo ${POD}

until [ "${POD}" = "Running" ]
do
  echo "checking"
  POD=$(oc get po | grep grafana-operator | awk '{print $3}')
  echo "Grafana Operator state: " ${POD}
  sleep 5
done
echo "done"

#-------------------------------------------------------------------------
# Install influxdb
oc apply -f influxdb/influxdb-data.yaml 
oc apply -f influxdb/influxdb-secrets.yaml 
oc apply -f influxdb/influxdb-config.yaml 
oc apply -f influxdb/influxdb-deployment.yaml 
oc apply -f influxdb/influxdb-service.yaml 

POD=$(oc get po | grep influxdb-deployment | awk '{print $3}')
echo ${POD}

until [ "${POD}" = "Running" ]
do
  echo "checking"
  POD=$(oc get po | grep influxdb-deployment | awk '{print $3}')
  echo "InfluxDB state: " ${POD}
  sleep 5
done
echo "done"

sleep 5

# TODO: add checks on the presence of required objects before proceeding 
oc apply -f grafana.yaml

#echo "sleep for 10 seconds"
#sleep 10
oc apply -f grafana_ds.yaml

#echo "sleep for 10 seconds"
#sleep 10
oc apply -f jmeter_dashboard.yaml

#echo "sleep for 10 seconds"
#sleep 10
oc expose svc grafana-operator-metrics