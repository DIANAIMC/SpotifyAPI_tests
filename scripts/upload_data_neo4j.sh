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
docker run -d --name neo4jdb -p 7474:7474 --mount source=spotify-data,target=/data neo4j > /dev/null

echo 'Insertamos al docker archivos csv'
# Metemos los datos que queremos adentro del volumen
docker cp $WORKING_DIR/csv/neo4j neo4jdb:/data
