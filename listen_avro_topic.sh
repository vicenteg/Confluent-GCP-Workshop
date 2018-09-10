#!/usr/bin/env bash

CONFLUENT_HOME=~/Downloads/confluent-5.0.0

if [[ "z" == "${CONFLUENT_HOME}z" ]];
then
    echo "CONFLUENT_HOME not set! Please edit this script and try again."
    exit 1
fi

CCLOUD_CONFIG=~/.ccloud/config
BOOTSTRAP_SERVER=$( cat ${CCLOUD_CONFIG} |  grep "bootstrap.servers" | awk -F= '{print $2}' | sed s/\\\\:/\:/g )
${CONFLUENT_HOME}/bin/kafka-avro-console-consumer \
    --consumer.config ${CCLOUD_CONFIG} \
    --bootstrap-server ${BOOTSTRAP_SERVER} \
    --topic $1 \
    --from-beginning \
    --property schema.registry.url=http://${2}:8081
