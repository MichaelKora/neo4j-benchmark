#!/bin/bash

sudo cp kafka-client/contrib.sink.neo4j-before.json kafka-client/contrib.sink.neo4j-current.json
sudo docker compose -f docker-compose-first-run.yaml up -d --build --force-recreate
