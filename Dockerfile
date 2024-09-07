FROM redhat/ubi8:latest

LABEL org.opencontainers.image.title MyTomcatDemo
LABEL org.opencontainers.image.description "Nothing to prod, only demo"
LABEL org.opencontainers.image.vendor acseko
  
MAINTAINER "András Csekő<andras.cseko@gmail.com>"

ARG TOMCAT_VERSION=10.1.28

RUN dnf update -y --disableplugin=subscription-manager && \
  dnf upgrade -y --disableplugin=subscription-manager

ARG OPENJDK_MAJOR_VERSION=11
RUN  dnf install -y --disableplugin=subscription-manager java-${OPENJDK_MAJOR_VERSION}-openjdk sed

RUN mkdir -p /home/tomcat
WORKDIR /home/tomcat
RUN curl -X GET "https://repo1.maven.org/maven2/org/apache/tomcat/tomcat/${TOMCAT_VERSION}/tomcat-${TOMCAT_VERSION}.tar.gz" -O && \
  tar -xvzf "tomcat-${TOMCAT_VERSION}.tar.gz" && \
  sed -i -e 's|<Listener className="org.apache.catalina.core.AprLifecycleListener" />|<!-- <Listener className="org.apache.catalina.core.AprLifecycleListener" /> -->|g' \
  /home/tomcat/apache-tomcat-${TOMCAT_VERSION}/conf/server.xml

ENV CATALINA_HOME=/home/tomcat/apache-tomcat-${TOMCAT_VERSION}
ENV PATH=${PATH}:${CATALINA_HOME}/bin
ENTRYPOINT ["catalina.sh"]
CMD ["version"]
