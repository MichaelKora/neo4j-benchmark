from neo4j import GraphDatabase
import csv
import time

# Initialize connection to database
driver = GraphDatabase.driver('bolt://  neo4j:7687', auth=('neo4j', 'connect'))
# driver = GraphDatabase.driver(
#     'neo4j://localhost:7687', auth=('neo4j', 'connect'))


# which entity of a specific type appear the most in both pmc and pubmed
query1 = '''
MATCH (pmc:Pmc)-[:MENTIONS]->(e:Entity)<-[:MENTIONS]-(pub:Pubmed)
WITH e.type AS Type, count(*) AS Count
RETURN Type, Count
ORDER BY Count DESC
LIMIT 10000
'''

# top 10 most mentioned entities

query2 = '''
MATCH (n)-[:MENTIONS]->(e:Entity)
WITH e.name AS Name, count(*) AS Count
RETURN Name, Count
ORDER BY Count DESC
LIMIT 10
'''

# the most mentioned entity type
query3 = '''
MATCH (n) -[:MENTIONS]->(e:Entity)
RETURN e.type AS Type, count(*) AS Count
ORDER BY Count DESC
LIMIT 1
'''

# Top 10000 of entity names mentioned in both pmc and pubmed
query4 = '''
MATCH (pmc:Pmc)-[:MENTIONS]->(e:Entity)<-[:MENTIONS]-(pub:Pubmed)
WITH e.name AS Name, count(*) AS Count
RETURN Name, Count
ORDER BY Count DESC
LIMIT 10000
'''

queries = []
queries.append(query1)
queries.append(query2)
queries.append(query3)
queries.append(query4)

results_befpre_optimization = [
    ["Query ID", "Itteration", "Duration in seconds"]]
query_no = 1
for query in queries:
    for iteration in range(1, 20):
        with driver.session() as session:

            # tracks the start time
            # st = time.perf_counter() # ns
            st = time.time()  # secondss

            # run query
            info = session.run(query)
            g = info.graph()

            # tracks the end time
            # et = time.perf_counter()
            et = time.time()

            # find elapsed time in seconds
            # duration = (et - st) * 10 ** 6
            # duration = e - st # "ns"
            duration = et - st  # "seconds"

            results_befpre_optimization.append([query_no, iteration, duration])
    query_no += 1

with open('my-data/time_tracker_before_optimization.csv', 'w', newline='') as file:
    writer = csv.writer(file)
    writer.writerows(results_befpre_optimization)

entity_name_range_index = '''
CREATE INDEX entity_name_range_index IF NOT EXISTS
FOR (e:Entity) ON (e.name)
'''

entity_type_range_index = '''
CREATE INDEX entity_type_range_index IF NOT EXISTS
FOR (e:Entity) ON (e.type)
'''

with driver.session() as session:
    session.run(entity_name_range_index)
    session.run(entity_type_range_index)

results_after_optimization = [
    ["Query ID", "Itteration", "Duration in seconds"]]
query_no = 1
for query in queries:
    for iteration in range(1, 20):
        with driver.session() as session:

            # get the start time
            st = time.time()

            # run query
            info = session.run(query)
            g = info.graph()

            # get the end time
            et = time.time()

            duration = et - st

            results_after_optimization.append([query_no, iteration, duration])
    query_no += 1
with open('my-data/time_tracker_after_optimization.csv', 'w', newline='') as file:
    writer = csv.writer(file)
    writer.writerows(results_after_optimization)
