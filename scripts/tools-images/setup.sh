source ~/config

oc new-project tools-images

#oc import-image kabanero-java-spring-boot2:0.3 \
#--from=docker.io/kabanero/java-spring-boot2:0.3 \
#--reference-policy='local' \
#--confirm

#oc import-image appsody-buildah:0.6.5-buildah1.9.0 \
#--from=appsody/appsody-buildah:0.6.5-buildah1.9.0 \
#--reference-policy='local' \
#--confirm

oc import-image openjdk18-openshift:1.8 \
--from=registry.access.redhat.com/redhat-openjdk-18/openjdk18-openshift:1.8 \
--reference-policy='local' \
--confirm

oc import-image ubi:8.0 \
--from=registry.access.redhat.com/ubi8/ubi:8.0 \
--reference-policy='local' \
--confirm

oc get is

oc policy add-role-to-group system:image-puller system:serviceaccounts:pipelines