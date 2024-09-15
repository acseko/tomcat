FROM redhat/ubi8:latest

LABEL org.opencontainers.image.title MyTomcatDemo
LABEL org.opencontainers.image.description "Nothing to prod, only demo"
LABEL org.opencontainers.image.vendor acseko
  
MAINTAINER "András Csekő<andras.cseko@gmail.com>"

ARG TOMCAT_MAJOR_VERSION=10.1
ARG OPENJDK_MAJOR_VERSION=17
ARG MAVEN_METADATA="https://repo1.maven.org/maven2/org/apache/tomcat/tomcat/maven-metadata.xml"

RUN dnf update -y --disableplugin=subscription-manager && \
  dnf upgrade -y --disableplugin=subscription-manager

RUN  dnf install -y --disableplugin=subscription-manager java-${OPENJDK_MAJOR_VERSION}-openjdk sed xmlstarlet jq

RUN mkdir -p /home/tomcat
WORKDIR /home/tomcat
RUN export TOMCAT_VERSION=$(curl "${MAVEN_METADATA}" 2>/dev/null | xmlstarlet sel -t -m \
    '//version[starts-with(., "'${TOMCAT_MAJOR_VERSION}'.")]' -v . -n |sort -Vr |head -1) && \
  echo "Tomcat version: ${TOMCAT_VERSION}" && \
  curl -X GET "https://repo1.maven.org/maven2/org/apache/tomcat/tomcat/${TOMCAT_VERSION}/tomcat-${TOMCAT_VERSION}.tar.gz" -O -q && \
  ls -l && \
  tar -xvzf "tomcat-${TOMCAT_VERSION}.tar.gz" && \
  ln -s apache-tomcat-${TOMCAT_VERSION} apache-tomcat && \
  sed -i -e 's|<Listener className="org.apache.catalina.core.AprLifecycleListener" />|' \
            '<!-- <Listener className="org.apache.catalina.core.AprLifecycleListener" /> -->|g' \
  /home/tomcat/apache-tomcat/conf/server.xml

ENV CATALINA_HOME=/home/tomcat/apache-tomcat
ENV PATH=${PATH}:${CATALINA_HOME}/bin

ADD entrypoint.sh /home/tomcat/entrypoint.sh
ENTRYPOINT ["/home/tomcat/entrypoint.sh"]
CMD ["version"]
