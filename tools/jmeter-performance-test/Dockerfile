FROM registry.access.redhat.com/ubi8/ubi:latest

MAINTAINER kitty-catt kitty-catt@example.com

ENV JMETER_BASE=/opt/jmeter \
    JMETER_VERSION="5.4.1" \
    PATH=/opt/jmeter/apache-jmeter/bin:$PATH

# ARG can be used in variable substition for COPY 
ARG JMETER_HOME=/opt/jmeter/apache-jmeter

# Note: ubi-minimal does not have yum
RUN yum install -y --disableplugin=subscription-manager java-1.8.0-openjdk-headless && \
    yum clean all --disableplugin=subscription-manager -y && \
    yum update && \
    yum clean all -y && \
    mkdir -p $JMETER_BASE/{tests,results}

WORKDIR $JMETER_BASE

# Download jmeter into the WORKDIR, Resources from remote URLs are not decompressed.
# Note: a save approach here is COPY or ADD with cksum check.
ADD https://archive.apache.org/dist/jmeter/binaries/apache-jmeter-${JMETER_VERSION}.tgz .

RUN tar xvf apache-jmeter-${JMETER_VERSION}.tgz && \
  ln -sf apache-jmeter-${JMETER_VERSION} apache-jmeter

VOLUME ["/opt/jmeter/tests", "/opt/jmeter/results"]

# Additional jars (for example jdbc or jms drivers) can be copied into $JMETER_HOME/lib
COPY lib/* $JMETER_HOME/lib/

# Copy custom user.properties file for reports dashboard to be generated
# COPY user.properties $JMETER_HOME/bin/user.properties

RUN chown -R 1001:0 $JMETER_BASE && \
    chgrp -R 0 $JMETER_BASE && \
    chmod -R g=u $JMETER_BASE

USER 1001

# This will be executed in the Tekton step.
#$JMETER_HOME/bin/jmeter.sh -n -t $WORKSPACE/bin/target.jmx -l $WORKSPACE/bin/report.jtl
# which defaults to /opt/jmeter/apache-jmeter/bin

CMD ["sleep", "30"]