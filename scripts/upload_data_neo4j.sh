#!/bin/bash

WORKING_DIR=$(pwd)
WORKING_DIR=$WORKING_DIR/data/csv/neo4j


#Primero debemos tener la imagen de neo4j en el docker, de no ser así, ejecutamos:
#docker pull neo4j

#Verificamos que tenemos la imagen
#docker images| grep neo4j

echo 'Eliminamos el contendedor neo4jdb en caso de que ya exista'
docker stop neo4jdb > /dev/null
docker rm neo4jdb > /dev/null

# Creamos el contenedor con neo4j
echo 'Creamos el contenedor'
docker run -d --name neo4jdb -p 7474:7474 -p 7687:7687 -v $WORKING_DIR:/var/lib/neo4j/import --env NEO4J_AUTH=neo4j/test neo4j > /dev/null

echo 'Please wait, this will take some time...'
sleep 15
echo 'Insertamos al docker archivos csv'
./scripts/creacion_nodos_neo4j.sh
# Metemos los datos que queremos adentro del volumen
#docker cp -a $WORKING_DIR/csv/neo4j neo4jdb:/var/lib/neo4j/import
