#! /bin/bash

echo -e "\nCreamos Nodos:"
# Artists
echo "	> Artists"
docker exec -t neo4jdb cypher-shell -u neo4j -p test 'LOAD CSV WITH HEADERS FROM "file:///artists_neo.csv" AS row CREATE (n:Artist) SET n = row, n.followers = toInteger(row.followers), n.popularity = toInteger(row.popularity);'

echo "	> Albums"
docker exec -t neo4jdb cypher-shell -u neo4j -p test 'LOAD CSV WITH HEADERS FROM "file:///albums_neo.csv" AS row CREATE (n:Album) SET n = row, n.releaseDate = date(row.releasedate), n.totalTracks = toInteger(row.totaltracks);'

echo "	> Tracks"
docker exec -t neo4jdb cypher-shell -u neo4j -p test 'LOAD CSV WITH HEADERS FROM "file:///tracks_neo.csv" AS row CREATE (n:Track) SET n = row, n.discNumber = toInteger(row.discnumber), n.durationMs = toInteger(row.durationms), n.explicit = toBoolean(row.explicit), n.popularity = toInteger(row.popularity), n.trackNumber = toInteger(row.tracknumber);'


echo -e "\nCreamos relaciones entre nodos:"

echo "	> Edges entre Artists y Albums"
docker exec -t neo4jdb cypher-shell -u neo4j -p test 'MATCH (ar:Artist),(al:Album) WHERE ar.artistid = al.artistid CREATE (al)-[:ALBUM_OF]->(ar)'

echo "	> Edges entre Tracks y Albums"
docker exec -t neo4jdb cypher-shell -u neo4j -p test 'MATCH (t:Track),(al:Album) WHERE t.albumid = al.albumid CREATE (t)-[:TRACK_OF_ALBUM]->(al)'

echo "	> Edges entre Tracks y Albums"
docker exec -t neo4jdb cypher-shell -u neo4j -p test 'MATCH (t:Track),(ar:Artist) WHERE t.artistid = ar.artistid CREATE (t)-[:TRACK_OF_ARTIST]->(ar)'
