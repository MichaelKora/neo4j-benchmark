# neo4jBenchmark

Benchmark to investigate how to write cypher queries to receive a prompt response. For this, those properties are taken into consideration:

    - Better performance using patterns

    - Query tuning: use of indexes

## Prerequisites

    - Download the [data-zip](https://tubcloud.tu-berlin.de/f/3518814196) file and store it under `resources/python-producer`
    - Generate a pair of ssh keys called `gcp_tf/gcp_tf.pub` and store them under the directory named `keys` in the root dir.

## Create instance

Create the new GCP VM by running

```shell
terraform apply
```

## Deploy run 1

Once the instance is created run the following commands

```shell
sudo chmod -R 777 /tmp
cd /tmp/resources

sudo cp kafka-client/contrib.sink.neo4j-before.json kafka-client/contrib.sink.neo4j-current.json
sudo docker-compose up -d
```

Once the workload-generator service of the previous run terminates, stop the deployment by running:

```shell
sudo docker compose down
```

## Deploy run 2

Before starting the second run, make sure to change the name of the old measurements, then update the Kafka connector configuration.

```shell
cd /tmp/resources/measurements/
mv  connetor-benchmark/connector-results-latest.csv connetor-benchmark/connector-results-run1.csv

mv workload-generator/time_tracker_latest.csv workload-generator/time_tracker_run1.csv

cd /tmp/resources/
sudo cp kafka-client/contrib.sink.neo4j-parallelize.json  kafka-client/contrib.sink.neo4j-current.json
sudo docker-compose up -d --build --force-recreate
```

## Deploy run 3

Once the workload-generator service of the previous run terminates, stop the deployment by running:

```shell
sudo docker compose down
```

Before starting this run, make sure to change the name of the old measurements, then update the Kafka connector configuration.

```shell
cd /tmp/resources/measurements/
mv  connetor-benchmark/connector-results-latest.csv connetor-benchmark/connector-results-run2.csv

mv workload-generator/time_tracker_latest.csv workload-generator/time_tracker_run2.csv

cd /tmp/resources/
sudo cp kafka-client/contrib.sink.neo4j-poll.json kafka-client/contrib.sink.neo4j-current.json
sudo docker-compose up -d --build --force-recreate
```

## Deploy run 4

Once the workload-generator service of the previous run terminates, stop the deployment by running:

```shell
sudo docker compose down
```

Before starting this run, make sure to change the name of the old measurements, then update the Kafka connector configuration.

```shell
cd /tmp/resources/measurements/
mv  connetor-benchmark/connector-results-latest.csv connetor-benchmark/connector-results-run3.csv

mv workload-generator/time_tracker_latest.csv workload-generator/time_tracker_run3.csv

cd /tmp/resources/
sudo cp kafka-client/contrib.sink.neo4j-querry.json kafka-client/contrib.sink.neo4j-current.json
sudo docker-compose up -d --build --force-recreate
```

Once neo4j starts, go on the UI on port 7474:
and run the following queries to create some constraints (user: neo4j, PWD: connect):

```python
CREATE CONSTRAINT IF NOT EXISTS FOR (t:Trial) require t.id IS UNIQUE

CREATE CONSTRAINT IF NOT EXISTS FOR (p:Pubmed) require p.id IS UNIQUE

CREATE CONSTRAINT IF NOT EXISTS FOR (pmc:Pmc) require pmc.id IS UNIQUE
```

## Deploy run 5

Once the workload-generator service of the previous run terminates, stop the deployment by running:

```shell
sudo docker compose down
```

Before starting this run, make sure to change the name of the old measurements, then update the Kafka connector configuration.

```shell
cd /tmp/resources/measurements/
mv  connetor-benchmark/connector-results-latest.csv connetor-benchmark/connector-results-run4.csv

mv workload-generator/time_tracker_latest.csv workload-generator/time_tracker_run4.csv

cd /tmp/resources/
sudo docker-compose up -d --build --force-recreate
```

Once neo4j starts, go on the UI on port 7474:
and run the following queries to create some indexes (user: neo4j, PWD: connect):

```python
CREATE INDEX entity_name_range_index IF NOT EXISTS
FOR (e:Entity) ON (e.name)

CREATE INDEX entity_type_range_index IF NOT EXISTS
FOR (e:Entity) ON (e.type)
```

## End

Once the workload-generator service of the previous run terminates, stop the deployment by running:

```shell
sudo docker compose down
```

```shell
cd /tmp/resources/measurements/
mv  connetor-benchmark/connector-results-latest.csv connetor-benchmark/connector-results-run5.csv

mv workload-generator/time_tracker_latest.csv workload-generator/time_tracker_run5.csv

cd /tmp/resources/

sudo docker-compose up -d --build --force-recreate
```
