#! /bin/bash

echo 'Eliminamos el contendedor spotify en caso de que ya exista'
# Eliminamos y creamos el contenedor en caso de que ya exista
docker stop spotify_monet > /dev/null
docker rm spotify_monet > /dev/null

# Creamos el contenedor con monet
docker run -d --name spotify_monet -p 50001:50000 --mount source=spotify-data,target=/data monetdb/monetdb > /dev/null

# Metemos los datos que queremos adentro del volumen
docker cp ../data/csv spotify_monet:/data