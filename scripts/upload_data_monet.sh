#! /bin/bash

WORKING_DIR=$1

echo 'Eliminamos el contendedor monetdb en caso de que ya exista'
docker stop monetdb > /dev/null
docker rm monetdb > /dev/null

# Creamos el contenedor con monet
echo 'Creamos el contenedor'
docker run -d --name monetdb -p 50001:50000 --mount source=spotify-data,target=/data monetdb/monetdb > /dev/null

# Metemos los datos que queremos adentro del volumen
echo -e '\nInsertamos al docker archivos csv'
docker cp $WORKING_DIR/csv/monet monetdb:/data


echo 'Creamos base de datos "spotify"'
docker exec -it monetdb monetdb create -p monetdb spotify > /dev/null

# Entramos a la base de datos con el mclient
#echo 'La contrasena es "monetdb"'
#docker exec -it monetdb mclient -u monetdb -d spotify

# Creamos las tablas de la base de datos.
./scripts/creacion_tablas_monet.sh

# Insertamos los datos en las tablas.
echo -e '\nInsertamos datos en tablas:'

echo '- Datos de artistas'
docker exec -i monetdb mclient -d spotify -s "copy offset 2 into artist from '/data/monet/artists_mon.csv' on client using delimiters ',',E'\n',E'\"' null as ' ';"

echo '-Datos de albums'
docker exec -i monetdb mclient -d spotify -s "copy offset 2 into album from '/data/monet/albums_mon.csv' on client using delimiters ',',E'\n',E'\"' null as ' ';"

echo '- Datos de tracks'
docker exec -i monetdb mclient -d spotify -s "copy offset 2 into track from '/data/monet/tracks_mon.csv' on client using delimiters ',',E'\n',E'\"' null as ' ';"

# copy offset 2 into spotify from '/data/monet/albums_mon.csv' on album  using delimiters ',',E'\n',E'\"' null as ' ';
# copy offset 2 into track from '/data/monet/tracks_mon.csv' on client using delimiters ',',E'\n' null as ' ';
