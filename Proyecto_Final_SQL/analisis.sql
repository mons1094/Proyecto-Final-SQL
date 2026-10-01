-- ============================================================
-- PROYECTO CAPSTONE: ANÁLISIS EXPLORATORIO DE DATOS (EDA)
-- Archivo: analisis.sql
-- ============================================================

-- ------------------------------------------------------------
-- SECCIÓN 1: LIMPIEZA DE DATOS Y GESTIÓN DE NULOS
-- ------------------------------------------------------------
-- Propósito: Garantizar la integridad del análisis eliminando registros 
-- inconsistentes y estandarizando valores nulos en columnas clave mediante COALESCE.

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
    COALESCE(payment, 'desconocido') AS metodo_pago,
    COALESCE(pickup_zone, 'Zona Desconocida') AS zona_origen,
    COALESCE(dropoff_zone, 'Zona Desconocida') AS zona_destino,
    COALESCE(pickup_borough, 'Distrito Desconocido') AS distrito_origen,
    COALESCE(dropoff_borough, 'Distrito Desconocido') AS distrito_destino
FROM taxis
WHERE distance > 0 AND total > 0;


-- ------------------------------------------------------------
-- SECCIÓN 2: CONSULTAS DE ANÁLISIS DE NEGOCIO
-- ------------------------------------------------------------

-- CONSULTA 1: Facturación y propinas por método de pago (Uso de JOIN)
-- Propósito de negocio: Evaluar qué canales de pago generan mayores ingresos reales 
-- y cuál es la tasa de retorno de propinas para los conductores al cruzar con la tabla catálogo.

SELECT 
    tp.metodo AS metodo_pago,
    COUNT(*) AS total_viajes,
    ROUND(SUM(v.total_pagado), 2) AS facturacion_total,
    ROUND(AVG(v.propina), 2) AS propina_promedio
FROM v_taxis_limpios v
JOIN tipos_pago tp ON LOWER(v.metodo_pago) = LOWER(tp.metodo)
GROUP BY tp.metodo
ORDER BY facturacion_total DESC;


-- CONSULTA 2: Top 5 distritos con mayor demanda y distancia promedio (GROUP BY + Funciones de agregación)
-- Propósito de negocio: Identificar los hubs urbanos con mayor concentración de viajes 
-- para optimizar la redistribución geográfica de la flota de taxis.

SELECT 
    distrito_origen,
    COUNT(*) AS total_viajes,
    ROUND(AVG(distancia_millas), 2) AS distancia_promedio_millas,
    ROUND(SUM(total_pagado), 2) AS ingresos_totales
FROM v_taxis_limpios
GROUP BY distrito_origen
ORDER BY total_viajes DESC
LIMIT 5;


-- CONSULTA 3: Clasificación y rentabilidad por rango de distancia (Uso de CASE)
-- Propósito de negocio: Categorizar las trayectorias (viajes cortos, medianos o largos) 
-- para entender el perfil tarifario y ajustar precios base según el tipo de recorrido.

SELECT 
    CASE 
        WHEN distancia_millas < 2.0 THEN 'Viaje Corto (< 2 millas)'
        WHEN distancia_millas BETWEEN 2.0 AND 7.0 THEN 'Viaje Mediano (2-7 millas)'
        ELSE 'Viaje Largo (> 7 millas)'
    END AS categoria_distancia,
    COUNT(*) AS cantidad_viajes,
    ROUND(AVG(total_pagado), 2) AS tarifa_promedio,
    ROUND(AVG(propina), 2) AS propina_promedio
FROM v_taxis_limpios
GROUP BY 
    CASE 
        WHEN distancia_millas < 2.0 THEN 'Viaje Corto (< 2 millas)'
        WHEN distancia_millas BETWEEN 2.0 AND 7.0 THEN 'Viaje Mediano (2-7 millas)'
        ELSE 'Viaje Largo (> 7 millas)'
    END
ORDER BY cantidad_viajes DESC;


-- CONSULTA 4: Ranking de zonas con mayor recaudación por distrito (Window Function - RANK)
-- Propósito de negocio: Obtener las zonas específicas más rentables dentro de cada distrito 
-- mediante funciones de ventana para priorizar la asignación de choferes en horarios pico.

WITH FacturacionPorZona AS (
    SELECT 
        distrito_origen,
        zona_origen,
        COUNT(*) AS viajes,
        SUM(total_pagado) AS ingresos_zona
    FROM v_taxis_limpios
    WHERE distrito_origen <> 'Distrito Desconocido'
    GROUP BY distrito_origen, zona_origen
)
SELECT 
    distrito_origen,
    zona_origen,
    viajes,
    ROUND(ingresos_zona, 2) AS ingresos_totales,
    RANK() OVER (PARTITION BY distrito_origen ORDER BY ingresos_zona DESC) AS ranking_en_distrito
FROM FacturacionPorZona
ORDER BY distrito_origen, ranking_en_distrito;
