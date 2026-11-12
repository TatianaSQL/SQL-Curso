CREATE DATABASE IF NOT EXISTS tienda;
USE tienda;

CREATE TABLE fabricante (
    id_fabricante INT PRIMARY KEY,
    nombre_fabricante VARCHAR(100) NOT NULL
);


CREATE TABLE producto (
    id_producto INT PRIMARY KEY,
    nombre_producto VARCHAR(150) NOT NULL,
    precio DECIMAL(10,2) NOT NULL,
    id_fabricante INT NOT NULL,

    CONSTRAINT fk_producto_fabricante
        FOREIGN KEY (id_fabricante)
        REFERENCES fabricante(id_fabricante)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);
DELIMITER //

CREATE TRIGGER trg_fabricante_upper
BEFORE INSERT ON fabricante
FOR EACH ROW
BEGIN
    SET NEW.nombre_fabricante = UPPER(NEW.nombre_fabricante);
END //

DELIMITER ;

INSERT INTO fabricante (id_fabricante, nombre_fabricante)
VALUES
(1, 'Asus'),
(2, 'Lenovo'),
(3, 'Hewlett-Packard'),
(4, 'Samsung'),
(5, 'Seagate'),
(6, 'Crucial'),
(7, 'Gigabyte'),
(8, 'Huawei'),
(9, 'Xiaomi');

INSERT INTO producto
    (id_producto, nombre_producto, precio, id_fabricante)
VALUES
(1, 'Disco duro SATA3 1TB', 86.99, 5),
(2, 'Memoria RAM DDR4 8GB', 120.00, 6),
(3, 'Disco SSD 1 TB', 150.99, 4),
(4, 'GeForce GTX 1050Ti', 185.00, 7),
(5, 'GeForce GTX 1080 Xtreme', 755.00, 6),
(6, 'Monitor 24 LED Full HD', 202.00, 1),
(7, 'Monitor 27 LED Full HD', 245.91, 1),
(8, 'Portátil Yoga 520', 559.00, 2),
(9, 'Portátil Ideapd 320', 444.00, 2),
(10, 'Impresora HP Deskjet 3720', 59.99, 3),
(11, 'Impresora HP Laserjet Pro M26nw', 180.00, 3);

SELECT * FROM fabricante;
SELECT * FROM producto;

UPDATE producto
SET precio = precio * 1.15
WHERE id_fabricante IN (
    SELECT id_fabricante
    FROM fabricante
    WHERE nombre_fabricante IN ('ASUS', 'LENOVO', 'SAMSUNG')
);

UPDATE producto
SET precio = precio * 1.20
WHERE id_fabricante NOT IN (
    SELECT id_fabricante
    FROM fabricante
    WHERE nombre_fabricante IN ('ASUS', 'LENOVO', 'SAMSUNG')
);

SELECT
    p.id_producto,
    p.nombre_producto,
    p.precio,
    f.nombre_fabricante
FROM producto p
INNER JOIN fabricante f
    ON p.id_fabricante = f.id_fabricante
ORDER BY p.id_producto;


USE nomina;

DELIMITER //

CREATE TRIGGER trg_empleado_upper
BEFORE INSERT ON empleado
FOR EACH ROW
BEGIN
    SET NEW.nombre = UPPER(NEW.nombre);
    SET NEW.apellido = UPPER(NEW.apellido);
END //

DELIMITER ;

DELIMITER //

CREATE TRIGGER trg_empleado_sueldo
BEFORE INSERT ON empleado
FOR EACH ROW
BEGIN
    IF NEW.sueldo < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El sueldo no puede ser negativo';
    END IF;
END //

DELIMITER ;

SHOW TRIGGERS FROM nomina;

