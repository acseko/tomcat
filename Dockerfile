FROM redhat/ubi9:latest

LABEL org.opencontainers.image.title=MyTomcatDemo
LABEL org.opencontainers.image.description="Nothing to prod, only demo"
LABEL org.opencontainers.image.vendor=acseko
  
ARG TOMCAT_MAJOR_VERSION=10.1
ARG OPENJDK_MAJOR_VERSION=17
ARG MAVEN_METADATA="https://repo1.maven.org/maven2/org/apache/tomcat/tomcat/maven-metadata.xml"

RUN dnf install https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm -y && \
  dnf update -y --disableplugin=subscription-manager && \
  dnf upgrade -y --disableplugin=subscription-manager && \
  dnf install -y --disableplugin=subscription-manager java-${OPENJDK_MAJOR_VERSION}-openjdk-headless sed xmlstarlet jq lsof tini procps && \
  rm -rf /usr/lib/python*/site-packages/* usr/lib64/python*/site-packages/*

RUN mkdir -p /home/tomcat
WORKDIR /home/tomcat
RUN export TOMCAT_VERSION=$(curl "${MAVEN_METADATA}" 2>/dev/null | xmlstarlet sel -t -m \
    '//metadata/versioning/versions/version[starts-with(., "'${TOMCAT_MAJOR_VERSION}'.")]' -v . -n |sort -Vr |head -1) && \
  echo "Tomcat version: ${TOMCAT_VERSION}" && \
  curl -X GET "https://repo1.maven.org/maven2/org/apache/tomcat/tomcat/${TOMCAT_VERSION}/tomcat-${TOMCAT_VERSION}.tar.gz" -O -q && \
  ls -l && \
  tar -xvzf "tomcat-${TOMCAT_VERSION}.tar.gz" && \
  ln -s apache-tomcat-${TOMCAT_VERSION} apache-tomcat && \
  sed -i -e 's|<Listener className="org.apache.catalina.core.AprLifecycleListener" />|<!-- <Listener className="org.apache.catalina.core.AprLifecycleListener" /> -->|g' \
    /home/tomcat/apache-tomcat/conf/server.xml && \
  echo "org.apache.tomcat.util.digester.REPLACE_SYSTEM_PROPERTIES=true" >> /home/tomcat/apache-tomcat/conf/catalina.properties && \
  echo "org.apache.tomcat.util.digester.PROPERTY_SOURCE=org.apache.tomcat.util.digester.EnvironmentPropertySource" >> /home/tomcat/apache-tomcat/conf/catalina.properties && \
  if [ "9" = "$(echo -e "9\n${TOMCAT_VERSION}" |sort -V |head -n1)" ]; then xmlstarlet ed -P -S -L -s /Server/Service/Engine/Host -t elem -n HCValve -v "" \
    -i //HCValve -t attr -n "className" -v "org.apache.catalina.valves.HealthCheckValve" -r //HCValve -v Valve \
    /home/tomcat/apache-tomcat/conf/server.xml; else echo "Tomcat ${TOMCAT_VERSION} does not support HealthCheck Valve"; fi;

ENV CATALINA_HOME=/home/tomcat/apache-tomcat
ENV PATH=${PATH}:${CATALINA_HOME}/bin

ADD entrypoint.sh /home/tomcat/entrypoint.sh
ENTRYPOINT ["/home/tomcat/entrypoint.sh"]
