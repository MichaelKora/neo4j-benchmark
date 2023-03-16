# virtuenv: neo4setup
import sys
import os

from kafka import KafkaProducer
import json
import multiprocessing as mp
from multiprocessing import Process


class Producer:
    broker = ""
    topic = ""
    producer = None

    def __init__(self, broker, topic):
        self.broker = broker
        self.topic = topic
        self.producer = KafkaProducer(bootstrap_servers=self.broker,
                                      value_serializer=lambda v: json.dumps(
                                          v).encode('utf-8'),
                                      acks='all',
                                      retries=3)

    def publish(self, data):
        try:
            future = self.producer.send(self.topic, data)
            self.producer.flush()
            future.get(timeout=10)
            return {'status_code': 200, 'error': None}
        except Exception as ex:
            return ex

    def close(self):
        self.producer.close()


def produce_data(file_name):
    print(f"Producing data for {file_name}")
    with open(f"./data/{file_name}.jsonl", 'r') as json_file:
        json_list = list(json_file)

    the_broker = 'kafka:9092'
    the_topic = file_name
    producer = Producer(the_broker, the_topic)
    size = 1000000
    sub_json_list = json_list[0:size]

    for line in sub_json_list:
        data = json.loads(line)
        producer.publish(data)


if __name__ == '__main__':
    inputs = ["pmc", "pubmed", "trials"]
    workers = mp.cpu_count()

    with mp.Pool(workers) as pool:
        pool.map(produce_data, inputs)
