-- =====================================================
-- IMPORTACION DE DATOS CSV - PROYECTO ALQUILER BARCELONA
-- =====================================================

-- 1. Seleccionar la base de datos
USE alquiler_barcelona;

-- 2. Crear tabla temporal de importacion
CREATE TABLE staging_alquiler (
    territorio VARCHAR(255),
    anio INT,
    precio_medio_eur_mes DECIMAL(10,2)
);

-- 3. Comprobar la ruta permitida para importar archivos
SHOW VARIABLES LIKE 'secure_file_priv';

-- 4. Comprobar si LOCAL INFILE esta habilitado
SHOW GLOBAL VARIABLES LIKE 'local_infile';

-- 5. Habilitar LOCAL INFILE (si es necesario)
SET GLOBAL local_infile = 1;

-- 6. Comprobar que LOCAL INFILE esta habilitado
SHOW GLOBAL VARIABLES LIKE 'local_infile';

-- 7. Importar el archivo CSV en la tabla staging
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.4/Uploads/alquiler_normalizado.csv'
INTO TABLE staging_alquiler
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

-- 8. Comprobar el numero de filas importadas
SELECT COUNT(*)
FROM staging_alquiler;

-- 9. Mostrar las primeras 10 filas
SELECT *
FROM staging_alquiler
LIMIT 10;

-- 10. Mostrar las filas 2017-2026
SELECT *
FROM observacion
WHERE anio BETWEEN 2017 AND 2026;