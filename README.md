# neo4jBenchmark

Benchmark to investigate how to write cypher queries to receive a prompt response. For this, those properties are taken into consideration:

    - Better performance using patterns

    - Query tuning: use of indexes

## Prerequisites

    - Download the data zip file and store it under `resources/python-producer`
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
sudo docker compose -f docker-compose-first-run.yaml up -d --build --force-recreate
```

## Destroy part 1 and deploy part 2

```shell

cd /tmp
sudo chmod +x scheduler-script.sh
sudo bash scheduler-script.sh
```

## Results

All containers will be shut down once the benchmark is over.
The results are stored under the measurements directory.
