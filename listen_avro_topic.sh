#!/usr/bin/env bash
if [[ $# -eq 0 ]] ; then
    echo 'Usage: $0 topic-name schema-registry-host'
    exit 0
fi

CONFLUENT_HOME=~/Downloads/confluent-5.0.0
CCLOUD_CONFIG=~/.ccloud/config
BOOTSTRAP_SERVER=$(cat ${CCLOUD_CONFIG} | grep "bootstrap.servers" | awk -F= '{print $2}' | sed s/\\\\:/\:/g)
TOPIC_NAME=$1
SCHEMA_REGISTRY=$2

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
    --topic ${TOPIC_NAME} \
    --from-beginning \
    --property schema.registry.url=http://${SCHEMA_REGISTRY}:8081
