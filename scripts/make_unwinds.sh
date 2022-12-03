#! /bin/bash

# Hacemos el unwind de los artistas sobre los géneros
docker exec -it spotify mongosh --quiet \
--eval 'use spotify' \
--eval 'db.artists.aggregate([{$unwind:"$genres"}, {$project:{_id:0}}, {$out:"uw_artists"}])' 

# Hacemos el unwind de albums sobre available_markets
docker exec -it spotify mongosh --quiet \
--eval 'use spotify' \
--eval 'db.albums.aggregate([{$unwind:"$artists"}, {$project:{_id:0}}, {$out:"uw_albums"}])'

# Hacemos el unwind de tracks sobre available_markets
docker exec -it spotify mongosh --quiet \
--eval 'use spotify' \
--eval 'db.tracks.aggregate([{$unwind:"$artists"}, {$project: {_id:0}}, {$out:"uw_tracks"}])' 

./scripts/delete_comas.sh