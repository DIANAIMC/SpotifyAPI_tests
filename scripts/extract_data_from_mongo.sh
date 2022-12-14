#! /bin/bash

# Nota: esto supone que los datos ya están cargados en un docker
WORKING_DIR=$1

# Encendemos el docker por si no estaba
CONTAINER_NAME='spotify'
# docker start $CONTAINER_NAME

# Corremos el script para generar los datos con unwind
./scripts/make_unwinds.sh

# Creamos una carpeta en el contenedor para guardar las colecciones que vayamos bajando
docker exec $CONTAINER_NAME mkdir -p data_spotify

# Exportamos los datos de la base de datos a un archivo .json
# Ese archivo sigue dentro de la terminal del contenedor docker
DATA_BASE_NAME='spotify'

echo "Exportamos archivos json para Monet"

COLLECTION_NAME='uw_albums_mon'
OUTPUT_FILE='/data_spotify/albums_mon.json'
docker exec $CONTAINER_NAME mongoexport -d $DATA_BASE_NAME -c $COLLECTION_NAME --out $OUTPUT_FILE > /dev/null
echo -e '\n'

# Extraemos los artistas
COLLECTION_NAME='uw_artists_mon'
OUTPUT_FILE='/data_spotify/artists_mon.json'
docker exec $CONTAINER_NAME mongoexport -d $DATA_BASE_NAME -c $COLLECTION_NAME --out $OUTPUT_FILE > /dev/null
echo -e '\n'

# Extraemos las canciones
COLLECTION_NAME='uw_tracks_mon'
OUTPUT_FILE='/data_spotify/tracks_mon.json'
docker exec $CONTAINER_NAME mongoexport -d $DATA_BASE_NAME -c $COLLECTION_NAME --out $OUTPUT_FILE > /dev/null
echo -e '\n'

echo "Exportamos archivos json para Neo4j"

COLLECTION_NAME='uw_albums_neo'
OUTPUT_FILE='/data_spotify/albums_neo.json'
docker exec $CONTAINER_NAME mongoexport -d $DATA_BASE_NAME -c $COLLECTION_NAME --out $OUTPUT_FILE > /dev/null
echo -e '\n'

# Extraemos los artistas
COLLECTION_NAME='uw_artists_neo'
OUTPUT_FILE='/data_spotify/artists_neo.json'
docker exec $CONTAINER_NAME mongoexport -d $DATA_BASE_NAME -c $COLLECTION_NAME --out $OUTPUT_FILE > /dev/null
echo -e '\n'

# Extraemos las canciones
COLLECTION_NAME='uw_tracks_neo'
OUTPUT_FILE='/data_spotify/tracks_neo.json'
docker exec $CONTAINER_NAME mongoexport -d $DATA_BASE_NAME -c $COLLECTION_NAME --out $OUTPUT_FILE > /dev/null
echo -e '\n'

# Ahora que el archivo está en la terminal del contenedor, tenemos que sacarlo de ahí
# Necesitamos el ID del contenedor
ID_CONTAINER=$(docker ps -aqf "name=$CONTAINER_NAME")
docker cp $ID_CONTAINER:/data_spotify $WORKING_DIR/
#docker exec $ID_CONTAINER cp /data_spotify $WORKING_DIR
