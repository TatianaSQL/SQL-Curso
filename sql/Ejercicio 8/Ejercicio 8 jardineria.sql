-- DROP DATABASE IF EXISTS jardineria;

CREATE DATABASE jardineria CHARACTER SET utf8mb4;
USE jardineria;

CREATE TABLE oficina (
  pk_oficina VARCHAR(10) NOT NULL,
  ciudad VARCHAR(30) NOT NULL,
  pais VARCHAR(50) NOT NULL,
  region VARCHAR(50) DEFAULT NULL,
  codigo_postal VARCHAR(10) NOT NULL,
  telefono VARCHAR(20) NOT NULL,
  linea_direccion1 VARCHAR(50) NOT NULL,
  linea_direccion2 VARCHAR(50) DEFAULT NULL,
  PRIMARY KEY (pk_oficina)
);

CREATE TABLE empleado (
  pk_empleado INTEGER NOT NULL,
  nombre VARCHAR(50) NOT NULL,
  apellido1 VARCHAR(50) NOT NULL,
  apellido2 VARCHAR(50) DEFAULT NULL,
  extension VARCHAR(10) NOT NULL,
  email VARCHAR(100) NOT NULL,
  fk_oficina VARCHAR(10) NOT NULL,
  fk_jefe INTEGER DEFAULT NULL,
  puesto VARCHAR(50) DEFAULT NULL,
  PRIMARY KEY (pk_empleado),
  FOREIGN KEY (fk_oficina) REFERENCES oficina (pk_oficina),
  FOREIGN KEY (fk_jefe) REFERENCES empleado (pk_empleado)
);

CREATE TABLE gama_producto (
  pk_gama INT AUTO_INCREMENT,
  gama VARCHAR(50) NOT NULL,
  descripcion_texto TEXT,
  PRIMARY KEY (pk_gama)
);

CREATE TABLE cliente (
  pk_cliente INTEGER NOT NULL,
  nombre_cliente VARCHAR(50) NOT NULL,
  nombre_contacto VARCHAR(30) DEFAULT NULL,
  apellido_contacto VARCHAR(30) DEFAULT NULL,
  telefono VARCHAR(15) NOT NULL,
  fax VARCHAR(15) NOT NULL,
  linea_direccion1 VARCHAR(50) NOT NULL,
  linea_direccion2 VARCHAR(50) DEFAULT NULL,
  ciudad VARCHAR(50) NOT NULL,
  region VARCHAR(50) DEFAULT NULL,
  pais VARCHAR(50) DEFAULT NULL,
  codigo_postal VARCHAR(10) DEFAULT NULL,
  fk_representante_ventas INTEGER DEFAULT NULL,
  limite_credito NUMERIC(15,2) DEFAULT NULL,
  PRIMARY KEY (pk_cliente),
  FOREIGN KEY (fk_representante_ventas) REFERENCES empleado (pk_empleado)
);

CREATE TABLE pedido (
  pk_pedido INTEGER NOT NULL,
  fecha_pedido date NOT NULL,
  fecha_esperada date NOT NULL,
  fecha_entrega date DEFAULT NULL,
  estado VARCHAR(15) NOT NULL,
  comentarios TEXT,
  fk_cliente INTEGER NOT NULL,
  PRIMARY KEY (pk_pedido),
  FOREIGN KEY (fk_cliente) REFERENCES cliente (pk_cliente)
);

CREATE TABLE producto (
  pk_producto VARCHAR(15) NOT NULL,
  nombre VARCHAR(70) NOT NULL,
  fk_gama INT NOT NULL,
  dimensiones VARCHAR(25) NULL,
  proveedor VARCHAR(50) DEFAULT NULL,
  descripcion text NULL,
  cantidad_en_stock SMALLINT NOT NULL,
  precio_venta NUMERIC(15,2) NOT NULL,
  precio_proveedor NUMERIC(15,2) DEFAULT NULL,
  PRIMARY KEY (pk_producto),
  FOREIGN KEY (fk_gama) REFERENCES gama_producto (pk_gama)
);

CREATE TABLE detalle_pedido (
  fk_pedido INTEGER NOT NULL,
  fk_producto VARCHAR(15) NOT NULL,
  cantidad INTEGER NOT NULL,
  precio_unidad NUMERIC(15,2) NOT NULL,
  numero_linea SMALLINT NOT NULL,
  PRIMARY KEY (fk_pedido, fk_producto),
  FOREIGN KEY (fk_pedido) REFERENCES pedido (pk_pedido),
  FOREIGN KEY (fk_producto) REFERENCES producto (pk_producto)
);

CREATE TABLE pago (
  fk_cliente INTEGER NOT NULL,
  forma_pago VARCHAR(40) NOT NULL,
  id_transaccion VARCHAR(50) NOT NULL,
  fecha_pago date NOT NULL,
  total NUMERIC(15,2) NOT NULL,
  PRIMARY KEY (fk_cliente, id_transaccion),
  FOREIGN KEY (fk_cliente) REFERENCES cliente (pk_cliente)
);