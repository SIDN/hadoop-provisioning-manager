#!/bin/bash

# Removing all components

. playbooks-env.sh

if [ "$?" -ne 0 ]; then
    echo "Loading environment failed, stopping"
    exit 1
fi

function show_usage()
{
  echo "Usage: $CURRENT_SCRIPT [service]+\n"
  echo "Supported services: $SCRIPT_SUPPORT"
}

if [ "$#" -lt 1 ]; then
    show_usage exit 1
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

SCRIPT_SUPPORT="all"
PB_PREFIX="clean"
DEPLOY_MODE=$DEPLOY_MODE_COMP

run_playbooks "$@"