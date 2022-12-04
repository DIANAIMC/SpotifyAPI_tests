#! /bin/bash

WORKING_DIR=$1

echo 'followers,genre,artist_id,name,popularity' > $WORKING_DIR/csv/artists.csv
echo 'artist_id,album_id,name,release_date,total_tracks' > $WORKING_DIR/csv/albums.csv
echo 'album_id,artist_id,disc_number,duration_ms,explicit,track_id,name,popularity,track_number' > $WORKING_DIR/csv/tracks.csv 

echo 'Convirtiendo artistas'
sleep 1
jq -r '[.followers.total, .genres, .id, .popularity, .name] | @csv' $WORKING_DIR/data_spotify/artists.json | awk -F, '{printf "%s,%s,%s,%s,%s\n", $1, $2, $3, $4, $5}' >> $WORKING_DIR/csv/artists.csv
echo 'Convirtiendo albums'
sleep 1
jq -r '[.artists.id, .id, .release_date, .total_tracks, .name] | @csv' $WORKING_DIR/data_spotify/albums.json | awk -F, '{printf "%s,%s,%s, %s,%s\n", $1, $2, $3, $4, $5}' >> $WORKING_DIR/csv/albums.csv
echo 'Convirtiendo tracks'
sleep 1
jq -r '[.album.id, .artists.id, .disc_number, .duration_ms, .explicit, .id, .popularity, .track_number, .name] | @csv' $WORKING_DIR/data_spotify/tracks.json | awk -F, '{printf "%s,%s,%s,%s,%s,%s,%s,%s,%s\n", $1, $2, $3, $4, $5, $6, $7, $8, $9}' >> $WORKING_DIR/csv/tracks.csv
