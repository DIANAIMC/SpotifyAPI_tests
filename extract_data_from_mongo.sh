#! /bin/bash

# Nota: esto supone que los datos ya están cargados en un docker
# El nombre del contenedor debe ser mongo

# Encendemos el docker por si no estaba
docker start mongo

# Exportamos los datos de la base de datos a un archivo .json 
# Ese archivo sigue dentro de la terminal del contenedor docker
DATA_BASE_NAME='pokemon_api'
COLLECTION_NAME='pokemones'
OUTPUT_FILE='data_pokemones.json'
docker exec mongo mongoexport -d $DATA_BASE_NAME -c $COLLECTION_NAME --out $OUTPUT_FILE

# Ahora que el archivo está en la terminal del contenedor, tenemos que sacarlo de ahí
# Necesitamos el ID del contenedor
CONTAINER_NAME='mongo'
ID_CONTAINER=$(docker ps -aqf "name=$CONTAINER_NAME")
docker cp $ID_CONTAINER:/$OUTPUT_FILE ~/$OUTPUT_FILE
