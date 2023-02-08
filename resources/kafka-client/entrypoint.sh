#!/bin/bash
cd /tmp

mkdir -p my-data

curl -X POST http://connect:8083/connectors \
  -H 'Content-Type:application/json' \
  -H 'Accept:application/json' \
  -d @contrib.sink.neo4j-current.json

runtime="2 minute"
endtime=$(date -ud "$runtime" +%s)

while [[ $(date -u +%s) -le $endtime ]]
do
    kafka-consumer-groups --bootstrap-server kafka:9092 --describe --group connect-Neo4jSinkConnector| awk -v date="$(date +%d/%m/%Y-%H:%M:%S)" '{sum += $6} END {print date ";" sum}' >> my-data/connector-results-latest.csv
    # kafka-topics.sh --bootstrap-server localhost:9092  --list
    # date >> /tmp/my-data/connector-results-before-changes.csv
    echo "hello"
    sleep 30
done

# curl -X DELETE http://localhost:8083/connectors/Neo4jSinkConnector


# curl -X POST http://localhost:8083/connectors \
#   -H 'Content-Type:application/json' \
#   -H 'Accept:application/json' \
#   -d @contrib.sink.neo4j-after.json


# endtime=$(date -ud "$runtime" +%s)
# while [[ $(date -u +%s) -le $endtime ]]
# do
#     kafka-consumer-groups.sh --bootstrap-server kafka:9092 --describe --group connect-Neo4jSinkConnector| awk -v date="$(date +%d/%m/%Y-%H:%M:%S)" '{sum += $5} END {print date ";" sum}' >> /tmp/my-data/connector-results-after-changes.csv
#     # date >> /tmp/my-data/connector-results-after-changes.csv
#     sleep 2
# done