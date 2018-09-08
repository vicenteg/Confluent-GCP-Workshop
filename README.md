# Confluent Cloud on GCP 
This workshop attempts to illustrate how to use Confluent Cloud Platform on GCP

## Components
* Google Cloud Platform
* [Confluent Cloud Professional](https://confluent.cloud)
* [Confluent Platform](https://www.confluent.io/download/) (for local testing)
* [Confluent Schema Registry](https://docs.confluent.io/current/schema-registry/docs/index.html)
* [Kafka Connect](https://docs.confluent.io/current/connect/index.html)
    * [Kafka Connect IRC Source](https://github.com/cjmatta/kafka-connect-irc)
    * [Google Big Query Sink](https://github.com/wepay/kafka-connect-bigquery)
    * [Google Cloud Storage Sink](https://docs.confluent.io/current/connect/kafka-connect-gcs/index.html#kconnect-long-gcs)
* [Confluent KSQL](https://github.com/confluentinc/ksql)
* [Confluent Ansible scripts](https://github.com/cjmatta/cp-ansible/tree/ccloud-profiles)

## Agenda
TODO

## Setup Environment
1. Initialize a cluster in Confluent Cloud, and get API key/secret
2. Creage some GCP hosts, we're using 2 n1-standard-4 (4 vCPUs, 15 GB memory)
3. Clone the Confluent Ansible repository
    ```
    $ git clone https://github.com/cjmatta/cp-ansible/tree/ccloud-profiles
    ```
4. Edit the `hosts.gcp-workshop.yml` and `gcp-workshop.yml` with your hosts, API info, and desired roles to install on which hosts, and copy them into the `cp-ansible` directory.
5. Install Confluent Platform components on the GCP hosts
    ```
    $ ansible-playbook --private-key=~/.ssh/google_compute_engine -i hosts.gcp-workshop.yml gcp-workshop.yml
    ```
6. Install Connect plugins
    ```
    $ ansible-playbook --private-key=~/.ssh/google_compute_engine -i hosts.gcp-workshop.yml install-connectors-playbook.yml
    ```

### Set up Kafka Connect Source
1. Create `wikipedia` topic:
    ```
    $ ccloud topic create wikipedia --replication-factor 3 --partitions 3
    ```

2. Edit `submit_wikipedia_irc_config.sh` with schema registry IPs, and then submit the connector:
    ```
    $ ./submit_wikipedia_irc_config.sh <connect-distributed-host>
    ```

3. Check the status of the connector:
    ```
    $ curl http://35.231.187.35:8083/connectors/wikipedia-irc/status | jq .
    % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                Dload  Upload   Total   Spent    Left  Speed
    100   169  100   169    0     0   1631      0 --:--:-- --:--:-- --:--:--  1640
    {
    "name": "wikipedia-irc",
    "connector": {
        "state": "RUNNING",
        "worker_id": "10.142.0.5:8083"
    },
    "tasks": [
        {
        "state": "RUNNING",
        "id": 0,
        "worker_id": "10.142.0.6:8083"
        }
    ],
    "type": "source"
    }
    ```

4. Use the `kafka-avro-console-consumer` to test that data is flowing into the topic:
    ```
    $ ${CONFLUENT_HOME}/bin/kafka-avro-console-consumer --bootstrap-server pkc-l9v0e.us-central1.gcp.confluent.cloud:9092 --consumer.config ~/.ccloud/config --topic wikipedia --property schema.registry.url=http://<schema-registry-ip>:8081
    {"createdat":1536371033912,"wikipage":"Jo Hyun-jae","channel":"#en.wikipedia","username":"2.205.55.98","commitmessage":"","bytechange":36,"diffurl":"https://en.wikipedia.org/w/index.php?diff=858558341&oldid=855644132","isnew":false,"isminor":false,"isbot":false,"isunpatrolled":false}
    --- snip ---
    ```

### Set up Sinks
#### Google Big Query Sink
1. Create service account, and download the authentication json file
2. Copy keyfile to the connect hosts:
    `$ ansible -i hosts.gcp-workshop.yml --private-key=~/.ssh/google_compute_engine -m copy -a "src=<path to keyfile> dest=/etc/kafka/gbq-keyfile.json" connect-distributed`
3. Edit `submit_google_big_query_config.sh` with Schema Registry ips:
    ```
    $ ./submit_google_big_query_config.sh <connect host ip>
    ```

### KSQL
1. Log into one of the KSQL servers
2. Start KSQL CLI
    ```
    $ ksql http://localhost:8088
    ```
3. Register the wikipedia topic as a stream:
    ```
    ksql> create stream wikipedia with (kafka_topic='wikipedia', value_format='avro');

    Message
    ----------------
    Stream created
    ----------------
    ```