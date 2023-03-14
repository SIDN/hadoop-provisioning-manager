#!/bin/bash

# names of playbooks
export PB_COMMON=common.yml
export PB_DATABASE=db.yml
export PB_MANAGER=manager.yml
export PB_KRB_KDC=krb-kdc.yml
export PB_CONSOLE=console.yml
export PB_ZOOKEEPER=zookeeper.yml
export PB_HDFS=hdfs.yml
export PB_YARN=yarn.yml
export PB_SPARK=spark.yml
export PB_SOLR=solr.yml
export PB_RANGER=ranger.yml
export PB_HIVE=hive.yml
export PB_IMPALA=impala.yml
export PB_IMPALA_SHELL=impala-shell.yml
export PB_IMPALA_PROXY=impala-proxy.yml
export PB_HUE=hue.yml
export PB_SUPERSET=superset.yml
export PB_JUPYTERHUB=jupyterhub.yml
export PB_LIVY=livy.yml
export PB_ALL=all.yml
export PB_MONITOR=monitor.yml
export PB_MONITOR_PROXY=monitor-proxy.yml
export PB_CLIENT_CONFIG=client-config.yml
export PB_HOST_GATEWAY=host-gateway.yml
export PB_KRB_PRIN=krb-principal.yml
export PB_KRB_KT=krb-keytab.yml
export PB_TLS=tls.yml
export PB_TLS_APP=tls-app.yml
export PB_TLS_BASE=tls-base.yml

# general commands
export PB_DO_ENALBLE_HDFS_RANGER_PLUGIN=enable-hdfs-ranger-plugin.yml

# general cfg vars
export HOSTS_FILE="hosts"
export VAULT_PASSWD_FILE=".vault_pass"
export EXTRA_ARGS=""
export PY_EXEC="~/activate-python"
export SCRIPT_DIR=$( cd "$(dirname "$0")" ; pwd -P )
export PRJ_ROOT_DIR="$SCRIPT_DIR/.."

# mode determines what playbooks do, deploy comp + cfg or cfg only
export DEPLOY_MODE_COMP="var_deploy_comp=true var_deploy_cfg_only=false"
export DEPLOY_MODE_CFG_ONLY="var_deploy_cfg_only=true var_deploy_comp=false"

CURRENT_SCRIPT=$(basename "$0")
ENV_FILE=set-env.sh

if test -f "$SCRIPT_DIR/$ENV_FILE"; then
    echo "Using environment file: $SCRIPT_DIR/$ENV_FILE"
    . $SCRIPT_DIR/$ENV_FILE
fi

# following vars maybe loaded by $ENV_FILE script
export ANSIBLE_CONFIG=$SIDN_HADOOP_CFG_DIR
export ANSIBLE_ROLES_PATH="$PRJ_ROOT_DIR/roles:$ANSIBLE_ROLES_PATH"

if [[ -z "$SIDN_HADOOP_CFG_DIR" ]]; then
 echo "ERROR: Environment variable SIDN_HADOOP_CFG_DIR is not set."
 exit 1
fi

if [[ -z "$ANSIBLE_BECOME_PASSWORD" ]]; then
 echo "ERROR: Environment variable ANSIBLE_BECOME_PASSWORD is not set."
 exit 1
fi

function show_usage()
{
  echo "Usage: $CURRENT_SCRIPT [service]+\n"
  echo "Supported services: $SCRIPT_SUPPORT"
}


function run_playbook()
{
  echo "--------------------------------------"
  echo "Execute playbook: $1"
  echo "--------------------------------------"
  echo "Using variables in dir: $SIDN_HADOOP_CFG_DIR"
  echo "Using hosts file: $SIDN_HADOOP_CFG_DIR/$HOSTS_FILE"
  echo "--------------------------------------"

  if [ -f "$PY_EXEC" ]; then
    . $PY_EXEC 
  fi
  
  echo "roles path: $DEFAULT_ROLES_PATH"
  
  ansible-playbook -i $SIDN_HADOOP_CFG_DIR/$HOSTS_FILE $PRJ_ROOT_DIR/playbooks/$1 \
      --vault-password-file $SIDN_HADOOP_CFG_DIR/$VAULT_PASSWD_FILE \
      --extra-vars="ansible_become_password={{ lookup('env', 'ANSIBLE_BECOME_PASSWORD') }} prov_cfg_dir={{ lookup('env', 'SIDN_HADOOP_CFG_DIR') }} $DEPLOY_MODE" \
       $EXTRA_ARGS
}

