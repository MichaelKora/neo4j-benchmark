#!/bin/bash

sleep 600
cd /tmp

mkdir -p my-data
touch my-data/connector-results-latest.csv

curl -X POST http://connect:8083/connectors \
  -H 'Content-Type:application/json' \
  -H 'Accept:application/json' \
  -d @contrib.sink.neo4j-current.json

runtime="20 minute"
endtime=$(date -ud "$runtime" +%s)

while [[ $(date -u +%s) -le $endtime ]]
do
    kafka-consumer-groups --bootstrap-server kafka:9092 --describe --group connect-Neo4jSinkConnector| awk -v date="$(date +%d/%m/%Y-%H:%M:%S)" '{sum += $6} END {print date ";" sum}' >> my-data/connector-results-latest.csv
    sleep 30
done
sleep 800

