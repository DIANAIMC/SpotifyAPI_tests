# Paramos y eliminamos el contenedor en caso de que ya exista
docker stop spotify
docker rm spotify

# Creamos un volumen que se llama spotify-data
docker volume create spotify-data
# Creamos el contenedor con el volumen creado y con mongo como imagen 
docker run -d --name spotify -p 27017:27017 --mount source=spotify-data,target=/data mongo