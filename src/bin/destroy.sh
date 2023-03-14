#!/bin/bash

# Removing all components

. playbooks-env.sh

if [ "$?" -ne 0 ]; then
    echo "Loading environment failed, stopping"
    exit 1
fi

echo "Components and/or data will be deleted on hosts"
read -p "Are you sure? (y/n)" -n 1 -r
echo    # (optional) move to a new line
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    echo "Aborting..."
    exit 1
fi

if [ "$#" -lt 1 ]; then
    show_usage exit 1
fi

run_playbooks "destroy-$@.yml"

#run_playbook "destroy-all.yml"
