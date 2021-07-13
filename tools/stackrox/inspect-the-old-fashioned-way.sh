PROJECTS=$(oc get projects -o custom-columns=NAME:.metadata.name)

rm result.txt
for PROJECT in ${PROJECTS}
do
  oc project ${PROJECT}
  PODS=$(oc get po -o custom-columns=NAME:.metadata.name)
  for POD in ${PODS}
  do 
      oc exec -it ${POD} id > kijk.txt
      echo "project  ${PROJECT} - pod: ${POD}" >> result.txt
      grep uid kijk.txt >> result.txt
  done
done