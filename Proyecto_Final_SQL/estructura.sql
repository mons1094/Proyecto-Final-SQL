-- ============================================================
-- PROYECTO CAPSTONE: ESTRUCTURA DE LA BASE DE DATOS
-- Archivo: estructura.sql
-- ============================================================

-- 1. Creación de la base de datos (ejecutar previamente si no existe)
-- CREATE DATABASE capstone_project;

-- 2. Tabla de catálogo para Tipos de Pago (permite realizar JOINs en el análisis)
CREATE TABLE IF NOT EXISTS tipos_pago (
    id SERIAL PRIMARY KEY,
    metodo VARCHAR(50) NOT NULL UNIQUE
);

-- Inserción de valores por defecto en el catálogo de pagos
INSERT INTO tipos_pago (metodo) VALUES 
('credit card'), 
('cash'), 
('no charge'), 
('dispute')
ON CONFLICT DO NOTHING;

-- 3. Tabla principal de viajes de taxis
DROP TABLE IF EXISTS taxis;

CREATE TABLE taxis (
    id SERIAL PRIMARY KEY,
    pickup TIMESTAMP NOT NULL,
    dropoff TIMESTAMP NOT NULL,
    passengers INTEGER,
    distance NUMERIC(10, 2),
    fare NUMERIC(10, 2),
    tip NUMERIC(10, 2),
    tolls NUMERIC(10, 2),
    total NUMERIC(10, 2),
    color VARCHAR(50),
    payment VARCHAR(50),
    pickup_zone VARCHAR(100),
    dropoff_zone VARCHAR(100),
    pickup_borough VARCHAR(100),
    dropoff_borough VARCHAR(100)
);

-- 4. Instrucción de carga masiva desde CSV
-- Ajusta la ruta del archivo según tu entorno local
copy taxis(pickup, dropoff, passengers, distance, fare, tip, tolls, total, color, payment, pickup_zone, dropoff_zone, pickup_borough, dropoff_borough) FROM 'C:/Users/escob/OneDrive/Escritorio/taxis_cleaned.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',');

