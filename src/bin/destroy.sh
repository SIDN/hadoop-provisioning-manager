#!/bin/bash

# Removing all components

. playbooks-env.sh

if [ "$?" -ne 0 ]; then
    echo "Loading environment failed, stopping"
    exit 1
fi

echo "All comoponents and data will be deleted on hosts"
read -p "Are you sure? (y/n)" -n 1 -r
echo    # (optional) move to a new line
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    echo "Aborting..."
    exit 1
fi

echo "Clean hosts"

run_playbook "destroy-all.yml"
