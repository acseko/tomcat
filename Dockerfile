FROM redhat/ubi8:latest

ARG TOMCAT_VERSION=10.1.28
ARG OPENJDK_MAJOR_VERSION=11

RUN dnf install -y --disableplugin=subscription-manager java-${OPENJDK_MAJOR_VERSION}-openjdk
RUN mkdir -p /home/tomcat
WORKDIR /home/tomcat
RUN curl -X GET "https://repo1.maven.org/maven2/org/apache/tomcat/tomcat/${TOMCAT_VERSION}/tomcat-${TOMCAT_VERSION}.tar.gz" -O && \
  tar -xvzf "tomcat-${TOMCAT_VERSION}.tar.gz"

ENV CATALINA_HOME=/home/tomcat/apache-tomcat-${TOMCAT_VERSION}
ENV PATH=${PATH}:${CATALINA_HOME}/bin
ENTRYPOINT ["catalina.sh"]
CMD "run"
