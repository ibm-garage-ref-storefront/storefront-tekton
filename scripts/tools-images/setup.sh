source ~/config

oc new-project tools-images

oc import-image kabanero-java-spring-boot2:0.3 \
--from=docker.io/kabanero/java-spring-boot2:0.3 \
--confirm

oc import-image appsody-buildah:0.6.5-buildah1.9.0 \
--from=appsody/appsody-buildah:0.6.5-buildah1.9.0 \
--confirm

oc get is