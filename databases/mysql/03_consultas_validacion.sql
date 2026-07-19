USE proyecto_accidentes;

-- VALIDAR CANTIDAD DE REGISTROS

SELECT COUNT(*) AS total_fechas
FROM fechas;

SELECT COUNT(*) AS total_ubicaciones
FROM ubicacion;

SELECT COUNT(*) AS total_poblacion
FROM poblacion;

SELECT COUNT(*) AS total_clima
FROM clima;

SELECT COUNT(*) AS total_vehiculos
FROM vehiculos;

SELECT COUNT(*) AS total_siniestros
FROM fact_siniestros;

-- VISUALIZAR LOS PRIMEROS REGISTROS

SELECT * FROM fechas
LIMIT 10;

SELECT * FROM ubicacion
LIMIT 10;

SELECT * FROM poblacion
LIMIT 10;

SELECT * FROM clima
LIMIT 10;

SELECT * FROM vehiculos
LIMIT 10;

SELECT * FROM fact_siniestros
LIMIT 10;

-- VALIDAR QUE NO EXISTAN IDS DUPLICADOS

SELECT id_fecha, COUNT(*)
FROM fechas
GROUP BY id_fecha
HAVING COUNT(*) > 1;

SELECT id_ubicacion, COUNT(*)
FROM ubicacion
GROUP BY id_ubicacion
HAVING COUNT(*) > 1;

SELECT id_poblacion, COUNT(*)
FROM poblacion
GROUP BY id_poblacion
HAVING COUNT(*) > 1;

SELECT id_clima, COUNT(*)
FROM clima
GROUP BY id_clima
HAVING COUNT(*) > 1;

SELECT id_vehiculo, COUNT(*)
FROM vehiculos
GROUP BY id_vehiculo
HAVING COUNT(*) > 1;

SELECT id_siniestro, COUNT(*)
FROM fact_siniestros
GROUP BY id_siniestro
HAVING COUNT(*) > 1;

-- VALIDAR RELACIONES (FOREIGN KEYS)

SELECT
    fs.id_siniestro,
    f.anio,
    f.mes,
    u.provincia,
    p.canton
FROM fact_siniestros fs
INNER JOIN fechas f
    ON fs.id_fecha = f.id_fecha
INNER JOIN ubicacion u
    ON fs.id_ubicacion = u.id_ubicacion
INNER JOIN poblacion p
    ON fs.id_poblacion = p.id_poblacion
LIMIT 20;

-- CONSULTAS ANALÍTICAS

-- Total de víctimas registradas
SELECT
    SUM(total_victimas) AS total_victimas
FROM fact_siniestros;

-- Total de fallecidos
SELECT
    SUM(num_fallecido) AS total_fallecidos
FROM fact_siniestros;

-- Total de lesionados
SELECT
    SUM(num_lesionado) AS total_lesionados
FROM fact_siniestros;

-- Accidentes por clase
SELECT
    clase,
    COUNT(*) AS total
FROM fact_siniestros
GROUP BY clase
ORDER BY total DESC;

-- Accidentes por causa
SELECT
    causa,
    COUNT(*) AS total
FROM fact_siniestros
GROUP BY causa
ORDER BY total DESC;

-- Accidentes por franja horaria
SELECT
    franja_horaria,
    COUNT(*) AS total
FROM fact_siniestros
GROUP BY franja_horaria
ORDER BY total DESC;

-- Accidentes por año
SELECT
    f.anio,
    COUNT(*) AS total_accidentes
FROM fact_siniestros fs
INNER JOIN fechas f
ON fs.id_fecha = f.id_fecha
GROUP BY f.anio;

-- Accidentes por provincia
SELECT
    u.provincia,
    COUNT(*) AS total_accidentes
FROM fact_siniestros fs
INNER JOIN ubicacion u
ON fs.id_ubicacion = u.id_ubicacion
GROUP BY u.provincia
ORDER BY total_accidentes DESC;

-- Población por provincia
SELECT
    provincia,
    SUM(poblacion) AS total_poblacion
FROM poblacion
GROUP BY provincia
ORDER BY total_poblacion DESC;

-- Vehículos matriculados por provincia
SELECT
    provincia,
    SUM(total_matriculados) AS total_matriculados
FROM vehiculos
GROUP BY provincia
ORDER BY total_matriculados DESC;