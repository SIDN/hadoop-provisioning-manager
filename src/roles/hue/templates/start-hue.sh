#!/usr/bin/env bash

# Created on {{ ansible_date_time.iso8601 }}
# Pushed to: {{  inventory_hostname }}

docker run --rm \
--name hue \
-p {{ hue_port }}:8888 \
--restart=on-failure:10 \
-v {{ hue_etc_dir }}/hue.ini:/usr/share/hue/desktop/conf/z-hue.ini \
-v {{ hue_etc_dir }}/hue-custom.ini:/usr/share/hue/desktop/conf/hue-custom.ini \
-v {{ hue_etc_dir }}/log.conf:/usr/share/hue/desktop/conf/log.conf \
-v {{ hue_etc_dir }}/log4j.properties:/usr/share/hue/desktop/conf/log4j.properties \
-v {{ hue_etc_dir }}/impalad_flags:/home/hue/impalad_flags \
-v {{ hue_log_dir }}:{{ hue_log_dir }} \
-v {{ hue_etc_dir }}/hive-site.xml:/home/hue/hive-site.xml \
-v {{ hue_etc_dir }}/core-site.xml:/home/hue/core-site.xml \
-v {{ hue_etc_dir }}/hdfs-site.xml:/home/hue/hdfs-site.xml \
-v {{ hue_etc_dir }}/hue.keytab:/home/hue/hue.keytab \
-v {{ tls_etc_dir }}/{{ tls_remote_pub_chain }}:/home/hue/{{ tls_remote_pub_chain }} \
-v {{ tls_etc_dir }}/{{ tls_remote_priv_key }}:/home/hue/{{ tls_remote_priv_key }} \
-v {{ hue_etc_dir }}/http.keytab:/etc/krb5.keytab \
-v /etc/krb5.conf:/etc/krb5.conf {{ groups['manager'][0] }}:{{ docker_registry_port }}/gethue/hue:{{ version.hue }}
