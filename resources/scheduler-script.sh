#!/bin/bash
cp kafka-client/contrib.sink.neo4j-before.json kafka-client/contrib.sink.neo4j-current.json
sudo docker compose -f docker-compose-first-run.yaml up -d --build --force-recreate
while true
do
    if [ ! "$(sudo docker ps -a -q -f name=connector-benchmark)" ]; then
        if [ "$(sudo docker ps -aq -f status=exited -f name=connector-benchmark)" ]; then
            rm kafka-client/contrib.sink.neo4j-current.json
            cp kafka-client/contrib.sink.neo4j-after.json kafka-client/contrib.sink.neo4j-current.json
            
            mv my-data/connector-results-latest.csv my-data/connector-results-before.csv
            # cleanup
            sudo docker compose down
            sudo docker compose -f docker-compose-first-run.yaml up -d --build --force-recreate
            break

        fi
    fi
    sleep 30
done


while true
do
    if [ ! "$(sudo docker ps -a -q -f name=connector-benchmark)" ]; then
        if [ "$(sudo docker ps -aq -f status=exited -f name=connector-benchmark)" ]; then
            # cleanup
            sudo docker compose down
            mv my-data/connector-results-latest.csv my-data/connector-results-after.csv
            rm kafka-client/contrib.sink.neo4j-current.json
            break
        fi
    fi
    sleep 30
done
