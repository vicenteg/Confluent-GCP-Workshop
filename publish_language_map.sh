#!/bin/bash
cat channel-language-mapping.csv | kafkacat -F ~/.ccloud/config -b pkc-l9v0e.us-central1.gcp.confluent.cloud -P -t wikipedia-language-map -K: