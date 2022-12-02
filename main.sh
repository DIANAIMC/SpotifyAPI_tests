#! /bin/bash

# Primero creamos el contenedor
./create_container.sh

# Luego extraemos los datos de la API
python ./spotify.py

# Y ahora sacamos los datos de mongo y los traemos a nuestra computadora
./extract_data_from_mongo.sh