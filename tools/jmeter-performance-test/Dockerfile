FROM registry.access.redhat.com/ubi8/ubi:8.0
MAINTAINER kitty-catt kitty-catt@example.com
LABEL jmeter.version="5.4.1"

# Set JMeter base
ENV JMETER_BASE /opt/jmeter

# Install the Java runtime, create a user for running the app, and set permissions
RUN   yum install -y --disableplugin=subscription-manager java-1.8.0-openjdk-headless && \
      yum clean all --disableplugin=subscription-manager -y 

# Make a user.
RUN groupadd -r jmeter -f -g 1001 && \
    useradd -u 1001 -r -g jmeter -m -d /opt/jmeter -s /usr/sbin/nologin -c "jmeter container user" jmeter

# Create jmeter directory with tests and results folder and install JMeter
RUN mkdir -p $JMETER_BASE/{tests,results} && \
    curl -SL https://archive.apache.org/dist/jmeter/binaries/apache-jmeter-5.4.1.tgz | tar -xzC $JMETER_BASE && \
    rm -rf apache-jmeter-5.4.1.tgz

VOLUME ["/opt/jmeter/tests", "/opt/jmeter/results"]

# Set JMeter home
ENV JMETER_HOME $JMETER_BASE/apache-jmeter-5.4.1

# Add JMeter to the Path
ENV PATH $JMETER_HOME/bin:$PATH

# Additional jars (for example jdbc or jms drivers) can be copied into $JMETER_HOME/lib
#COPY lib/* $JMETER_HOME/lib/

# Copy custom user.properties file for reports dashboard to be generated
# COPY user.properties $JMETER_HOME/bin/user.properties

# Set working directory
WORKDIR $JMETER_BASE

#COPY scripts/run.sh $JMETER_BASE/run.sh

RUN chmod +x -R $JMETER_HOME

RUN chown -R 1001:0 $JMETER_BASE && \
    chgrp -R 0 $JMETER_BASE && \
    chmod -R g=u $JMETER_BASE

#RUN yum install -y sleep

#1001 is the container user
USER 1001

# This will be executed in the Tekton step.
#$JMETER_HOME/bin/jmeter.sh -n -t $WORKSPACE/bin/target.jmx -l $WORKSPACE/bin/report.jtl
# which defaults to /opt/jmeter/apache-jmeter-5.4.1/bin

#ENTRYPOINT $JMETER_BASE/run.sh
ENTRYPOINT ["sleep", "30"]