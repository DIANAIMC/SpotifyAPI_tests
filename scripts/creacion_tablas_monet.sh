#! /bin/bash

echo "Creamos base de datos en Monet"
#docker exec -it monetdb mclient -q "CREATE DATABASE spotify;"
#docker exec -it monetdb create -p monetdb spotify
#docker exec -it monetdb  mclient -u monetdb -d spotify
docker exec -it monetdb /bin/bash --quiet\
--eval "monetdb create -p monetdb spotify"\

echo "La contraseña es monetdb"

echo "Creamos tablas:"
echo "Tabla artist"
docker exec -it monetdb mclient -d spotify -q << EOF
	create table if not exists artist( 
	followers integer, 
	genre varchar(20), 
	artist_id varchar(50), 
	popularity integer, 
	name varchar(200) 
	);
EOF
echo "Tabla album"
docker exec -it monetdb mclient -d spotify -q << EOF
	create table if not exists album( 
	artist_id varchar(50), 
	available_market varchar(10), 
	release_date date, 
	total_tracks integer, 
	name varchar(200) 
);
EOF
echo "Tabla track"
docker exec -it monetdb mclient -d spotify -q << EOF
	create table if not exists track( 
	album_id varchar(50), 
	available_market varchar(10), 
	disc_number integer, 
	duration_ms integer, 
	explicit boolean 
	track_id varchar(50), 
	popularity integer, 
	track_number integer, 
	name varchar(200) 
);
EOF
