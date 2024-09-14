#!/bin/bash

if [ $# -gt 1 ]
then
  echo "Update base port number to : $1"
  shift
fi;
${CATALINA_HOME}/bin/catalina.sh $*
