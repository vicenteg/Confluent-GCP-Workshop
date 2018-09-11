#!/bin/bash
CCLOUD_CONFIG=~/.ccloud/config
BOOTSTRAP_SERVER=$(cat ${CCLOUD_CONFIG} | grep "bootstrap.servers" | awk -F= '{print $2}' | sed s/\\\\:/\:/g)

cat channel-language-mapping.csv | kafkacat -F ~/.ccloud/config \
    -b ${BOOTSTRAP_SERVER} -P -t wikipedia-language-map -K: