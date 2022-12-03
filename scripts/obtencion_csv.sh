#! /bin/bash

echo 'followers,genre,artist_id,name,popularity' > artists.csv
echo 'artist_id,album_id,name,release_date,total_tracks' > albums.csv
echo 'album_id,artist_id,disc_number,duration_ms,explicit,track_id,name,popularity,track_number' > tracks.csv 

jq -r '[.followers.total, .genres, .id, .name, .popularity] | @csv' artists.json | awk -F, '{printf "%s,%s,%s,%s,%s\n", $1, $2, $3, $4, $5}' >> artists.csv
jq -r '[.artists.id, .id, .name, .release_date, .total_tracks] | @csv' albums.json | awk -F, '{printf "%s,%s,%s, %s,%s\n", $1, $2, $3, $4, $5}' >> albums.csv
jq -r '[.album.id, .artists.id, .disc_number, .duration_ms, .explicit, .id, .name, .popularity, .track_number] | @csv' tracks.json | awk -F, '{printf "%s,%s,%s,%s,%s,%s,%s,%s,%s\n", $1, $2, $3, $4, $5, $6, $7, $8, $9}' >> tracks.csv
