#! /bin/bash

# Nota: esto supone que los datos ya están cargados en un docker

# Corremos el script para generar los datos con unwind
./make_unwinds.sh

# Encendemos el docker por si no estaba
CONTAINER_NAME='spotify'
docker start $CONTAINER_NAME

# Creamos una carpeta en el contenedor para guardar las colecciones que vayamos bajando
docker exec $CONTAINER_NAME mkdir -p data_spotify

# Exportamos los datos de la base de datos a un archivo .json 
# Ese archivo sigue dentro de la terminal del contenedor docker
DATA_BASE_NAME='spotify'

COLLECTION_NAME='uw_albums'
OUTPUT_FILE='/data_spotify/albums.json'
docker exec $CONTAINER_NAME mongoexport -d $DATA_BASE_NAME -c $COLLECTION_NAME --out $OUTPUT_FILE

# Extraemos los artistas
COLLECTION_NAME='uw_artists'
OUTPUT_FILE='/data_spotify/artists.json'
docker exec $CONTAINER_NAME mongoexport -d $DATA_BASE_NAME -c $COLLECTION_NAME --out $OUTPUT_FILE

# Extraemos las canciones
COLLECTION_NAME='uw_tracks'
OUTPUT_FILE='/data_spotify/tracks.json'
docker exec $CONTAINER_NAME mongoexport -d $DATA_BASE_NAME -c $COLLECTION_NAME --out $OUTPUT_FILE

# Ahora que el archivo está en la terminal del contenedor, tenemos que sacarlo de ahí
# Necesitamos el ID del contenedor
ID_CONTAINER=$(docker ps -aqf "name=$CONTAINER_NAME")
docker cp $ID_CONTAINER:/data_spotify ~/
