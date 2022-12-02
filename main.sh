#! /bin/bash

# Primero creamos el contenedor
echo '---------------------CREACIÓN DEL CONTENEDOR---------------------'
./create_container.sh

# Luego extraemos los datos de la API
echo -e '\n------------------------OBTENCIÓN DE DATOS------------------------'
python ./spotify.py

# Y ahora sacamos los datos de mongo y los traemos a nuestra computadora
echo '-------------------EXTRACCIÓN DE DATOS DE MONGO-------------------'
./extract_data_from_mongo.sh