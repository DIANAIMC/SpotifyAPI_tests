#! /bin/bash

WORKING_DIR=$1

#Primero debemos tener la imagen de neo4j en el docker, de no ser así, ejecutamos: 
#docker pull neo4j

#Verificamos que tenemos la imagen 
#docker images| grep neo4j 

echo 'Eliminamos el contendedor neo4jdb en caso de que ya exista'
docker stop neo4jdb > /dev/null
docker rm neo4jdb > /dev/null

# Creamos el contenedor con neo4j
echo 'Creamos el contenedor'
#chmod 777 $WORKING_DIR/csv/neo4j/artists_neo.csv $WORKING_DIR/csv/neo4j/albums_neo.csv $WORKING_DIR/csv/neo4j/tracks_neo.csv

docker run -d --name neo4jdb -p 7474:7474 -p 7687:7687 \
 --env NEO4J_AUTH=neo4j/test neo4j > /dev/null
#docker exec -i neo4jdb bash \
#--env NEO4J_AUTH=neo4j/test

echo 'Insertamos al docker archivos csv'

# Metemos los datos que queremos adentro del volumen
docker cp $WORKING_DIR/csv/neo4j/. neo4jdb:/var/lib/neo4j/import
sleep 3
docker ps
#docker exec neo4jdb "cd /var/lib/neo4j/import && chown neo4j artists_neo.csv albums_neo.csv tracks_neo.csv"
#docker exec neo4jdb "chmod 777 /var/lib/neo4j/import/albums_neo.csv"
#docker exec neo4jdb "chmod 777 /var/lib/neo4j/import/tracks_neo.csv"
#:/var/lib/neo4j/import/data/csv/neo4j/artists_neo.csv ()
