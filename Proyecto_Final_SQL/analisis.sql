-- ============================================================
-- PROYECTO CAPSTONE: ANÁLISIS DE DATOS DE TAXIS
-- ARCHIVO: analisis.sql
-- ============================================================

-- ------------------------------------------------------------
-- SECCIÓN 1: LIMPIEZA DE DATOS Y GESTIÓN DE NULOS
-- ------------------------------------------------------------

-- Vista limpia de datos reemplazando nulos en montos o zonas no registradas
CREATE OR REPLACE VIEW v_taxis_limpios AS
SELECT 
    pickup,
    dropoff,
    COALESCE(passengers, 1) AS pasajeros,
    COALESCE(distance, 0) AS distancia_millas,
    COALESCE(fare, 0) AS tarifa_base,
    COALESCE(tip, 0) AS propina,
    COALESCE(tolls, 0) AS peajes,
    COALESCE(total, fare + tip + tolls) AS total_pagado,
    COALESCE(color, 'Sin Especificar') AS color_auto,
    COALESCE(payment, 'Desconocido') AS metodo_pago,
    COALESCE(pickup_zone, 'Zona Desconocida') AS zona_origen,
    COALESCE(dropoff_zone, 'Zona Desconocida') AS zona_destino,
    COALESCE(pickup_borough, 'Distrito Desconocido') AS distrito_origen,
    COALESCE(dropoff_borough, 'Distrito Desconocido') AS distrito_destino
FROM taxis
WHERE distance > 0 AND total > 0;


-- ------------------------------------------------------------
-- SECCIÓN 2: CONSULTAS DE ANÁLISIS DE NEGOCIO
-- ------------------------------------------------------------

-- PREGUNTA 1: ¿Cuál es la facturación total y la propina promedio según el método de pago?
-- Objetivo: Identificar qué métodos de pago generan mayores ingresos y mejores propinas para los conductores.
SELECT 
    metodo_pago,
    COUNT(*) AS total_viajes,
    ROUND(SUM(total_pagado), 2) AS facturacion_total,
    ROUND(AVG(propina), 2) AS propina_promedio,
    ROUND(AVG(propina / NULLIF(total_pagado, 0)) * 100, 2) AS porcentaje_propina_promedio
FROM v_taxis_limpios
GROUP BY metodo_pago
ORDER BY facturacion_total DESC;


-- PREGUNTA 2: ¿Cuáles son los 5 distritos (boroughs) con mayor demanda de viajes y cuál es la distancia media recorrida?
-- Objetivo: Determinar las zonas de mayor tráfico para optimizar la distribución de la flota.
SELECT 
    distrito_origen,
    COUNT(*) AS total_viajes,
    ROUND(AVG(distancia_millas), 2) AS distancia_promedio_millas,
    ROUND(SUM(total_pagado), 2) AS ingresos_totales
FROM v_taxis_limpios
GROUP BY distrito_origen
ORDER BY total_viajes DESC
LIMIT 5;


-- PREGUNTA 3: ¿Cómo afecta la duración del viaje y la distancia al total cobrado por color de unidad?
-- Objetivo: Evaluar si los taxis amarillos o verdes tienen trayectos más largos o rentables.
SELECT 
    color_auto,
    COUNT(*) AS cantidad_viajes,
    ROUND(AVG(EXTRACT(EPOCH FROM (dropoff - pickup)) / 60), 2) AS duracion_promedio_minutos,
    ROUND(AVG(distancia_millas), 2) AS distancia_promedio_millas,
    ROUND(AVG(total_pagado), 2) AS tarifa_promedio
FROM v_taxis_limpios
GROUP BY color_auto;