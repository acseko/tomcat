#!/bin/bash
export CATALINA_PID=${CATALINA_HOME}/logs/catalina.pid
catalina.sh $*
PID=$(cat ${CATALINA_PID})

echo "Waiting for PID to exit: ${PID}"
tail --pid=${PID} -f /dev/null
