#!/bin/bash

PB_DEL_USER=del-user.yml

# type can be: user or system
# user: create accounts on servers and gateway
# system: only create accounts on server

. playbooks-env.sh

if [ "$?" -ne 0 ]; then
    echo "Loading environment failed, stopping"
    exit 1
fi

if [ "$#" -ne 1 ]; then
    echo "Usage: del-user.sh username"
    exit 1
fi

if [ -f "$PY_EXEC" ]; then
  . $PY_EXEC 
fi

if [ -n "$LIMIT_HOSTS" ]; then
    LIMIT_HOSTS="--limit $LIMIT_HOSTS"
fi

echo "Limit hosts: $LIMIT_HOSTS"

ansible-playbook -i $SIDN_HADOOP_CFG_DIR/$HOSTS_FILE $PRJ_ROOT_DIR/playbooks/$PB_DEL_USER \
    --vault-password-file $SIDN_HADOOP_CFG_DIR/$VAULT_PASSWD_FILE \
    --extra-vars="del_user=$1 ansible_become_password={{ lookup('env', 'ANSIBLE_BECOME_PASSWORD') }} prov_cfg_dir={{ lookup('env', 'SIDN_HADOOP_CFG_DIR') }}" \
    $LIMIT_HOSTS
