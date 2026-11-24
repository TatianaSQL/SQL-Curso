-- DROP DATABASE transporte_mercancias;

CREATE DATABASE IF NOT EXISTS transporte_mercancias;
USE transporte_mercancias;

CREATE TABLE IF NOT EXISTS marcas(
 pk_marca INT AUTO_INCREMENT PRIMARY KEY,
 marca VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS empleados(
 pk_dni VARCHAR(20) PRIMARY KEY,
 nombre VARCHAR(50) NOT NULL,
 apellido1 VARCHAR(50) NOT NULL,
 apellido2 VARCHAR(50),
 telefono VARCHAR(20)
);

CREATE TABLE IF NOT EXISTS conductores(
 fk_dni VARCHAR(20) PRIMARY KEY,
 carnet VARCHAR(50) NOT NULL,
 fk_categoria INT NOT NULL
);

CREATE TABLE IF NOT EXISTS categoria_conductores(
 pk_categoria INT AUTO_INCREMENT PRIMARY KEY,
 descripcion VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS administrativos(
 fk_dni VARCHAR(20) PRIMARY KEY,
 fk_departamento INT NOT NULL
);

CREATE TABLE IF NOT EXISTS departamentos(
 pk_departamento INT AUTO_INCREMENT PRIMARY KEY,
 departamento VARCHAR(50) NOT NULL
);

CREATE TABLE IF NOT EXISTS modelos(
 pk_modelo INT AUTO_INCREMENT PRIMARY KEY,
 fk_marca INT NOT NULL,
 modelo VARCHAR(50) NOT NULL
);

CREATE TABLE IF NOT EXISTS vehiculos(
 pk_matricula VARCHAR(20) PRIMARY KEY,
 fk_modelo INT NOT NULL,
 anyo INT NOT NULL
);

CREATE TABLE IF NOT EXISTS camiones(
 fk_matricula VARCHAR(20) PRIMARY KEY,
 tonelaje_maximo DECIMAL(10, 2) NOT NULL
);

CREATE TABLE IF NOT EXISTS furgonetas(
 fk_matricula VARCHAR(20) PRIMARY KEY,
 capacidad_maxima_m3 DECIMAL(10, 2) NOT NULL
);

CREATE TABLE IF NOT EXISTS viajes(
 pk_viaje INT AUTO_INCREMENT PRIMARY KEY,
 origen VARCHAR(100) NOT NULL,
 destino VARCHAR(100) NOT NULL,
 fk_conductor VARCHAR(20),
 fk_vehiculo VARCHAR(20)
);

CREATE TABLE IF NOT EXISTS tramos_viaje(
 fk_viaje INT,
 numero_tramo INT,
 distancia_km DECIMAL(10, 2) NOT NULL,
 fecha_inicio DATETIME,
 fecha_fin DATETIME,
 PRIMARY KEY (fk_viaje, numero_tramo)
);

CREATE TABLE IF NOT EXISTS administrativo_viajes(
 fk_viaje INT,
 fk_dni VARCHAR(20)
);


ALTER TABLE tramos_viaje
ADD CONSTRAINT fk_tramo_viaje 
FOREIGN KEY (fk_viaje) REFERENCES viajes(pk_viaje);

ALTER TABLE administrativo_viajes
ADD CONSTRAINT pk_administrativo_viajes PRIMARY KEY (fk_viaje, fk_dni),
ADD FOREIGN KEY (fk_viaje) REFERENCES viajes(pk_viaje)
ON DELETE CASCADE ON UPDATE CASCADE,
ADD FOREIGN KEY (fk_dni) REFERENCES empleados(pk_dni)
ON DELETE CASCADE ON UPDATE CASCADE;





