#! /bin/bash

CURRENT_DIR=$(pwd)


mkdir -p $CURRENT_DIR/data
mkdir -p $CURRENT_DIR/data/csv
mkdir -p $CURRENT_DIR/data/csv/monet
mkdir -p $CURRENT_DIR/data/csv/neo4j

# Primero creamos el contenedor
echo -e '\n---------------------CREACIÓN DEL CONTENEDOR---------------------'
./scripts/create_container.sh

# Luego extraemos los datos de la API
echo -e '\n------------------------OBTENCIÓN DE DATOS------------------------'
python ./scripts/spotify.py

# Y ahora sacamos los datos de mongo y los traemos a nuestra computadora
echo '-------------------EXTRACCIÓN DE DATOS DE MONGO-------------------'
./scripts/extract_data_from_mongo.sh $CURRENT_DIR/data

# Convertimos json a csv
echo -e '------------------------CONVERSIÓN A CSV------------------------'
./scripts/obtencion_csv.sh $CURRENT_DIR/data

echo -e '\n------------------------UPLOAD DATA TO MONET------------------------'
./scripts/upload_data_monet.sh $CURRENT_DIR/data
#./scripts/creacion_tablas.sh

echo -e '\n------------------------UPLOAD DATA TO NEO4J------------------------'
./scripts/upload_data_neo4j.sh $CURRENT_DIR/data
#
