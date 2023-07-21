#!/bin/bash

# set LIMIT_HOSTS with 

PB_PREPARE_HOST=prepare-hosts.yml

. playbooks-env.sh

if [ "$?" -ne 0 ]; then
    echo "Loading environment failed, stopping"
    exit 1
fi

if [ "$#" -ne 1 ]; then
    echo "Usage: prepare-hosts.sh remote-admin-user"
    exit 1
fi
    
# read password for new provision_user to create
echo -n "Enter password (ANSIBLE_BECOME_PASSWORD) for provision user that is going to be created: "; stty -echo; IFS= read -r prov_user_passwd; stty echo

if [ -f "$PY_EXEC" ]; then
  . $PY_EXEC 
fi

ansible-playbook --user $1 --ask-pass --ask-become-pass -i $SIDN_HADOOP_CFG_DIR/$HOSTS_FILE $PRJ_ROOT_DIR/playbooks/$PB_PREPARE_HOST \
    --extra-vars="provision_user_passwd=$prov_user_passwd ansible_python_interpreter=python3 prov_cfg_dir={{ lookup('env', 'SIDN_HADOOP_CFG_DIR') }}" \
    $LIMIT_HOSTS
