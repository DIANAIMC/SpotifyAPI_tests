#! /bin/bash

echo "Creamos tablas:"

echo "Tabla artist"
docker exec -i monetdb mclient -d spotify -s "create table if not exists artist(followers integer, genre varchar(20),artist_id varchar(50),popularity integer,name varchar(200));"

echo "Tabla album"
docker exec -i monetdb mclient -d spotify -s "create table if not exists album(artist_id varchar(50),available_market varchar(10),release_date date,total_tracks integer,name varchar(200));"

echo "Tabla track"
docker exec -i monetdb mclient -d spotify -s "create table if not exists track(album_id varchar(50),available_market varchar(10),disc_number integer,duration_ms integer,explicit boolean, track_id varchar(50),popularity integer,track_number integer,name varchar(200));"

