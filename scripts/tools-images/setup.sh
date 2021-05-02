source  ~/config.bc-full 

oc new-project tools-images

#oc import-image kabanero-java-spring-boot2:0.3 \
#--from=docker.io/kabanero/java-spring-boot2:0.3 \
#--reference-policy='local' \
#--confirm

#oc import-image appsody-buildah:0.6.5-buildah1.9.0 \
#--from=appsody/appsody-buildah:0.6.5-buildah1.9.0 \
#--reference-policy='local' \
#--confirm

#oc import-image openjdk18-openshift:1.8 \
#--from=registry.access.redhat.com/redhat-openjdk-18/openjdk18-openshift:1.8 \
#--reference-policy='local' \
#--confirm

#oc import-image ubi:8.0 \
#--from=registry.access.redhat.com/ubi8/ubi:8.0 \
#--reference-policy='local' \
#--confirm

#oc get is

#oc policy add-role-to-user system:image-puller system:serviceaccount:pipelines:pipeline -n tools-images
#oc policy add-role-to-user system:image-pusher system:serviceaccount:pipelines:pipeline -n tools-images
oc policy add-role-to-user edit system:serviceaccount:pipelines:pipeline -n tools-images

# I want to give the developer view access on this namespace
oc policy add-role-to-user view ${OCP_USER} -n tools-images