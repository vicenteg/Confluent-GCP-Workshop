#!/bin/bash

CONNECT_HOST=localhost

if [[ $1 ]];then
    CONNECT_HOST=$1
fi

HEADER="Content-Type: application/json"
DATA=$( cat << EOF
{
  "name": "bigquery-wikipediaedits",
  "config": {
    "connector.class": "com.wepay.kafka.connect.bigquery.BigQuerySinkConnector",
    "topics": "WIKIPEDIAEDITS",
    "autoCreateTables": true,
    "sanitizeTopics": true,
    "autoUpdateSchemas": true,
    "schemaRetriever": "com.wepay.kafka.connect.bigquery.schemaregistry.schemaretriever.SchemaRegistrySchemaRetriever",
    "schemaRegistryLocation": "http://35.231.187.35:8081,http://35.237.49.31:8081",
    "key.converter":"org.apache.kafka.connect.storage.StringConverter",
    "bufferSize": 100000,
    "maxWriteSize": 10000,
    "tableWriteWait": 1000,
    "project": "sales-engineering-206314",
    "datasets": ".*=wikipedia",
    "keyfile": "/etc/kafka/gbq-keyfile.json",
    "tasks.max": "1"
  }
}
EOF
)

echo "curl -X POST -H \"${HEADER}\" --data \"${DATA}\" http://${CONNECT_HOST}:8083/connectors"
curl -X POST -H "${HEADER}" --data "${DATA}" http://${CONNECT_HOST}:8083/connectors
echo
