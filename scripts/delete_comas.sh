#! /bin/bash

docker exec -it spotify mongosh \
--quiet \
--eval 'use spotify' \
--eval 'db.uw_tracks.deleteMany({ "name": { $regex: /,+/ } })' \
# > /dev/null

docker exec -it spotify mongosh \
--quiet \
--eval 'use spotify' \
--eval 'db.uw_albums.deleteMany({ "name": { $regex: /,+/ } })' \
# > /dev/null

docker exec -it spotify mongosh \
--quiet \
--eval 'use spotify' \
--eval 'db.uw_tracks.deleteMany({ "name": { $regex: /,+/ } })' \
# > /dev/null
