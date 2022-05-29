#!/bin/bash

PB_PREPARE=upgrade-hdfs-prepare.yml
PB_FINALIZE=upgrade-hdfs-finalize.yml
. playbooks-env.sh

function show_usage
{
  echo "Usage: hdfs.sh [prepare|finalize]"
}

if [ "$?" -ne 0 ]; then
    echo "Loading environment failed, stopping"
    exit 1
fi

if [ "$#" -lt 1 ]; then
    show_usage exit 1
fi

for var in "$@"
do
    case "$var" in
      prepare)
        run_playbook "$PB_PREPARE"
      ;;
    finalize)
        run_playbook "$PB_FINALIZE"
      ;;
      *)
        show_usage exit 1
      ;;
    esac
done

