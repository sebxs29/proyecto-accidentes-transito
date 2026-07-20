CREATE SCHEMA IF NOT EXISTS staging;


CREATE TABLE staging.siniestros_limpios (
    mes TEXT,
    dia TEXT,
    hora TEXT,
    provincia TEXT,
    canton TEXT,
    zona TEXT,
    num_fallecido INTEGER,
    num_lesionado INTEGER,
    total_victimas INTEGER,
    clase TEXT,
    causa TEXT,
    mes_num SMALLINT,
    dia_semana_num SMALLINT,
    hora_num SMALLINT,
    franja_horaria TEXT,
    anio SMALLINT,
    fecha_mes DATE,
    total_victimas_calculado INTEGER,
    total_victimas_inconsistente BOOLEAN,
    id_siniestro BIGINT PRIMARY KEY
);


CREATE TABLE staging.vehiculos_limpios (
    id_vehiculo BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    provincia TEXT,
    marca TEXT,
    clase TEXT,
    pasajeros DOUBLE PRECISION,
    tonelaje DOUBLE PRECISION,
    combustible TEXT,
    modelo TEXT,
    servicio TEXT,
    estratone TEXT,
    estrapasajero TEXT,
    anio SMALLINT
);


CREATE TABLE staging.precipitacion_limpia (
    id_precipitacion BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    estacion TEXT,
    nombreestacion TEXT,
    longitud2 DOUBLE PRECISION,
    latitud2 DOUBLE PRECISION,
    altitud DOUBLE PRECISION,
    anio SMALLINT,
    mes TEXT,
    precipitacion DOUBLE PRECISION,
    mes_num SMALLINT
);


CREATE TABLE staging.temperatura_limpia (
    id_temperatura BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    estacion TEXT,
    nombreestacion TEXT,
    longitud2 DOUBLE PRECISION,
    latitud2 DOUBLE PRECISION,
    altitud DOUBLE PRECISION,
    anio SMALLINT,
    mes TEXT,
    temperatura DOUBLE PRECISION,
    mes_num SMALLINT
);


CREATE TABLE staging.fallecidos_limpios (
    id_fallecido BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    no_ TEXT,
    genero_de_la_victima TEXT,
    estado_civil_de_la_victima TEXT,
    condicion TEXT,
    fecha_de_muerte_victima DATE,
    tipo_de_accidente TEXT,
    fecha_siniestro DATE,
    canton TEXT,
    provincia TEXT,
    fecha_de_creacion_de_proteccion_de_fallecidos DATE,
    anio SMALLINT,
    mes_num SMALLINT
);


CREATE TABLE staging.poblacion_limpia (
    id_poblacion BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    provincia TEXT,
    canton TEXT,
    parroquia TEXT,
    poblacion BIGINT,
    superficie_de_la_parroquia_km2_ DOUBLE PRECISION,
    densidad_poblacional DOUBLE PRECISION
);