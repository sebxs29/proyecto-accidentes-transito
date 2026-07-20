SELECT 'siniestros' AS tabla, COUNT(*) AS registros
FROM staging.siniestros_limpios

UNION ALL

SELECT 'vehiculos', COUNT(*)
FROM staging.vehiculos_limpios

UNION ALL

SELECT 'precipitacion', COUNT(*)
FROM staging.precipitacion_limpia

UNION ALL

SELECT 'temperatura', COUNT(*)
FROM staging.temperatura_limpia

UNION ALL

SELECT 'fallecidos', COUNT(*)
FROM staging.fallecidos_limpios

UNION ALL

SELECT 'poblacion', COUNT(*)
FROM staging.poblacion_limpia;