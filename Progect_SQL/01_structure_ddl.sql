--Базовые запросы; создаём типы данных и сами таблицы--
DROP TABLE IF EXISTS photos CASCADE;
DROP TABLE IF EXISTS car_sessions CASCADE;
DROP TABLE IF EXISTS cars CASCADE;
DROP TABLE IF EXISTS users CASCADE;
DROP TYPE IF EXISTS session_status CASCADE;
DROP TYPE IF EXISTS photo_purpose CASCADE;
DROP TYPE IF EXISTS user_role CASCADE;

CREATE TYPE user_role AS ENUM ('driver', 'manager', 'admin', 'blocked');
CREATE TYPE session_status AS ENUM ('open', 'closed', 'flagged');
CREATE TYPE photo_purpose AS ENUM ('car', 'odometer', 'incident', 'checkup');


CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    tg_id BIGINT NOT NULL UNIQUE,
    full_name VARCHAR(128),
    role user_role DEFAULT 'driver',
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE cars (
    id SERIAL PRIMARY KEY,
    plate VARCHAR(20) NOT NULL UNIQUE,
    make VARCHAR(50) NOT NULL,
    model VARCHAR(50) NOT NULL,
    current_odo REAL DEFAULT 0.0 CHECK (current_odo >= 0),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE car_sessions (
    id SERIAL PRIMARY KEY,
    car_id INTEGER NOT NULL REFERENCES cars(id) ON DELETE RESTRICT,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE RESTRICT,
    
    started_at TIMESTAMPTZ DEFAULT NOW(),
    ended_at TIMESTAMPTZ,
    
    start_odo REAL NOT NULL,
    end_odo REAL,
    
    status session_status DEFAULT 'open',
    
    -- Constraint: Конечный пробег не может быть меньше начального
    CONSTRAINT check_mileage_validity CHECK (
        (end_odo IS NULL) OR (end_odo >= start_odo)
    )
);

CREATE TABLE photos (
    id SERIAL PRIMARY KEY,
    session_id INTEGER REFERENCES car_sessions(id) ON DELETE CASCADE,
    car_id INTEGER NOT NULL REFERENCES cars(id) ON DELETE CASCADE,
    storage_uri TEXT NOT NULL,
    purpose photo_purpose NOT NULL,
    taken_at TIMESTAMPTZ DEFAULT NOW()
);
