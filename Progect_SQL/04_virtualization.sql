--VIEW--
-- скрывает JOIN'ы и вычисляет длительность поездки.
CREATE OR REPLACE VIEW v_active_sessions_details AS
SELECT 
    s.id AS session_id,
    u.full_name AS driver_name,
    c.plate,
    c.make || ' ' || c.model AS car_model,
    s.started_at,
    (NOW() - s.started_at) AS duration_interval
FROM car_sessions s
JOIN users u ON s.user_id = u.id
JOIN cars c ON s.car_id = c.id
WHERE s.status = 'open';

-- пример безопасного использования view
SELECT * FROM v_active_sessions_details
ORDER BY started_at DESC
LIMIT 50;

--CTE--
-- поиск машин, которые проехали больше 100 км за поездку
WITH long_trips AS (
    SELECT 
        car_id, 
        (end_odo - start_odo) as distance
    FROM car_sessions
    WHERE status = 'closed'
)
SELECT 
    c.plate, 
    lt.distance 
FROM long_trips lt
JOIN cars c ON lt.car_id = c.id
WHERE lt.distance > 100
ORDER BY lt.distance DESC
LIMIT 20;

--TEMP TABLE--
-- отчет, который нужен только в рамках текущей сессии администратора
CREATE TEMP TABLE temp_driver_report AS
SELECT user_id, COUNT(*) as trip_count 
FROM car_sessions 
GROUP BY user_id;

-- получение данных из временной таблицы
SELECT * FROM temp_driver_report
ORDER BY trip_count DESC
LIMIT 100;
