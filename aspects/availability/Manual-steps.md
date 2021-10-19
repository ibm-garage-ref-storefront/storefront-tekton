# Prevail Availability Test

Clone this repo.

cd prevail_availability

## Create project istio-system
oc new-project istio-system</br>
![image](https://user-images.githubusercontent.com/45451838/128295909-b2ea9da1-c76e-4dff-8311-7513c3e48449.png)

## Openshift operators installation
Red Hat Elasticsearch</br>
Openshift jaeger </br>
Kiali </br>
Openshift Service Mesh</br>
![image](https://user-images.githubusercontent.com/45451838/128295863-8273b748-104b-4147-9038-a05f1a10bef5.png)


## Configure Openshift Service Mesh Control Plane to create a sidecar system which will track the cluster microservices
![image](https://user-images.githubusercontent.com/45451838/128295785-4a926166-6463-483b-b18b-5098c8324379.png)

## Configure Openshift Service Mesh Member Rolls by using below yaml (in this example appname will be bookinfo)
![image](https://user-images.githubusercontent.com/45451838/128295772-e398d785-4c0f-400c-8fb7-4e7e0fcb5561.png)
```
apiVersion: maistra.io/v1
kind: ServiceMeshMemberRoll
metadata:
  name: default
  namespace: istio-system
spec:
  members:
    - bookinfo
```


## bookinfo namespace and application deployment
oc new-project bookinfo </br>
oc apply -f https://raw.githubusercontent.com/Maistra/istio/maistra-2.0/samples/bookinfo/platform/kube/bookinfo.yaml </br>
oc get pods </br>
oc get routes -n istio-system istio-ingressgateway </br>

## exporting the hostname
export INGRESS_HOST= output from last command </br>
![image](https://user-images.githubusercontent.com/45451838/128295680-10b786d8-ec59-4a7f-9691-047f6d4b4d85.png)

![image](https://user-images.githubusercontent.com/45451838/128295673-f6f0075f-cb2a-4ea4-b7b6-45d708906ce0.png)
oc create -f https://raw.githubusercontent.com/Maistra/istio/maistra-2.0/samples/bookinfo/networking/bookinfo-gateway.yaml </br>

## fake traffic generation
for i in {1..20}; do sleep 0.5; curl -I $INGRESS_HOST/productpage; done</br>

## install chaostoolkit
python3 -m venv ~/.venvs/chaostk</br>
source ~/.venvs/chaostk/bin/activate</br>
pip install -U chaostoolkit</br>
chaos --help</br>

## install chaos toolkit kubernetes extension </br>

pip install -U chaostoolkit-kubernetes</br>
chaos discover chaostoolkit-kubernetes</br>

## start killing application pods experiments </br>
chaos run chaos/terminate-pod.yaml</br>
![image](https://user-images.githubusercontent.com/45451838/128295569-4924fbf3-a468-4f82-8644-89e74576a411.png)

## Check the applications product page
http://{INGRESS_HOST}/productpage </br>

## Now check kiali, grafana, jaeger dashboards to analyse availability/ resiliency of the full system
![image](https://user-images.githubusercontent.com/45451838/128295542-00ae1107-c424-4e1e-be91-a06032a784a2.png)

![image](https://user-images.githubusercontent.com/45451838/128295522-46591c5c-3a7e-4131-a970-100a6ee9472c.png)
![image](https://user-images.githubusercontent.com/45451838/128300134-581cc5af-cea3-45c5-ab94-4649d9fde915.png)
![image](https://user-images.githubusercontent.com/45451838/128300198-ac581406-cced-4d25-a46c-5b515659a3cf.png)

