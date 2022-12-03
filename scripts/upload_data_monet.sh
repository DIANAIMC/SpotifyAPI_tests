#! /bin/bash

WORKING_DIR='/Users/mariano/Documents/bases_datos_nr/SpotifyAPI_tests'
echo $WORKING_DIR

echo 'Eliminamos el contendedor spotify en caso de que ya exista'
# Eliminamos y creamos el contenedor en caso de que ya exista
docker stop monetdb > /dev/null
docker rm monetdb > /dev/null

# Creamos el contenedor con monet
docker run -d --name monetdb -p 50001:50000 --mount source=spotify-data,target=/data monetdb/monetdb > /dev/null

# Metemos los datos que queremos adentro del volumen
docker cp $WORKING_DIR/data/csv monetdb:/data