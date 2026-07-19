USE proyecto_accidentes;

-- TABLA: clima
CREATE TABLE clima (
    id_clima INT NOT NULL,
    estacion VARCHAR(255),
    nombreestacion VARCHAR(255),
    anio INT,
    mes VARCHAR(255),
    temperatura DOUBLE,
    mes_num INT,
    precipitacion DOUBLE,
    PRIMARY KEY (id_clima)
);

-- TABLA: fechas
CREATE TABLE fechas (
    id_fecha INT NOT NULL,
    anio INT,
    mes VARCHAR(255),
    mes_num INT,
    dia VARCHAR(255),
    dia_semana_num INT,
    fecha_mes VARCHAR(255),
    PRIMARY KEY (id_fecha)
);

-- TABLA: poblacion
CREATE TABLE poblacion (
    id_poblacion INT NOT NULL,
    provincia VARCHAR(255),
    canton VARCHAR(255),
    parroquia VARCHAR(255),
    poblacion DOUBLE,
    densidad_poblacional DOUBLE,
    PRIMARY KEY (id_poblacion)
);

-- TABLA: ubicacion
CREATE TABLE ubicacion (
    id_ubicacion INT NOT NULL,
    provincia VARCHAR(255),
    canton VARCHAR(255),
    zona VARCHAR(255),
    PRIMARY KEY (id_ubicacion)
);

-- TABLA: vehiculos
CREATE TABLE vehiculos (
    id_vehiculo INT NOT NULL,
    provincia VARCHAR(255),
    anio INT,
    total_matriculados INT,
    PRIMARY KEY (id_vehiculo)
);

-- TABLA: fact_siniestros

CREATE TABLE fact_siniestros (
    id_siniestro INT NOT NULL,

    hora VARCHAR(255),

    num_fallecido INT,
    num_lesionado INT,
    total_victimas INT,

    clase VARCHAR(255),
    causa VARCHAR(255),
    franja_horaria VARCHAR(255),

    id_fecha INT NOT NULL,
    id_ubicacion INT NOT NULL,
    id_poblacion INT NOT NULL,

    PRIMARY KEY (id_siniestro),

    CONSTRAINT fk_fact_fecha
        FOREIGN KEY (id_fecha)
        REFERENCES fechas(id_fecha),

    CONSTRAINT fk_fact_ubicacion
        FOREIGN KEY (id_ubicacion)
        REFERENCES ubicacion(id_ubicacion),

    CONSTRAINT fk_fact_poblacion
        FOREIGN KEY (id_poblacion)
        REFERENCES poblacion(id_poblacion)
);