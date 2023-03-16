from neo4j import GraphDatabase
import csv
import time

# Initialize connection to database
# driver = GraphDatabase.driver('neo4j://<IP>:7687', auth=('neo4j', 'connect'))
driver = GraphDatabase.driver('bolt://  neo4j:7687', auth=('neo4j', 'connect'))
# driver = GraphDatabase.driver(
#     'neo4j://localhost:7687', auth=('neo4j', 'connect'))


# which entity of a specific type appear the most in both pmc and pubmed
query1 = '''
MATCH (pmc:Pmc)-[:MENTIONS]->(e:Entity)<-[:MENTIONS]-(pub:Pubmed)
WITH e.type AS Type, count(*) AS Count
RETURN Type, Count
ORDER BY Count DESC
'''

query2 = '''
MATCH (n)-[:MENTIONS]->(e:Entity)
WITH e.name AS Name, count(*) AS Count
RETURN Name, Count
ORDER BY Count DESC
'''

# the most mentioned entity type
query3 = '''
MATCH (n) -[:MENTIONS]->(e:Entity)
RETURN e.type AS Type, count(*) AS Count
ORDER BY Count DESC
'''

# Top 10000 of entity names mentioned in both pmc and pubmed
query4 = '''
MATCH (pmc:Pmc)-[:MENTIONS]->(e:Entity)<-[:MENTIONS]-(pub:Pubmed)
WITH e.name AS Name, count(*) AS Count
RETURN Name, Count
ORDER BY Count DESC
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
            st = time.time()  # secondss

            # run query
            info = session.run(query)
            g = info.graph()

            et = time.time()

            duration = et - st  # "seconds"


            results_befpre_optimization.append([query_no, iteration, duration])
    query_no += 1

with open('./my-data/time_tracker_before_optimization.csv', 'w', newline='') as file:
    writer = csv.writer(file)
    writer.writerows(results_befpre_optimization)

