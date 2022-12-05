#! /bin/bash

echo -e "\nCreamos tablas:"

echo "- Tabla artist"
docker exec -i monetdb mclient -d spotify -s "create table if not exists artist(followers varchar(100), genre varchar(100),artist_id varchar(100),popularity varchar(100),name varchar(200));"

echo "- Tabla album"
docker exec -i monetdb mclient -d spotify -s "create table if not exists album(artist_id varchar(100),available_market varchar(100),release_date date,total_tracks varchar(100),name varchar(200));"

echo "- Tabla track"
docker exec -i monetdb mclient -d spotify -s "create table if not exists track(album_id varchar(100),available_market varchar(100),disc_number varchar(100),duration_ms varchar(100),explicit varchar(100), track_id varchar(50),popularity varchar(50),track_number varchar(50),name varchar(200));"

