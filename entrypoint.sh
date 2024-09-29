#!/bin/bash
export CONNECTOR_PORT=${1:-8080}
export SHUTDOWN_PORT=$(( ${CONNECTOR_PORT} + 1 ))
export CONNECTOR=${CONNECTOR:-http}
echo -e "CONNECTOR_PORT:\t${CONNECTOR_PORT}\nSHUTDOWN_PORT:\t${SHUTDOWN_PORT}\n"
# ln -sfr /home/tomcat/apache-tomcat/myconf/server.${CONNECTOR}.xml /home/tomcat/apache-tomcat/myconf/server.connector.xml
# xmlstarlet -e /home/tomcat/apache-tomcat/conf/server.connector.xml
java -version
(${CATALINA_HOME}/bin/catalina.sh $*)&
PID=$!
echo "waiting for PID to finish: $PID"
wait ${PID}
