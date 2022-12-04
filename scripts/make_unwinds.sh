#! /bin/bash

# PARA MONET

# Hacemos el unwind de los artistas sobre los géneros
docker exec -it spotify mongosh --quiet \
--eval 'use spotify' \
--eval 'db.artists.aggregate([{$unwind:"$genres"}, {$project:{_id:0}}, {$out:"uw_artists_mon"}])'

# Hacemos el unwind de albums sobre available_markets
docker exec -it spotify mongosh --quiet \
--eval 'use spotify' \
--eval 'db.albums.aggregate([{$unwind:"$available_markets"}, {$project:{_id:0}}, {$out:"uw_albums_mon"}])'

# Hacemos el unwind de tracks sobre available_markets
docker exec -it spotify mongosh --quiet \
--eval 'use spotify' \
--eval 'db.tracks.aggregate([{$unwind:"$available_markets"}, {$project: {_id:0}}, {$out:"uw_tracks_mon"}])'

# ------------------------------------------------------------------------------------------

# PARA NEO4J

# Hacemos el unwind de los artistas sobre los géneros
docker exec -it spotify mongosh --quiet \
--eval 'use spotify' \
--eval 'db.artists.aggregate([{$unwind:"$genres"}, {$project:{_id:0}}, {$out:"uw_artists_neo"}])' 

# Hacemos el unwind de albums sobre available_markets
docker exec -it spotify mongosh --quiet \
--eval 'use spotify' \
--eval 'db.albums.aggregate([{$unwind:"$artists"}, {$project:{_id:0}}, {$out:"uw_albums_neo"}])'

# Hacemos el unwind de tracks sobre available_markets
docker exec -it spotify mongosh --quiet \
--eval 'use spotify' \
--eval 'db.tracks.aggregate([{$unwind:"$artists"}, {$project: {_id:0}}, {$out:"uw_tracks_neo"}])' 

