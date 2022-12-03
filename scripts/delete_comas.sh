#! /bin/bash

docker exec -it spotify mongosh \
--quiet \
--eval 'db.uw_artists.updateMany({name:/.*/},{ $set: { name: { $replace: [ /,/g, "" ] }}})' #\
# > /dev/null

docker exec -it spotify mongosh \
--quiet \
--eval 'db.uw_albums.updateMany({name:/.*/},{ $set: { name: { $replace: [ /,/g, "" ] }}})' # \
# > /dev/null

docker exec -it spotify mongosh \
--quiet \
--eval 'db.uw_tracks.updateMany({name:/.*/},{ $set: { name: { $replace: [ /,/g, "" ] }}})' # \
# > /dev/null