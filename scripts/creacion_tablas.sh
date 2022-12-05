#! /bin/bash

echo "Creamos base de datos en Monet"
docker exec -it monetdb mclient -u monetdb -d spotify
echo "Creamos tablas:"

echo "Tabla artist"
docker exec -it monetdb mclient spotify --quiet \

--eval "create table if not exists artist( \
	followers integer, \
	genre varchar(20), \
	artist_id varchar(50), \
	name varchar(200), \
	popularity integer \
);"

echo "Tabla album"
docker exec -it monetdb mclient spotify --quiet \

--eval "create table if not exists album( \
	artist_id varchar(50), \
	available_market varchar(10), \
	name varchar(200), \
	release_date date, \
	total_tracks integer \
);"

echo "Tabla track"
docker exec -it monetdb mclient spotify --quiet \

--eval "create table if not exists track( \
	album_id varchar(50), \
	available_market varchar(10), \
	disc_number integer, \
	duration_ms integer, \
	explicit boolean \
	track_id varchar(50), \
	name varchar(200), \
	popularity integer, \
	track_number integer \
);"
