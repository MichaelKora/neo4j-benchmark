#!/bin/bash

while true
do
    if [ ! "$(sudo docker ps -a -q -f name=connector-benchmark)" ]; then
        if [ "$(sudo docker ps -aq -f status=exited -f name=connector-benchmark)" ]; then

            # cleanup
            sudo rm kafka-client/contrib.sink.neo4j-current.json
            sudo cp kafka-client/contrib.sink.neo4j-after.json kafka-client/contrib.sink.neo4j-current.json
            
            sudo mv my-data/connector-results-latest.csv my-data/connector-results-before.csv
            sudo docker compose down

            # start compose            
            sudo docker compose -f docker-compose-second-run.yaml up -d --build --force-recreate
            break

        fi
    fi
    sleep 30
done

# stop compose when connector job is done
while true
do
    if [ ! "$(sudo docker ps -a -q -f name=connector-benchmark)" ]; then
        if [ "$(sudo docker ps -aq -f status=exited -f name=connector-benchmark)" ]; then
            # cleanup
            sudo docker compose down
            sudo mv my-data/connector-results-latest.csv my-data/connector-results-after.csv
            sudo rm kafka-client/contrib.sink.neo4j-current.json
            break
        fi
    fi
    sleep 30
    
done

