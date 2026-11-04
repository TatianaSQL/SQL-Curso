-- Ejercicio 2: Sistema de Ventas
-- Crear y seleccionar la base de datos
CREATE DATABASE IF NOT EXISTS ventas;
USE ventas;

-- 1. CLIENTES
CREATE TABLE clientes (
    cif_nif VARCHAR(15) PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    calle VARCHAR(100),
    numero VARCHAR(10),
    ciudad VARCHAR(60),
    codigo_postal VARCHAR(10)
);

-- 2. TELEFONOS_CLIENTES
CREATE TABLE telefonos_clientes (
    telefono VARCHAR(20) PRIMARY KEY,
    cif_nif VARCHAR(15) NOT NULL,
    CONSTRAINT fk_telefonos_clientes_cliente
        FOREIGN KEY (cif_nif) REFERENCES clientes(cif_nif)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

-- 3. PROVEEDORES
CREATE TABLE proveedores (
    cif_nif VARCHAR(15) PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    telefono VARCHAR(20),
    web VARCHAR(255),
    calle VARCHAR(100),
    numero VARCHAR(10),
    ciudad VARCHAR(60),
    codigo_postal VARCHAR(10)
);

-- 4. CATEGORIAS
CREATE TABLE categorias (
    id_categoria INT PRIMARY KEY,
    nombre_categoria VARCHAR(100) NOT NULL,
    descripcion TEXT
);

-- 5. PRODUCTOS
CREATE TABLE productos (
    id_producto INT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    stock INT NOT NULL DEFAULT 0,
    precio_actual DECIMAL(10,2) NOT NULL,
    cif_nif_proveedor VARCHAR(15) NOT NULL,
    id_categoria INT NOT NULL,
    CONSTRAINT fk_productos_proveedor
        FOREIGN KEY (cif_nif_proveedor) REFERENCES proveedores(cif_nif)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT fk_productos_categoria
        FOREIGN KEY (id_categoria) REFERENCES categorias(id_categoria)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

-- 6. FACTURAS
CREATE TABLE facturas (
    numero_factura INT PRIMARY KEY,
    fecha DATE NOT NULL,
    descuento DECIMAL(5,2) DEFAULT 0,
    importe_final DECIMAL(10,2) NOT NULL,
    cif_nif_cliente VARCHAR(15) NOT NULL,
    CONSTRAINT fk_facturas_cliente
        FOREIGN KEY (cif_nif_cliente) REFERENCES clientes(cif_nif)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

-- 7. FACTURAS_PRODUCTOS
-- Tabla intermedia entre FACTURAS y PRODUCTOS (relación N:M)
CREATE TABLE facturas_productos (
    numero_factura INT NOT NULL,
    id_producto INT NOT NULL,
    cantidad INT NOT NULL,
    precio_venta DECIMAL(10,2) NOT NULL,
    iva DECIMAL(5,2) NOT NULL,
    PRIMARY KEY (numero_factura, id_producto),
    CONSTRAINT fk_facturas_productos_factura
        FOREIGN KEY (numero_factura) REFERENCES facturas(numero_factura)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT fk_facturas_productos_producto
        FOREIGN KEY (id_producto) REFERENCES productos(id_producto)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

-- Comprobación: mostrar las tablas creadas
SHOW TABLES;
DESCRIBE clientes;
DESCRIBE telefonos_clientes;
DESCRIBE proveedores;
DESCRIBE categorias;
DESCRIBE productos;
DESCRIBE facturas;
DESCRIBE facturas_productos;



