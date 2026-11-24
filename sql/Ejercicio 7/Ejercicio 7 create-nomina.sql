-- DROP DATABASE nomina;
-- nomina.sql

CREATE DATABASE IF NOT EXISTS nomina;
USE nomina;

-- tabla departamento
CREATE TABLE departamento(
  pk_departamento int AUTO_INCREMENT,
  departamento varchar(50) unique,
  primary key (pk_departamento)
);

-- tabla cargo
CREATE TABLE cargo(
  pk_cargo int AUTO_INCREMENT primary key,
  cargo varchar(50) unique
);

 -- tabla empleado
 CREATE TABLE empleado (
  pk_empleado int AUTO_INCREMENT primary key,
  apellido varchar(25) not null,
  nombre varchar(25) not null,
  sexo enum('Hombre', 'Mujer') not null,
  fecha_nacimiento date not null comment 'con esto se calculará la edad',
  estado_civil enum('Soltero', 'Casado', 'Divorciado', 'Viudo', 'Otro') not null,
  hijos int UNSIGNED default 0 ,
  fk_cargo integer,
  fk_departamento integer,
  fecha_contrato date not null,
  sueldo decimal(10,2) not null CHECK (sueldo > 700*12),
  retencion_sso decimal(10,2) GENERATED ALWAYS AS (sueldo * 0.047) STORED
);

-- foreign keys

ALTER TABLE empleado 
ADD CONSTRAINT cargos_empleados
FOREIGN KEY (fk_cargo) REFERENCES cargo(pk_cargo)
ON UPDATE CASCADE -- si un padre se cambia se cambian sus hijos en la tabla empleado
ON DELETE RESTRICT; -- si un padre se intenta borrar y tiene hijos, no se permite la operación

ALTER TABLE empleado 
ADD CONSTRAINT departamentos_empleados
FOREIGN KEY (fk_departamento) REFERENCES departamento(pk_departamento)
ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE empleado ADD COLUMN num_sso varchar(15);

ALTER TABLE empleado
ADD CONSTRAINT sso_empleado UNIQUE(num_sso);