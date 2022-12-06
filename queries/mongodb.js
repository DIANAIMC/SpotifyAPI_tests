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
