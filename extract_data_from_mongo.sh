#! /bin/bash

# Nota: esto supone que los datos ya están cargados en un docker
# El nombre del contenedor debe ser mongo

# Encendemos el docker por si no estaba
docker start mongo

# Creamos una carpeta en el contenedor para guardar las colecciones que vayamos bajando
docker exec mongo mkdir -p data_spotify

# Exportamos los datos de la base de datos a un archivo .json 
# Ese archivo sigue dentro de la terminal del contenedor docker
DATA_BASE_NAME='spotify'
COLLECTION_NAME='albums'
OUTPUT_FILE='/data_spotify/albums.json'
docker exec mongo mongoexport -d $DATA_BASE_NAME -c $COLLECTION_NAME --out $OUTPUT_FILE

COLLECTION_NAME='artists'
OUTPUT_FILE='/data_spotify/artists.json'
docker exec mongo mongoexport -d $DATA_BASE_NAME -c $COLLECTION_NAME --out $OUTPUT_FILE

COLLECTION_NAME='tracks'
OUTPUT_FILE='/data_spotify/tracks.json'
docker exec mongo mongoexport -d $DATA_BASE_NAME -c $COLLECTION_NAME --out $OUTPUT_FILE

# Ahora que el archivo está en la terminal del contenedor, tenemos que sacarlo de ahí
# Necesitamos el ID del contenedor
CONTAINER_NAME='mongo'
ID_CONTAINER=$(docker ps -aqf "name=$CONTAINER_NAME")
docker cp $ID_CONTAINER:/data_spotify ~/data_spotify
