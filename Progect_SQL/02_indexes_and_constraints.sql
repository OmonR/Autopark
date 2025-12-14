--частичные индексы (предотвращение коллизии, поиск пользователей, история поездок)--

CREATE UNIQUE INDEX index_one_active_session_per_car 
ON car_sessions (car_id) 
WHERE status = 'open';

CREATE INDEX index_users_tg_id ON users(tg_id);

CREATE INDEX index_sessions_user_history 
ON car_sessions (user_id, started_at DESC);
