# Paramos y eliminamos el contenedor en caso de que ya exista
echo 'Eliminamos el contendedor spotify en caso de que ya exista'
docker stop spotify > /dev/null
docker rm spotify > /dev/null

# Creamos un volumen que se llama spotify-data
echo 'Creamos el volumen y el contenedor spotify'
docker volume create spotify-data > /dev/null
# Creamos el contenedor con el volumen creado y con mongo como imagen 
docker run -d --name spotify -p 27017:27017 --mount source=spotify-data,target=/data mongo > /dev/null

# Iniciamos el contenedor
docker start spotify > /dev/null
sleep 2

# Eliminamos las colecciones en caso de que existan
docker exec -it spotify mongosh --quiet \
--eval 'use spotify' \
--eval 'db.artists.drop()' \
--eval 'db.albums.drop()' \
--eval 'db.tracks.drop()' \
--eval 'db.uw_artists.drop()' \
--eval 'db.uw_albums.drop()' \
--eval 'db.uw_tracks.drop()' \
> /dev/null