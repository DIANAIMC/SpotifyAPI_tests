// Query para ver con quiénes han hecho colaboraciones los artistas
match (ar1:Artist)<--(:Track)-->(:Album)<--(:Track)-->(ar2:Artist) 
where ar1.name <> ar2.name 
with ar2.name as artista, collect(distinct(ar1.name)) as colaboraciones
return artista, size(colaboraciones) as total_colabs, colaboraciones
order by total_colabs desc;

//A continuación estamos consultando las 10 canciones en las cuales colaboraron más artistas. 
MATCH (t:Track)<-[ta:TRACK_OF_ARTIST]->(a:Artist) 
RETURN t.name as track_name, t.popularity, 
COUNT(DISTINCT a.name) as num_artists
ORDER BY num_artists DESC
LIMIT 10;
