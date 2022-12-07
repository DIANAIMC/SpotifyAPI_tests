-- Encontrar el promedio de popularidad por mercado y dependiendo de si son explícitos o no
SELECT a.available_market, explicit,  AVG(popularity) as mean_pop, COUNT(popularity) as total_n
FROM album a
JOIN track t ON a.available_market = t.available_market AND a.album_id = t.album_id
GROUP BY a.available_market, explicit
ORDER BY a.available_market, explicit ASC;

-- Muestra los mercados con menor número de albums y a su vez muestra el promedio de canciones por mercado
SELECT a.available_market, COUNT(*) as num_albums,
AVG(a.total_tracks) AS total_tracks
FROM album a
GROUP BY a.available_market
ORDER BY num_albums ASC, total_tracks ASC
LIMIT 10;
