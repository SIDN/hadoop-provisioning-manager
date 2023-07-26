#!/bin/bash

PB_ADD_USER=add-user.yml

# type can be: user or system
# normal: create nonlogin accounts on data nodes and login account on gateway nodes
# system: only create nonlogin account on data nodes

. playbooks-env.sh

if [ "$?" -ne 0 ]; then
    echo "Loading environment failed, stopping"
    exit 1
fi

# read password for new provision_user to create
#echo -n "Enter password for $1: "; stty -echo; IFS= read -r new_user_passwd; stty echo

if [ -f "$PY_EXEC" ]; then
  . $PY_EXEC 
fi


for new_user in "$@"
do
  echo "Create user: $new_user"
  ansible-playbook -i $SIDN_HADOOP_CFG_DIR/$HOSTS_FILE $PRJ_ROOT_DIR/playbooks/$PB_ADD_USER \
      --extra-vars="create_krb_user='no' create_type='system' create_user=$new_user create_password='' ansible_become_password={{ lookup('env', 'ANSIBLE_BECOME_PASSWORD') }} prov_cfg_dir={{ lookup('env', 'SIDN_HADOOP_CFG_DIR') }}" \
      $LIMIT_HOSTS
done