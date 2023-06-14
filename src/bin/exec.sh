#!/bin/bash

# base script with setup for individual links to this script

. playbooks-env.sh

if [ "$?" -ne 0 ]; then
    echo "Loading environment failed, stopping"
    exit 1
fi

if [[ "$CURRENT_SCRIPT" == "start.sh" ]]; then
  SCRIPT_SUPPORT="all common db tls console manager monitor monitor-proxy zookeeper hdfs yarn spark hive impala impala-shell impala-proxy hue livy krb-kdc ranger solr superset jupyterhub docker-reg-ui airflow minio minio-lb"
  PB_PREFIX="start"
  DEPLOY_MODE=$DEPLOY_MODE_COMP
elif [[ "$CURRENT_SCRIPT" == "stop.sh" ]]; then
  SCRIPT_SUPPORT="all common db tls console manager monitor monitor-proxy zookeeper hdfs yarn spark hive impala impala-shell impala-proxy hue livy krb-kdc ranger solr superset jupyterhub docker-reg-ui airflow minio minio-lb"
  PB_PREFIX="stop"
  DEPLOY_MODE=$DEPLOY_MODE_COMP
elif [[ "$CURRENT_SCRIPT" == "deploy.sh" ]]; then
  SCRIPT_SUPPORT="all common db tls console manager monitor monitor-proxy hadoop spark hive impala impala-shell impala-proxy hue livy krb-kdc krb-keytab krb-principal ranger solr client-config host-gateway superset jupyterhub airflow minio minio-lb"
  PB_PREFIX="deploy"
  DEPLOY_MODE=$DEPLOY_MODE_COMP
elif [[ "$CURRENT_SCRIPT" == "deploy-config.sh" ]]; then
  SCRIPT_SUPPORT="all common console manager monitor monitor-proxy zookeeper hadoop spark hive impala impala-shell impala-proxy hue livy krb-kdc ranger solr superset jupyterhub airflow minio minio-lb"
  PB_PREFIX="deploy"
  DEPLOY_MODE=$DEPLOY_MODE_CFG_ONLY
elif [[ "$CURRENT_SCRIPT" == "do.sh" ]]; then
  SCRIPT_SUPPORT="enable-hdfs-ranger-plugin"
  PB_PREFIX="do"
  DEPLOY_MODE=""
fi

function show_usage()
{
  echo "Usage: $CURRENT_SCRIPT [service]+\n"
  echo "Supported services: $SCRIPT_SUPPORT"
}

if [ "$#" -lt 1 ]; then
    show_usage exit 1
fi

run_playbooks "$@"