#! /bin/bash

WORKING_DIR=$1
#echo $WORKING_DIR

echo 'Eliminamos el contendedor monetdb en caso de que ya exista'
docker stop monetdb > /dev/null
docker rm monetdb > /dev/null

# Creamos el contenedor con monet
echo 'Creamos el contenedor'
docker run -d --name monetdb -p 50001:50000 --mount source=spotify-data,target=/data monetdb/monetdb > /dev/null

# Metemos los datos que queremos adentro del volumen
echo 'Insertamos al docker archivos csv'
docker cp $WORKING_DIR/csv/monet monetdb:/data


echo 'Creamos base de datos "spotify"'
docker exec -it monetdb monetdb create -p monetdb spotify > /dev/null

# Entramos a la base de datos con el mclient
echo 'La contrasena es "monetdb"'
docker exec -it monetdb mclient -u monetdb -d spotify
