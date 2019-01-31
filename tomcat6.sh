#!/bin/bash

# sentenv.sh

if [ -z "${TOMCAT_CFG_LOADED}" ]; then
  if [ -z "${TOMCAT_CFG}" ]; then
    TOMCAT_CFG="/etc/tomcat6/tomcat6.conf"
  fi
  . $TOMCAT_CFG
fi
