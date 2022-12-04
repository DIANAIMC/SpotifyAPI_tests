#! /bin/bash

WORKING_DIR=$1

echo "Obtenemos archivos csv para Monet"

echo 'followers,genre,artist_id,popularity,namee' > $WORKING_DIR/csv/artists.csv
echo 'available_market,album_id,release_date,total_tracks,namee' > $WORKING_DIR/csv/albums.csv
echo 'album_id,available_market,disc_number,duration_ms,explicit,track_id,popularity,track_number,namee' > $WORKING_DIR/csv/tracks.csv 

echo 'Convirtiendo artistas'
sleep 1
jq -r '[.followers.total, .genres, .id, .popularity, .name] | @csv' $WORKING_DIR/data_spotify/artists_mon.json | awk -F, '{printf "%s,%s,%s,%s,%s\n", $1, $2, $3, $4, $5}' >> $WORKING_DIR/csv/artists.csv
echo 'Convirtiendo albums'
sleep 1
jq -r '[.available_markets, .id, .release_date, .total_tracks, .name] | @csv' $WORKING_DIR/data_spotify/albums_mon.json | awk -F, '{printf "%s,%s,%s, %s,%s\n", $1, $2, $3, $4, $5}' >> $WORKING_DIR/csv/albums.csv
echo 'Convirtiendo tracks'
sleep 1
jq -r '[.album.id, .available_markets, .disc_number, .duration_ms, .explicit, .id, .popularity, .track_number, .name] | @csv' $WORKING_DIR/data_spotify/tracks_mon.json | awk -F, '{printf "%s,%s,%s,%s,%s,%s,%s,%s,%s\n", $1, $2, $3, $4, $5, $6, $7, $8, $9}' >> $WORKING_DIR/csv/tracks.csv
 
#Ahora vamos a agregar las comillas de cierre que falten a los nombres de artista, album y track.
#(Esto pasa porque hay artistas, albumes y tracks que tienen comas en su nombre)

#Artists
cat $WORKING_DIR/csv/artists.csv | sed 's/.$//' | sed 's/$/"/' | sed '1s/.$//' > $WORKING_DIR/csv/artists_mon.csv
#Albums
cat $WORKING_DIR/csv/albums.csv | sed 's/.$//' | sed 's/$/"/' | sed '1s/.$//' > $WORKING_DIR/csv/albums_mon.csv
#Tracks
cat $WORKING_DIR/csv/tracks.csv | sed 's/.$//' | sed 's/$/"/' | sed '1s/.$//' > $WORKING_DIR/csv/tracks_mon.csv

#Eliminamos los csv auxiliares
rm $WORKING_DIR/csv/artists.csv
rm $WORKING_DIR/csv/albums.csv
rm $WORKING_DIR/csv/tracks.csv

echo "Obtenemos archivos csv para Neo4j"

echo 'followers,genre,artist_id,popularity,namee' > $WORKING_DIR/csv/artists.csv
echo 'artist_id,album_id,release_date,total_tracks,namee' > $WORKING_DIR/csv/albums.csv
echo 'album_id,artist_id,disc_number,duration_ms,explicit,track_id,popularity,track_number,namee' > $WORKING_DIR/csv/tracks.csv 

echo 'Convirtiendo artistas'
sleep 1
jq -r '[.followers.total, .genres, .id, .popularity, .name] | @csv' $WORKING_DIR/data_spotify/artists_neo.json | awk -F, '{printf "%s,%s,%s,%s,%s\n", $1, $2, $3, $4, $5}' >> $WORKING_DIR/csv/artists.csv
echo 'Convirtiendo albums'
sleep 1
jq -r '[.artists.id, .id, .release_date, .total_tracks, .name] | @csv' $WORKING_DIR/data_spotify/albums_neo.json | awk -F, '{printf "%s,%s,%s, %s,%s\n", $1, $2, $3, $4, $5}' >> $WORKING_DIR/csv/albums.csv
echo 'Convirtiendo tracks'
sleep 1
jq -r '[.album.id, .artists.id, .disc_number, .duration_ms, .explicit, .id, .popularity, .track_number, .name] | @csv' $WORKING_DIR/data_spotify/tracks_neo.json | awk -F, '{printf "%s,%s,%s,%s,%s,%s,%s,%s,%s\n", $1, $2, $3, $4, $5, $6, $7, $8, $9}' >> $WORKING_DIR/csv/tracks.csv
 
#Ahora vamos a agregar las comillas de cierre que falten a los nombres de artista, album y track.
#(Esto pasa porque hay artistas, albumes y tracks que tienen comas en su nombre)

#Artists
cat $WORKING_DIR/csv/artists.csv | sed 's/.$//' | sed 's/$/"/' | sed '1s/.$//' > $WORKING_DIR/csv/artists_neo.csv
#Albums
cat $WORKING_DIR/csv/albums.csv | sed 's/.$//' | sed 's/$/"/' | sed '1s/.$//' > $WORKING_DIR/csv/albums_neo.csv
#Tracks
cat $WORKING_DIR/csv/tracks.csv | sed 's/.$//' | sed 's/$/"/' | sed '1s/.$//' > $WORKING_DIR/csv/tracks_neo.csv

#Eliminamos los csv auxiliares
rm $WORKING_DIR/csv/artists.csv
rm $WORKING_DIR/csv/albums.csv
rm $WORKING_DIR/csv/tracks.csv
