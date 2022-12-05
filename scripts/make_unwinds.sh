#! /bin/bash

# PARA MONET

echo "Unwinds para Monet:"

echo -e "\n\tArtists -> géneros"
# Hacemos el unwind de los artistas sobre los géneros
docker exec -it spotify mongosh --quiet \
--eval 'use spotify' \
--eval 'db.artists.aggregate([{$unwind:"$genres"}, {$project:{_id:0}}, {$out:"uw_artists_mon"}])'

echo -e "\tAlbums -> 'available markets'"
# Hacemos el unwind de albums sobre available_markets
docker exec -it spotify mongosh --quiet \
--eval 'use spotify' \
--eval 'db.albums.aggregate([{$unwind:"$available_markets"}, {$project:{_id:0}}, {$out:"uw_albums_mon"}])'

echo -e "\tTracks -> 'available markets'"
# Hacemos el unwind de tracks sobre available_markets
docker exec -it spotify mongosh --quiet \
--eval 'use spotify' \
--eval 'db.tracks.aggregate([{$unwind:"$available_markets"}, {$project: {_id:0}}, {$out:"uw_tracks_mon"}])'

# ------------------------------------------------------------------------------------------

# PARA NEO4J

echo -e "\nUnwinds para Neo4j"

echo -e "\n\tArtists -> géneros"

# Hacemos el unwind de los artistas sobre los géneros
docker exec -it spotify mongosh --quiet \
--eval 'use spotify' \
--eval 'db.artists.aggregate([{$project:{_id:0}}, {$out:"uw_artists_neo"}])' 

echo -e "\tAlbums ->  artists"
# Hacemos el unwind de albums sobre available_markets
docker exec -it spotify mongosh --quiet \
--eval 'use spotify' \
--eval 'db.albums.aggregate([{$unwind:"$artists"}, {$project:{_id:0}}, {$out:"uw_albums_neo"}])'

echo -e "\tTracks -> artists"
# Hacemos el unwind de tracks sobre available_markets
docker exec -it spotify mongosh --quiet \
--eval 'use spotify' \
--eval 'db.tracks.aggregate([{$unwind:"$artists"}, {$project: {_id:0}}, {$out:"uw_tracks_neo"}])' 

