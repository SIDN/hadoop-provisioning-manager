#!/bin/bash

PB_ADD_PY_ENV=add-py-env.yml

. playbooks-env.sh

if [ "$?" -ne 0 ]; then
    echo "Loading environment failed, stopping"
    exit 1
fi

if [ "$#" -ne 3 ]; then
    echo "Usage: add-py-env.sh name py-version path/to/requirements.txt"
    exit 1
fi

if [ -f "$PY_EXEC" ]; then
  . $PY_EXEC 
fi

ansible-playbook -i $SIDN_HADOOP_CFG_DIR/$HOSTS_FILE $PRJ_ROOT_DIR/playbooks/$PB_ADD_PY_ENV \
    --extra-vars="py_env_name=$1 py_version=$2 py_env_req_file=$3 ansible_become_password={{ lookup('env', 'ANSIBLE_BECOME_PASSWORD') }} prov_cfg_dir={{ lookup('env', 'SIDN_HADOOP_CFG_DIR') }}" \
    $LIMIT_HOSTS
