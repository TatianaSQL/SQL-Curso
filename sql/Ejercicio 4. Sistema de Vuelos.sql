-- EJERCICIO 4: SISTEMA DE VUELOS

CREATE DATABASE IF NOT EXISTS vuelos;

USE vuelos;


-- 1. PAISES

CREATE TABLE paises (
    codigo_pais INT AUTO_INCREMENT PRIMARY KEY,
    pais VARCHAR(100) NOT NULL UNIQUE
);

-- 2. CIUDADES

CREATE TABLE ciudades (
    codigo_ciudad INT AUTO_INCREMENT PRIMARY KEY,
    ciudad VARCHAR(100) NOT NULL,
    fk_pais INT NOT NULL,

    CONSTRAINT fk_ciudades_paises
        FOREIGN KEY (fk_pais)
        REFERENCES paises(codigo_pais)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT uq_ciudad_pais
        UNIQUE (ciudad, fk_pais)
);

-- 3. AEROPUERTOS

CREATE TABLE aeropuertos (
    codigo_aeropuerto VARCHAR(10) PRIMARY KEY,
    aeropuerto VARCHAR(150) NOT NULL,
    fk_ciudad INT NOT NULL,

    CONSTRAINT fk_aeropuertos_ciudades
        FOREIGN KEY (fk_ciudad)
        REFERENCES ciudades(codigo_ciudad)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

-- 4. MODELOS_AVIONES

CREATE TABLE modelos_aviones (
    id_modelo INT AUTO_INCREMENT PRIMARY KEY,
    modelo VARCHAR(100) NOT NULL UNIQUE,
    capacidad SMALLINT NOT NULL,

    CONSTRAINT chk_capacidad
        CHECK (capacidad > 0)
);

-- 5. AEROPUERTO_MODELOS_AVIONES

CREATE TABLE aeropuerto_modelos_aviones (
    fk_aeropuerto VARCHAR(10) NOT NULL,
    fk_modelo INT NOT NULL,

    PRIMARY KEY (fk_aeropuerto, fk_modelo),

    CONSTRAINT fk_ama_aeropuerto
        FOREIGN KEY (fk_aeropuerto)
        REFERENCES aeropuertos(codigo_aeropuerto)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_ama_modelo
        FOREIGN KEY (fk_modelo)
        REFERENCES modelos_aviones(id_modelo)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

-- 6. LINEAS_AEREAS

CREATE TABLE lineas_aereas (
    pk_linea_aerea INT AUTO_INCREMENT PRIMARY KEY,
    linea_aerea VARCHAR(100) NOT NULL UNIQUE
);

-- 7. PROGRAMAS_VUELO

CREATE TABLE programas_vuelo (
    pk_programa_vuelo INT AUTO_INCREMENT PRIMARY KEY,
    numero_vuelo VARCHAR(10) NOT NULL UNIQUE,
    fk_linea_aerea INT NOT NULL,
    aeropuerto_partida VARCHAR(10) NOT NULL,
    aeropuerto_llegada VARCHAR(10) NOT NULL,

    CONSTRAINT fk_programa_linea
        FOREIGN KEY (fk_linea_aerea)
        REFERENCES lineas_aereas(pk_linea_aerea)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_programa_partida
        FOREIGN KEY (aeropuerto_partida)
        REFERENCES aeropuertos(codigo_aeropuerto)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_programa_llegada
        FOREIGN KEY (aeropuerto_llegada)
        REFERENCES aeropuertos(codigo_aeropuerto)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

-- 8. SCHEDULE_PROGRAMAS_VUELOS

CREATE TABLE schedule_programas_vuelos (
    fk_programa_vuelo INT NOT NULL,
    dia_semana ENUM(
        'Lunes',
        'Martes',
        'Miercoles',
        'Jueves',
        'Viernes',
        'Sabado',
        'Domingo'
    ) NOT NULL,
    hora_salida TIME NOT NULL,

    PRIMARY KEY (fk_programa_vuelo, dia_semana),

    CONSTRAINT fk_schedule_programa
        FOREIGN KEY (fk_programa_vuelo)
        REFERENCES programas_vuelo(pk_programa_vuelo)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

-- 9. VUELOS

CREATE TABLE vuelos (
    pk_vuelo INT AUTO_INCREMENT PRIMARY KEY,
    numero_vuelo VARCHAR(10) NOT NULL,
    fecha DATE NOT NULL,
    hora TIME NOT NULL,
    plazas_vacias SMALLINT NOT NULL,
    modelo INT NOT NULL,

    CONSTRAINT fk_vuelo_programa
        FOREIGN KEY (numero_vuelo)
        REFERENCES programas_vuelo(numero_vuelo)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_vuelo_modelo
        FOREIGN KEY (modelo)
        REFERENCES modelos_aviones(id_modelo)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT chk_plazas_vacias
        CHECK (plazas_vacias >= 0)
);

-- 10. ESCALA_TECNICA

CREATE TABLE escala_tecnica (
    id_escala INT AUTO_INCREMENT PRIMARY KEY,
    fk_vuelo INT NOT NULL,
    fk_aeropuerto VARCHAR(10) NOT NULL,
    numero_orden SMALLINT NOT NULL,

    CONSTRAINT fk_escala_vuelo
        FOREIGN KEY (fk_vuelo)
        REFERENCES vuelos(pk_vuelo)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_escala_aeropuerto
        FOREIGN KEY (fk_aeropuerto)
        REFERENCES aeropuertos(codigo_aeropuerto)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT uq_escala_orden
        UNIQUE (fk_vuelo, numero_orden),

    CONSTRAINT chk_numero_orden
        CHECK (numero_orden > 0)
);

-- COMPROBACION 1: LISTAR TABLAS

SHOW TABLES;


-- COMPROBACION 2: CLAVES PRIMARIAS Y FORANEAS

SELECT
    TABLE_NAME,
    COLUMN_NAME,
    CONSTRAINT_NAME,
    REFERENCED_TABLE_NAME,
    REFERENCED_COLUMN_NAME
FROM information_schema.KEY_COLUMN_USAGE
WHERE TABLE_SCHEMA = 'vuelos'
ORDER BY TABLE_NAME, CONSTRAINT_NAME;


-- COMPROBACION 3: CAMPOS Y TIPOS DE DATOS

SELECT
    TABLE_NAME,
    COLUMN_NAME,
    COLUMN_TYPE,
    IS_NULLABLE,
    COLUMN_KEY,
    EXTRA
FROM information_schema.COLUMNS
WHERE TABLE_SCHEMA = 'vuelos'
ORDER BY TABLE_NAME, ORDINAL_POSITION;


-- COMPROBACION 4: RESTRICCIONES CHECK

SELECT
    tc.TABLE_NAME,
    cc.CONSTRAINT_NAME,
    cc.CHECK_CLAUSE
FROM information_schema.CHECK_CONSTRAINTS cc
JOIN information_schema.TABLE_CONSTRAINTS tc
    ON cc.CONSTRAINT_SCHEMA = tc.CONSTRAINT_SCHEMA
    AND cc.CONSTRAINT_NAME = tc.CONSTRAINT_NAME
    AND tc.CONSTRAINT_TYPE = 'CHECK'
WHERE cc.CONSTRAINT_SCHEMA = 'vuelos'
ORDER BY tc.TABLE_NAME;

