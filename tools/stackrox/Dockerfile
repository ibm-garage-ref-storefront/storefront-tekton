FROM registry.access.redhat.com/ubi8/ubi:latest

MAINTAINER kitty-catt kitty-catt@example.com

ARG USER=stackrox
ARG UID=1001
ARG GID=1001
ARG ROX_VER=3.0.61.0

RUN groupadd -r stackrox -f -g ${GID} && \
    useradd -u ${UID} -r -g ${GID} \
    -m -d /home/${USER} ${USER} 

WORKDIR /home/${USER}

RUN mkdir -pv  /home/${USER}/bin &&  \
    curl https://mirror.openshift.com/pub/rhacs/assets/${ROX_VER}/bin/Linux/roxctl \
    -o /home/${USER}/bin/roxctl  

RUN chown -R ${USER}:0  /home/${USER} && \
    chmod -R g=u /home/${USER} && \
    chmod +x /home/${USER}/bin/roxctl 

# Note: ubi-minimal does not have yum
RUN yum update && \
    yum clean all -y

USER ${UID}