#! /bin/bash

echo "Creamos tablas:"

echo "Tabla artist"
docker exec -i monetdb mclient -d spotify -s "create table if not exists artist(followers varchar(50), genre varchar(20),artist_id varchar(50),popularity varchar(50),name varchar(200));"

echo "Tabla album"
docker exec -i monetdb mclient -d spotify -s "create table if not exists album(artist_id varchar(50),available_market varchar(10),release_date date,total_tracks varchar(50),name varchar(200));"

echo "Tabla track"
docker exec -i monetdb mclient -d spotify -s "create table if not exists track(album_id varchar(50),available_market varchar(10),disc_number varchar(50),duration_ms varchar(50),explicit varchar(50), track_id varchar(50),popularity varchar(50),track_number varchar(50),name varchar(200));"

