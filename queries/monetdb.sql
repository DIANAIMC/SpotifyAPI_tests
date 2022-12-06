-- Encontrar el promedio de popularidad por mercado y dependiendo de si son explícitos o no
SELECT a.available_market, explicit,  AVG(popularity) as mean_pop, COUNT(popularity) as total_n
FROM album a
JOIN track t ON a.available_market = t.available_market AND a.album_id = t.album_id
GROUP BY a.available_market, explicit
ORDER BY a.available_market, explicit ASC;