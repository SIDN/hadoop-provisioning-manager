#!/bin/bash

PB_DEL_PY_ENV=del-py-env.yml

. playbooks-env.sh

if [ "$?" -ne 0 ]; then
    echo "Loading environment failed, stopping"
    exit 1
fi

if [ "$#" -ne 1 ]; then
    echo "Usage: del-py-env.sh name"
    exit 1
fi

if [ -f "$PY_EXEC" ]; then
  . $PY_EXEC 
fi

if [ -n "$LIMIT_HOSTS" ]; then
    LIMIT_HOSTS="--limit $LIMIT_HOSTS"
fi

echo "Limit hosts: $LIMIT_HOSTS"

ansible-playbook -i $SIDN_HADOOP_CFG_DIR/$HOSTS_FILE $PRJ_ROOT_DIR/playbooks/$PB_DEL_PY_ENV \
    --extra-vars="py_env_name=$1 ansible_become_password={{ lookup('env', 'ANSIBLE_BECOME_PASSWORD') }} prov_cfg_dir={{ lookup('env', 'SIDN_HADOOP_CFG_DIR') }}" \
    $LIMIT_HOSTS
