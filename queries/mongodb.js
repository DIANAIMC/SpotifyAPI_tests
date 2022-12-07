// Query para encontrar cuántas canciones se hacen cada mes
// Resulta que en diciembre es cuando más canciones salen
db.tracks.aggregate([
   {
      $match: {
         $expr: {$eq: [{$strLenCP: '$album.release_date'}, 10]}
      }
   },
   {
      $project: {
         _id: 0,
         'mes': {$month: { $toDate: '$album.release_date' }}
      }
   },
   {
      $group: {
         _id:'$mes',
         count: {$count: {}}
      }
   },
   {
      $project: {
         'mes': '$_id',
         'count': 1,
         _id:0
      }
   },
   {
      $sort: {
         'count': -1
      }
   }
]);

// Query para encontrar el promedio de followers que tiene cada género y lo ordenamos.
// El género "barbadian pop" fue el que más se escuchó.
db.artists.aggregate([
    { $unwind : '$genres' },
    { $match: { genres: { $in: [/pop/,/rock/,/r&b/,/rap/,/electronic/,/hip hop/,/country/,/latin/,/indie/,/soul/,
                                /reggaeton/,/metal/,/reggae/,/salsa/,/trap/,/banda/,/alt/,/grunge/,/funk/] } } },
    { $group:{_id: "$genres", prom_followers:{ $avg: "$followers.total" } } },
    { $project:{_id:0, "genero":"$_id", prom_followers:{ $round: ["$prom_followers", 2] }}}
]).sort({"prom_followers":-1});

//Query para encontrar si hay una relación entre duración de una canción y la popularidad de la canción
db.tracks.aggregate([
    {$project:{name:1,popularity:1,duration_ms:1,_id:0}},
    {$group:{_id:"$popularity",avgTime:{$avg:"$duration_ms"}}},
    {$project:{_id : 0, "popularity" : "$_id",avgTime:1}},
    {$sort:{avgTime:-1}},
    {$limit:10},
    {$group: {_id: null,averageAvgTime: { $avg: "$avgTime" },averagePopularity: { $avg:"$popularity" }}}])
