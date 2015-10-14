FROM chnoumis/base-sti

MAINTAINER chnoumis

EXPOSE 8181 8101 8778

ENV KARAF_VERSION 3.0.2
ENV DEPLOY_DIR /opt/chnoumis/deploy

USER root
# Install fonts
RUN \
  echo "deb http://http.debian.net/debian jessie contrib" >> /etc/apt/sources.list && \
  apt-get update && \
  echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | debconf-set-selections && \
  apt-get install -y ttf-mscorefonts-installer

USER chnoumis

RUN wget http://archive.apache.org/dist/karaf/${KARAF_VERSION}/apache-karaf-${KARAF_VERSION}.tar.gz -O /tmp/karaf.tar.gz

# Unpack
RUN tar xzf /tmp/karaf.tar.gz -C /opt/chnoumis
RUN ln -s /opt/chnoumis/apache-karaf-${KARAF_VERSION} /opt/chnoumis/karaf
RUN rm /tmp/karaf.tar.gz

# Add configurtion templates
# ADD users.properties /opt/chnoumis/apache-karaf-${KARAF_VERSION}/etc/
ADD karaf /opt/chnoumis/apache-karaf-${KARAF_VERSION}/build

# Startup and usage script
ADD ./usage /usr/bin/
ADD ./deploy-and-start /usr/bin/

# jolokia agent
RUN wget http://central.maven.org/maven2/org/jolokia/jolokia-jvm/1.3.1/jolokia-jvm-1.3.1-agent.jar -O /opt/chnoumis/karaf/jolokia-agent.jar

# Remove unneeded apps
RUN rm -rf /opt/chnoumis/karaf/deploy/README 

ENV KARAF_HOME /opt/chnoumis/karaf
ENV PATH $PATH:$KARAF_HOME/bin

USER root

CMD ["/usr/bin/sti-helper"]