function run_playbooks()
{
  for var in "$@"
  do
      case "$var" in
        all)
          run_playbook "$PB_PREFIX-$PB_ALL"
        ;;
        common)
          run_playbook "$PB_PREFIX-$PB_COMMON"
        ;;
        db)
          run_playbook "$PB_PREFIX-$PB_DATABASE"
        ;;
        tls)
          run_playbook "$PB_PREFIX-$PB_TLS"
        ;;
        tls-app)
          run_playbook "$PB_PREFIX-$PB_TLS_APP"
        ;;
        tls-base)
          run_playbook "$PB_PREFIX-$PB_TLS_BASE"
        ;;
        console)
          run_playbook "$PB_PREFIX-$PB_$PB_CONSOLE"
        ;;
        manager)
          run_playbook "$PB_PREFIX-$PB_MANAGER"
        ;;
        monitor)
          run_playbook "$PB_PREFIX-$PB_MONITOR"
        ;;
        monitor-proxy)
          run_playbook "$PB_PREFIX-$PB_MONITOR_PROXY"
        ;;
        zookeeper)
          run_playbook "$PB_PREFIX-$PB_ZOOKEEPER"
        ;;
        hdfs)
          run_playbook "$PB_PREFIX-$PB_HDFS"
        ;;
        yarn)
          run_playbook "$PB_PREFIX-$PB_YARN"
        ;;
        spark)
          run_playbook "$PB_PREFIX-$PB_SPARK"
        ;;
        hive)
          run_playbook "$PB_PREFIX-$PB_HIVE"
        ;;
        impala)
          run_playbook "$PB_PREFIX-$PB_IMPALA"
        ;;
        impala-shell)
          run_playbook "$PB_PREFIX-$PB_IMPALA_SHELL"
        ;;
        impala-proxy)
          run_playbook "$PB_PREFIX-$PB_IMPALA_PROXY"
        ;;
        hue)
          run_playbook "$PB_PREFIX-$PB_HUE"
        ;;
        superset)
          run_playbook "$PB_PREFIX-$PB_SUPERSET"
        ;;
        jupyterhub)
          run_playbook "$PB_PREFIX-$PB_JUPYTERHUB"
        ;;
        livy)
          run_playbook "$PB_PREFIX-$PB_LIVY"
        ;;
        krb-kdc)
          run_playbook "$PB_PREFIX-$PB_KRB_KDC"
        ;;
        krb-principal)
          run_playbook "$PB_PREFIX-$PB_KRB_PRIN"
        ;;
        krb-keytab)
          run_playbook "$PB_PREFIX-$PB_KRB_KT"
        ;;
        ranger)
          run_playbook "$PB_PREFIX-$PB_RANGER"
        ;;
        solr)
          run_playbook "$PB_PREFIX-$PB_SOLR"
        ;;
        client-config)
          run_playbook "$PB_PREFIX-$PB_CLIENT_CONFIG"
        ;;
        enable-hdfs-ranger-plugin)
          run_playbook "$PB_PREFIX-$PB_DO_ENALBLE_HDFS_RANGER_PLUGIN"
        ;;
        host-gateway)
          # only deploy components on the gateway nodes
          EXTRA_ARGS="--limit gateway"
          run_playbook "$PB_PREFIX-$PB_HOST_GATEWAY"
        ;;
        *)
          show_usage exit 1
        ;;
      esac
  done
}


export -f show_usage
export -f run_playbook
export -f run_playbooks
