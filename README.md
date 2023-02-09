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

## Deploy part 1

Once the instance is created run the following commands

```shell

cd /tmp
sudo cp kafka-client/contrib.sink.neo4j-before.json kafka-client/contrib.sink.neo4j-current.json
sudo mv docker-compose-first-run.yaml docker-compose.yaml
sudo docker compose up -d --build --force-recreate
```

## Destroy part 1 and deploy part 2

Once the container `connector-benchmark` terminated, run those commands from another window

```shell
cd /tmp

sudo rm kafka-client/contrib.sink.neo4j-current.json
sudo cp kafka-client/contrib.sink.neo4j-after.json kafka-client/contrib.sink.neo4j-current.json

sudo mv my-data/connector-results-latest.csv my-data/connector-results-before.csv

sudo docker compose down

sudo mv docker-compose.yaml docker-compose-first-run.yaml
sudo mv  docker-compose-second-run.yaml docker-compose.yaml

sudo docker system prune
sudo docker compose up -d --build --force-recreate

```

## Results

Wait until the container `workload-generator` terminates.
The results are stored under the measurements directory.
