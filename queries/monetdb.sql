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

-- Query para encontrar los TOP 50 albumes del año de la pandemia 
-- basándonos en la popularidad de sus tracks.
SELECT a.name, AVG(t.popularity) as avg_popularity_tracks
FROM album a
JOIN track t ON a.album_id = t.album_id
WHERE SUBSTR(a.release_date, 1, 4) BETWEEN 2020 AND 2021
GROUP BY a.name
ORDER BY avg_popularity_tracks DESC
LIMIT 50;
