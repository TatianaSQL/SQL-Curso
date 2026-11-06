  -- Ejercicio 3: Carreteras
-- Base de datos, tablas, claves primarias, claves foraneas y restricciones
CREATE DATABASE IF NOT EXISTS carreteras;
USE carreteras;

-- 1. COMUNIDAD_AUTONOMA
CREATE TABLE comunidad_autonoma (
    id_comunidad_autonoma INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL UNIQUE
);

-- 2. PROVINCIA
-- Cada provincia pertenece a una única comunidad autónoma.
CREATE TABLE provincia (
    id_provincia INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    id_comunidad_autonoma INT NOT NULL,
    CONSTRAINT uq_provincia_comunidad_nombre
        UNIQUE (id_comunidad_autonoma, nombre),
    CONSTRAINT fk_provincia_comunidad
        FOREIGN KEY (id_comunidad_autonoma)
        REFERENCES comunidad_autonoma(id_comunidad_autonoma)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

-- 3. CARRETERA
-- Nivel 1: siempre Autonómica.
-- Nivel 2: Autonómica o Provincial.
-- Nivel 3: Autonómica, Provincial o Municipal.
-- Estatal: no tiene nivel (NULL).
CREATE TABLE carretera (
    cod_carretera VARCHAR(20) PRIMARY KEY,
    nombre VARCHAR(150) NOT NULL,
    titularidad ENUM('Estatal','Autonómica','Provincial','Municipal') NOT NULL,
    nivel TINYINT NULL,
    tipo_via ENUM('Autopista','Autovía','Multicarril','Convencional') NOT NULL,
    acceso_controlado BOOLEAN NOT NULL DEFAULT FALSE,
    doble_calzada BOOLEAN NOT NULL DEFAULT FALSE,
    prefijo VARCHAR(15),
    color VARCHAR(30),
    senal VARCHAR(50),
    observaciones TEXT,
    CONSTRAINT chk_nivel_valido
        CHECK (nivel IS NULL OR nivel IN (1,2,3)),
    CONSTRAINT chk_titularidad_nivel
        CHECK (
            (titularidad = 'Estatal' AND nivel IS NULL)
            OR (titularidad = 'Autonómica' AND nivel IN (1,2,3))
            OR (titularidad = 'Provincial' AND nivel IN (2,3))
            OR (titularidad = 'Municipal' AND nivel = 3)
        )
);

-- 4. TRAMO
-- id_tramo se genera automáticamente.
-- longitud se calcula automáticamente: km_final - km_inicial.
CREATE TABLE tramo (
    id_tramo INT AUTO_INCREMENT PRIMARY KEY,
    cod_carretera VARCHAR(20) NOT NULL,
    km_inicial DECIMAL(8,2) NOT NULL,
    km_final DECIMAL(8,2) NOT NULL,
    longitud DECIMAL(8,2)
        GENERATED ALWAYS AS (km_final - km_inicial) STORED,
    tipo_terreno ENUM('Plano','Cuesta subida','Cuesta bajada') NOT NULL,
    entorno ENUM('Urbano','Travesía','Extraurbano') NOT NULL,
    velocidad_limite SMALLINT,
    numero_carriles_sentido TINYINT,
    observaciones_adicionales TEXT,
    CONSTRAINT fk_tramo_carretera
        FOREIGN KEY (cod_carretera)
        REFERENCES carretera(cod_carretera)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT chk_tramo_kilometros
        CHECK (km_final >= km_inicial),
    CONSTRAINT chk_velocidad_limite
        CHECK (velocidad_limite IS NULL OR velocidad_limite > 0),
    CONSTRAINT chk_numero_carriles
        CHECK (numero_carriles_sentido IS NULL OR numero_carriles_sentido > 0)
);

-- 5. TRAMO_PROVINCIA
-- Relación N:M: un tramo puede pasar por varias provincias.
-- km_entrada y km_salida indican dónde entra y sale el tramo de cada provincia.
-- La comunidad autónoma se obtiene a través de PROVINCIA.
CREATE TABLE tramo_provincia (
    id_tramo INT NOT NULL,
    id_provincia INT NOT NULL,
    km_entrada DECIMAL(8,2) NOT NULL,
    km_salida DECIMAL(8,2) NOT NULL,
    PRIMARY KEY (id_tramo, id_provincia),
    CONSTRAINT fk_tramo_provincia_tramo
        FOREIGN KEY (id_tramo)
        REFERENCES tramo(id_tramo)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT fk_tramo_provincia_provincia
        FOREIGN KEY (id_provincia)
        REFERENCES provincia(id_provincia)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT chk_tramo_provincia_km
        CHECK (km_salida >= km_entrada)
);

-- 6. EXTREMO_CARRETERA
-- Registra el inicio o final de una carretera.
-- tipo_finalizacion = 'Fisico': la carretera termina físicamente.
-- tipo_finalizacion = 'Confluencia': enlaza con otra carretera.
-- En una confluencia se indica la carretera relacionada, km, tramo y provincia.
CREATE TABLE extremo_carretera (
    id_extremo INT AUTO_INCREMENT PRIMARY KEY,
    cod_carretera VARCHAR(20) NOT NULL,
    tipo_extremo ENUM('Inicio','Final') NOT NULL,
    tipo_finalizacion ENUM('Fisico','Confluencia') NOT NULL,
    cod_carretera_confluye VARCHAR(20) NULL,
    kilometro DECIMAL(8,2) NOT NULL,
    id_tramo INT NOT NULL,
    id_provincia INT NOT NULL,
    CONSTRAINT fk_extremo_carretera
        FOREIGN KEY (cod_carretera)
        REFERENCES carretera(cod_carretera)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT fk_extremo_carretera_confluye
        FOREIGN KEY (cod_carretera_confluye)
        REFERENCES carretera(cod_carretera)
        ON UPDATE RESTRICT
        ON DELETE RESTRICT,
    CONSTRAINT fk_extremo_tramo
        FOREIGN KEY (id_tramo)
        REFERENCES tramo(id_tramo)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT fk_extremo_provincia
        FOREIGN KEY (id_provincia)
        REFERENCES provincia(id_provincia)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
   CONSTRAINT chk_extremo_confluencia
    CHECK (
        (tipo_finalizacion = 'Fisico' AND cod_carretera_confluye IS NULL)
        OR
        (tipo_finalizacion = 'Confluencia'
         AND cod_carretera_confluye IS NOT NULL)
    )
);


-- COMPROBACIÓN 1: listar las tablas creadas.
SHOW TABLES;

-- COMPROBACIÓN 2: revisar las claves primarias y foráneas.
SELECT
    TABLE_NAME,
    COLUMN_NAME,
    CONSTRAINT_NAME,
    REFERENCED_TABLE_NAME,
    REFERENCED_COLUMN_NAME
FROM information_schema.KEY_COLUMN_USAGE
WHERE TABLE_SCHEMA = 'carreteras'
ORDER BY TABLE_NAME, CONSTRAINT_NAME, ORDINAL_POSITION;

-- COMPROBACIÓN 3: revisar los campos y sus tipos.
SELECT
    TABLE_NAME,
    COLUMN_NAME,
    COLUMN_TYPE,
    IS_NULLABLE,
    COLUMN_KEY,
    EXTRA
FROM information_schema.COLUMNS
WHERE TABLE_SCHEMA = 'carreteras'
ORDER BY TABLE_NAME, ORDINAL_POSITION;

