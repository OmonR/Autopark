INSERT INTO users (tg_id, full_name, role) VALUES 
(1001, 'Ivan Ivanov', 'driver'),
(1002, 'Petr Petrov', 'manager'),
(1003, 'Sidor Sidorov', 'driver');

INSERT INTO cars (plate, make, model, current_odo) VALUES 
('B777OP77', 'Toyota', 'Camry', 55000.5),
('P666BY66', 'Kia', 'Rio', 12500.0),
('O055OO55', 'Skoda', 'Octavia', 98000.2);

INSERT INTO car_sessions (car_id, user_id, start_odo, end_odo, status, started_at, ended_at) VALUES
(1, 1, 54000, 54100, 'closed', NOW() - INTERVAL '5 days', NOW() - INTERVAL '5 days' + INTERVAL '2 hours'),
(1, 1, 54100, 54250, 'closed', NOW() - INTERVAL '3 days', NOW() - INTERVAL '3 days' + INTERVAL '3 hours'),
(2, 3, 12000, 12100, 'closed', NOW() - INTERVAL '1 day', NOW() - INTERVAL '1 day' + INTERVAL '1 hour');

INSERT INTO car_sessions (car_id, user_id, start_odo, status, started_at) VALUES
(3, 1, 98000.2, 'open', NOW());
