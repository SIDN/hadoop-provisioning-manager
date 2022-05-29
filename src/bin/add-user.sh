#!/bin/bash

PB_ADD_USER=add-user.yml

# type can be: user or system
# normal: create accounts on servers and gateway
# system: only create accounts on server

. playbooks-env.sh

if [ "$?" -ne 0 ]; then
    echo "Loading environment failed, stopping"
    exit 1
fi

if [ "$#" -ne 2 ]; then
    echo "Usage: add-user.sh username [normal|system]"
    exit 1
fi

# read password for new provision_user to create
echo -n "Enter password for $1: "; stty -echo; IFS= read -r new_user_passwd; stty echo

if [ -f "$PY_EXEC" ]; then
  . $PY_EXEC 
fi

ansible-playbook -i $SIDN_HADOOP_CFG_DIR/$HOSTS_FILE $PRJ_ROOT_DIR/playbooks/$PB_ADD_USER \
    --extra-vars="create_type=$2 create_user=$1 create_password=$new_user_passwd ansible_become_password={{ lookup('env', 'ANSIBLE_BECOME_PASSWORD') }} prov_cfg_dir={{ lookup('env', 'SIDN_HADOOP_CFG_DIR') }}"
