#!/usr/bin/bash

export CATALINA_PID=${CATALINA_HOME}/logs/catalina.pid
echo "Tomcat version information"
catalina.sh version
echo "Starting Tomcat"
catalina.sh start >${CATALINA_HOME}/logs/catalina.out 2>${CATALINA_HOME}/logs/catalina.err
echo "Tomcat started."
echo "Waiting for PID to exit: ${CATALINA_PID}"
tail --pid=$(cat ${CATALINA_PID}) -f /dev/null
