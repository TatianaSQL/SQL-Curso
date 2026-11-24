USE jardineria;


-- 1. Devuelve un listado con el código de oficina y la ciudad donde hay oficinas.

SELECT pk_oficina, ciudad
FROM oficina;


-- 2. Devuelve un listado con la ciudad y el teléfono de las oficinas de España.

SELECT ciudad, telefono
FROM oficina
WHERE pais = 'España';


-- 3. Devuelve un listado con el nombre, apellidos y email de los empleados cuyo jefe tiene un código de jefe igual a 7.

SELECT nombre, apellido1, apellido2, email
FROM empleado
WHERE fk_jefe = 7;


-- 4. Devuelve el nombre del puesto, nombre, apellidos y email del jefe de la empresa.

SELECT puesto, nombre, apellido1, apellido2, email
FROM empleado
WHERE puesto = 'Director General';


-- 5. Devuelve un listado con el nombre, apellidos y puesto de aquellos empleados que no sean representantes de ventas.

SELECT nombre, apellido1, apellido2, puesto
FROM empleado
WHERE puesto IS NOT NULL
  AND puesto <> 'Representante Ventas';


-- 6. Devuelve un listado con el nombre de los todos los clientes españoles.

SELECT nombre_cliente
FROM cliente
WHERE pais = 'España';


-- 7. Devuelve un listado con los distintos estados por los que puede pasar un pedido.

SELECT DISTINCT estado
FROM pedido;


-- 8. Devuelve un listado con el código de cliente de aquellos clientes que realizaron algún pago en 2008.
-- Utilizando la función YEAR de MySQL.

SELECT DISTINCT fk_cliente
FROM pago
WHERE YEAR(fecha_pago) = 2008;


-- 8. Utilizando la función DATE_FORMAT de MySQL.

SELECT DISTINCT fk_cliente
FROM pago
WHERE DATE_FORMAT(fecha_pago, '%Y') = '2008';


-- 8. Sin utilizar YEAR ni DATE_FORMAT.

SELECT DISTINCT fk_cliente
FROM pago
WHERE fecha_pago LIKE '2008%';


-- 9. Devuelve un listado con el código de pedido, código de cliente, fecha esperada y fecha de entrega de los pedidos que no han sido entregados a tiempo.

SELECT pk_pedido, fk_cliente, fecha_esperada, fecha_entrega
FROM pedido
WHERE fecha_entrega > fecha_esperada;


-- 10. Devuelve un listado de pedidos cuya fecha de entrega ha sido al menos dos días antes de la fecha esperada.
-- Utilizando la función ADDDATE de MySQL.

SELECT pk_pedido, fk_cliente, fecha_esperada, fecha_entrega
FROM pedido
WHERE fecha_entrega <= ADDDATE(fecha_esperada, INTERVAL -2 DAY);


-- 10. Utilizando la función DATEDIFF de MySQL.

SELECT pk_pedido, fk_cliente, fecha_esperada, fecha_entrega
FROM pedido
WHERE DATEDIFF(fecha_esperada, fecha_entrega) >= 2;


-- 10. ¿Sería posible resolver esta consulta utilizando el operador de suma + o resta -?

-- No se recomienda utilizar la resta directa entre fechas.
-- DATEDIFF es la función adecuada para calcular la diferencia en días.


-- 11. Devuelve un listado de todos los pedidos que fueron rechazados en 2009.

SELECT *
FROM pedido
WHERE estado = 'Rechazado'
  AND YEAR(fecha_pedido) = 2009;


-- 12. Devuelve un listado de todos los pedidos que han sido entregados en el mes de enero de cualquier año.

SELECT *
FROM pedido
WHERE estado = 'Entregado'
  AND MONTH(fecha_entrega) = 1;


-- 13. Devuelve un listado con todos los pagos que se realizaron en el año 2008 mediante Paypal.
-- Ordena el resultado de mayor a menor.

SELECT fk_cliente, forma_pago, fecha_pago, total
FROM pago
WHERE YEAR(fecha_pago) = 2008
  AND forma_pago = 'PayPal'
ORDER BY fecha_pago DESC;


-- 14. Devuelve un listado con todas las formas de pago que aparecen en la tabla pago.
-- No deben aparecer formas de pago repetidas.

SELECT DISTINCT forma_pago
FROM pago;


-- 15. Devuelve un listado con todos los productos que pertenecen a la gama Ornamentales
-- y que tienen más de 100 unidades en stock.
-- Ordenados por precio de venta, mostrando primero los de mayor precio.

SELECT p.pk_producto, p.nombre, g.gama, p.cantidad_en_stock, p.precio_venta
FROM producto p
JOIN gama_producto g ON p.fk_gama = g.pk_gama
WHERE g.gama = 'Ornamentales'
  AND p.cantidad_en_stock > 100
ORDER BY p.precio_venta DESC;


-- 16. Devuelve un listado con todos los clientes que sean de la ciudad de Madrid
-- y cuyo representante de ventas tenga el código de empleado 11 o 30.

SELECT pk_cliente, nombre_cliente, ciudad, fk_representante_ventas
FROM cliente
WHERE ciudad = 'Madrid'
  AND (fk_representante_ventas = 11
       OR fk_representante_ventas = 30);