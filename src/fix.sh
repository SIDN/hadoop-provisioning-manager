#!/bin/bash

if [[ -z "$SIDN_HADOOP_CFG_DIR" ]]; then
 echo "ERROR: Environment variable SIDN_HADOOP_CFG_DIR is not set."
 exit 1
fi

if [[ -z "$ANSIBLE_BECOME_PASSWORD" ]]; then
 echo "ERROR: Environment variable ANSIBLE_BECOME_PASSWORD is not set."
 exit 1
fi

PY_EXEC="~/activate-python"
SCRIPT_DIR=$( cd "$(dirname "$0")" ; pwd -P )
ENV_FILE=set-env.sh

if test -f "$SCRIPT_DIR/$ENV_FILE"; then
    echo "Using environment file: $SCRIPT_DIR/$ENV_FILE"
    source $SCRIPT_DIR/$ENV_FILE
fi


echo "Running playbooks in: $SCRIPT_DIR"
echo "Using variables in: $SIDN_HADOOP_CFG_DIR"
echo "Create user: $1"

if [ -f "$PY_EXEC" ]; then
  . $PY_EXEC 
fi

export ANSIBLE_CONFIG=$SIDN_HADOOP_CFG_DIR

ansible-playbook -i $SIDN_HADOOP_CFG_DIR/hosts $SCRIPT_DIR/fix.yml \
    --vault-password-file /home/hadoop-mgr/git/hadoop-provision-sidn/config/.vault_pass \
    --extra-vars="ansible_become_password={{ lookup('env', 'ANSIBLE_BECOME_PASSWORD') }} prov_cfg_dir={{ lookup('env', 'SIDN_HADOOP_CFG_DIR') }}"
