--GROUP BY + HAVING--
-- топ 10 водителей по пробегу
SELECT 
    u.full_name,
    COUNT(s.id) AS trips_total,
    SUM(s.end_odo - s.start_odo) AS total_km
FROM car_sessions s
JOIN users u ON s.user_id = u.id
WHERE s.status = 'closed'
GROUP BY u.full_name
HAVING SUM(s.end_odo - s.start_odo) > 0
ORDER BY total_km DESC
LIMIT 10;

--MATERIALIZED VIEW--
-- доска почета
CREATE MATERIALIZED VIEW mv_leaderboard_cache AS
SELECT 
    u.id AS user_id,
    u.full_name,
    SUM(s.end_odo - s.start_odo) AS total_km
FROM users u
JOIN car_sessions s ON u.id = s.user_id
WHERE s.status = 'closed'
GROUP BY u.id, u.full_name
ORDER BY total_km DESC;

-- индекс на MatView 
CREATE INDEX index_mv_leaderboard ON mv_leaderboard_cache(total_km DESC);

-- получение данных из кэша
SELECT * FROM mv_leaderboard_cache 
ORDER BY total_km DESC 
LIMIT 100;

-- обновление кэша
REFRESH MATERIALIZED VIEW CONCURRENTLY mv_leaderboard_cache;
