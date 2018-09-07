# Confluent Cloud on GCP 
This workshop attempts to illustrate how to use Confluent Cloud Platform on GCP

## Components
* Google Cloud Platform
* [Confluent Cloud Professional](https://confluent.cloud)
* [Confluent Schema Registry](https://docs.confluent.io/current/schema-registry/docs/index.html)
* [Kafka Connect](https://docs.confluent.io/current/connect/index.html)
    * [Kafka Connect IRC Source](https://github.com/cjmatta/kafka-connect-irc)
    * [Google Big Query Sink](https://github.com/wepay/kafka-connect-bigquery)
    * [Google Cloud Storage Sink](https://docs.confluent.io/current/connect/kafka-connect-gcs/index.html#kconnect-long-gcs)
* [Confluent KSQL](https://github.com/confluentinc/ksql)
* [Confluent Ansible scripts](https://github.com/confluentinc/cp-ansible)

## Agenda

## Setup
1. Initialize a cluster in Confluent Cloud, and get API key/secret
2. Create some GCP hosts, we're using 2 n1-standard-4 (4 vCPUs, 15 GB memory)
3. Clone the Confluent Ansible repository
    ```
    $ git clone https://github.com/confluentinc/cp-ansible
    ```
4. Edit the `hosts.gcp-workshop.yml` and `gcp-workshop.yml` with your hosts, API info, and desired roles to install on which hosts, and copy them into the `cp-ansible` directory.
5. Install Confluent Platform components on the GCP hosts
    ```
    $ ansible-playbook --private-key=~/.ssh/google_compute_engine -i hosts.gcp-workshop.yml gcp-workshop.yml
    ```

