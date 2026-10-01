-- Creación de la base de datos (ejecutar por separado si no está creada)
CREATE TABLE taxis (
    id SERIAL PRIMARY KEY,
    pickup_datetime TIMESTAMP,
    dropoff_datetime TIMESTAMP,
    passenger_count INTEGER,
    trip_distance NUMERIC,
    fare_amount NUMERIC,
    tip_amount NUMERIC,
    total_amount NUMERIC,
    car_color VARCHAR(50),
    payment_type VARCHAR(50)
);

-- CREATE DATABASE capstone_project;

-- Tabla de catálogo para tipos de pago
CREATE TABLE IF NOT EXISTS tipos_pago (
    id SERIAL PRIMARY KEY,
    metodo VARCHAR(50) NOT NULL
);

-- Insertar métodos de pago por defecto
INSERT INTO tipos_pago (metodo) VALUES 
('Efectivo'), 
('Tarjeta de Crédito'), 
('Tarjeta de Débito'), 
('App Mobile');

-- Tabla principal de registros de viajes de taxis
CREATE TABLE IF NOT EXISTS taxis (
    id SERIAL PRIMARY KEY,
    pickup_datetime TIMESTAMP NOT NULL,
    dropoff_datetime TIMESTAMP NOT NULL,
    passenger_count INTEGER,
    trip_distance NUMERIC(10, 2),
    fare_amount NUMERIC(10, 2),
    tip_amount NUMERIC(10, 2),
    total_amount NUMERIC(10, 2),
    car_color VARCHAR(50),
    payment_type_id INTEGER REFERENCES tipos_pago(id)
);

