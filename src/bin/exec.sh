#!/bin/bash

# base script with setup for individual links to this script

. playbooks-env.sh

if [ "$?" -ne 0 ]; then
    echo "Loading environment failed, stopping"
    exit 1
fi

if [ "$#" -lt 1 ]; then
    show_usage exit 1
fi

if [[ "$CURRENT_SCRIPT" == "start.sh" ]]; then
  SCRIPT_SUPPORT="all common db tls console manager monitor zookeeper hadoop spark hive impala hue livy krb-kdc ranger solr superset"
  PB_PREFIX="start"
  DEPLOY_MODE=$DEPLOY_MODE_COMP
elif [[ "$CURRENT_SCRIPT" == "stop.sh" ]]; then
  SCRIPT_SUPPORT="all common db tls console manager monitor zookeeper hadoop spark hive impala hue livy krb-kdc ranger solr superset"
  PB_PREFIX="stop"
  DEPLOY_MODE=$DEPLOY_MODE_COMP
elif [[ "$CURRENT_SCRIPT" == "deploy.sh" ]]; then
  SCRIPT_SUPPORT="all common db tls console manager monitor zookeeper hadoop spark hive impala hue livy krb-kdc krb-keytab krb-principal ranger solr client-config host-gateway superset"
  PB_PREFIX="deploy"
  DEPLOY_MODE=$DEPLOY_MODE_COMP
elif [[ "$CURRENT_SCRIPT" == "deploy-config.sh" ]]; then
  SCRIPT_SUPPORT="all common db tls console manager monitor zookeeper hadoop spark hive impala hue livy krb-kdc ranger solr superset"
  PB_PREFIX="deploy"
  DEPLOY_MODE=$DEPLOY_MODE_CFG_ONLY
fi

run_playbooks "$@"