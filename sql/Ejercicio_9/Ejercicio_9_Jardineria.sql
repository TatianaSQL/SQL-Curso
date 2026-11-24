USE jardineria;


-- 1. Obtén un listado con el nombre de cada cliente
-- y el nombre y apellido de su representante de ventas.

SELECT c.nombre_cliente,
       e.nombre, e.apellido1, e.apellido2
FROM cliente c
INNER JOIN empleado e ON c.fk_representante_ventas = e.pk_empleado;


-- 2. Muestra el nombre de los clientes que hayan realizado pagos
-- junto con el nombre de sus representantes de ventas.

SELECT DISTINCT c.nombre_cliente,
       e.nombre, e.apellido1, e.apellido2
FROM cliente c
INNER JOIN pago p ON c.pk_cliente = p.fk_cliente
INNER JOIN empleado e ON c.fk_representante_ventas = e.pk_empleado;


-- 3. Muestra el nombre de los clientes que no hayan realizado pagos
-- junto con el nombre de sus representantes de ventas.

SELECT c.nombre_cliente,
       e.nombre, e.apellido1, e.apellido2
FROM cliente c
LEFT JOIN pago p ON c.pk_cliente = p.fk_cliente
INNER JOIN empleado e ON c.fk_representante_ventas = e.pk_empleado
WHERE p.fk_cliente IS NULL;


-- 4. Devuelve el nombre de los clientes que han hecho pagos
-- y el nombre de sus representantes junto con la ciudad
-- de la oficina a la que pertenece el representante.

SELECT DISTINCT c.nombre_cliente,
       e.nombre, e.apellido1, e.apellido2,
       o.ciudad
FROM cliente c
INNER JOIN pago p ON c.pk_cliente = p.fk_cliente
INNER JOIN empleado e ON c.fk_representante_ventas = e.pk_empleado
INNER JOIN oficina o ON e.fk_oficina = o.pk_oficina;


-- 5. Devuelve el nombre de los clientes que no hayan hecho pagos
-- y el nombre de sus representantes junto con la ciudad
-- de la oficina a la que pertenece el representante.

SELECT c.nombre_cliente,
       e.nombre, e.apellido1, e.apellido2,
       o.ciudad
FROM cliente c
LEFT JOIN pago p ON c.pk_cliente = p.fk_cliente
INNER JOIN empleado e ON c.fk_representante_ventas = e.pk_empleado
INNER JOIN oficina o ON e.fk_oficina = o.pk_oficina
WHERE p.fk_cliente IS NULL;


-- 6. Lista la dirección de las oficinas
-- que tengan clientes en Fuenlabrada.

SELECT DISTINCT o.linea_direccion1, o.linea_direccion2
FROM oficina o
INNER JOIN empleado e ON o.pk_oficina = e.fk_oficina
INNER JOIN cliente c ON e.pk_empleado = c.fk_representante_ventas
WHERE c.ciudad = 'Fuenlabrada';


-- 7. Devuelve el nombre de los clientes y el nombre de sus representantes
-- junto con la ciudad de la oficina a la que pertenece el representante.

SELECT c.nombre_cliente,
       e.nombre, e.apellido1, e.apellido2,
       o.ciudad
FROM cliente c
INNER JOIN empleado e ON c.fk_representante_ventas = e.pk_empleado
INNER JOIN oficina o ON e.fk_oficina = o.pk_oficina;


-- 8. Devuelve un listado con el nombre de los empleados
-- junto con el nombre de sus jefes.

SELECT e.nombre AS empleado,
       e.apellido1 AS apellido_empleado,
       j.nombre AS jefe,
       j.apellido1 AS apellido_jefe
FROM empleado e
LEFT JOIN empleado j ON e.fk_jefe = j.pk_empleado;


-- 9. Devuelve el nombre de los clientes a los que
-- no se les ha entregado a tiempo un pedido.

SELECT DISTINCT c.nombre_cliente
FROM cliente c
INNER JOIN pedido p ON c.pk_cliente = p.fk_cliente
WHERE p.fecha_entrega > p.fecha_esperada;


-- 10. Devuelve un listado de las diferentes gamas de producto
-- que ha comprado cada cliente.

SELECT DISTINCT c.nombre_cliente, g.gama
FROM cliente c
INNER JOIN pedido p ON c.pk_cliente = p.fk_cliente
INNER JOIN detalle_pedido dp ON p.pk_pedido = dp.fk_pedido
INNER JOIN producto pr ON dp.fk_producto = pr.pk_producto
INNER JOIN gama_producto g ON pr.fk_gama = g.pk_gama;


-- 11. Devuelve un listado que muestre solamente
-- los clientes que no han realizado ningún pago.

SELECT c.pk_cliente, c.nombre_cliente
FROM cliente c
LEFT JOIN pago p ON c.pk_cliente = p.fk_cliente
WHERE p.fk_cliente IS NULL;


-- 12. Devuelve un listado que muestre solamente
-- los clientes que no han realizado ningún pedido.

SELECT c.pk_cliente, c.nombre_cliente
FROM cliente c
LEFT JOIN pedido p ON c.pk_cliente = p.fk_cliente
WHERE p.pk_pedido IS NULL;


-- 13. Devuelve un listado que muestre los clientes
-- que no han realizado ningún pago
-- y los que no han realizado ningún pedido.

SELECT c.pk_cliente, c.nombre_cliente
FROM cliente c
LEFT JOIN pago p ON c.pk_cliente = p.fk_cliente
LEFT JOIN pedido pe ON c.pk_cliente = pe.fk_cliente
WHERE p.fk_cliente IS NULL
  AND pe.pk_pedido IS NULL;


-- 14. Devuelve un listado que muestre solamente
-- los empleados que no tienen una oficina asociada.

SELECT e.pk_empleado, e.nombre, e.apellido1, e.apellido2
FROM empleado e
LEFT JOIN oficina o ON e.fk_oficina = o.pk_oficina
WHERE o.pk_oficina IS NULL;


-- 15. Devuelve un listado que muestre solamente
-- los empleados que no tienen un cliente asociado.

SELECT e.pk_empleado, e.nombre, e.apellido1, e.apellido2
FROM empleado e
LEFT JOIN cliente c ON e.pk_empleado = c.fk_representante_ventas
WHERE c.pk_cliente IS NULL;


-- 16. Devuelve un listado que muestre solamente
-- los empleados que no tienen un cliente asociado
-- junto con los datos de la oficina donde trabajan.

SELECT e.pk_empleado, e.nombre, e.apellido1, e.apellido2,
       o.pk_oficina, o.ciudad, o.pais,
       o.linea_direccion1, o.linea_direccion2
FROM empleado e
LEFT JOIN cliente c ON e.pk_empleado = c.fk_representante_ventas
INNER JOIN oficina o ON e.fk_oficina = o.pk_oficina
WHERE c.pk_cliente IS NULL;


-- 17. Devuelve un listado que muestre los empleados
-- que no tienen una oficina asociada
-- y los que no tienen un cliente asociado.

SELECT e.pk_empleado, e.nombre, e.apellido1, e.apellido2
FROM empleado e
LEFT JOIN oficina o ON e.fk_oficina = o.pk_oficina
LEFT JOIN cliente c ON e.pk_empleado = c.fk_representante_ventas
WHERE o.pk_oficina IS NULL
   OR c.pk_cliente IS NULL;


-- 18. Devuelve un listado de los productos
-- que nunca han aparecido en un pedido.

SELECT pr.pk_producto, pr.nombre
FROM producto pr
LEFT JOIN detalle_pedido dp ON pr.pk_producto = dp.fk_producto
WHERE dp.fk_producto IS NULL;


-- 19. Devuelve un listado de los productos
-- que nunca han aparecido en un pedido.
-- El resultado debe mostrar el nombre, la descripción y la imagen.

SELECT pr.nombre, pr.descripcion, pr.imagen
FROM producto pr
LEFT JOIN detalle_pedido dp ON pr.pk_producto = dp.fk_producto
WHERE dp.fk_producto IS NULL;


-- 20. Devuelve las oficinas donde no trabajan ninguno de los empleados
-- que hayan sido representantes de ventas de algún cliente
-- que haya comprado algún producto de la gama Frutales.

SELECT o.pk_oficina, o.ciudad, o.pais,
       o.linea_direccion1, o.linea_direccion2
FROM oficina o
WHERE NOT EXISTS (
    SELECT 1
    FROM empleado e
    INNER JOIN cliente c ON e.pk_empleado = c.fk_representante_ventas
    INNER JOIN pedido p ON c.pk_cliente = p.fk_cliente
    INNER JOIN detalle_pedido dp ON p.pk_pedido = dp.fk_pedido
    INNER JOIN producto pr ON dp.fk_producto = pr.pk_producto
    INNER JOIN gama_producto g ON pr.fk_gama = g.pk_gama
    WHERE e.fk_oficina = o.pk_oficina
      AND g.gama = 'Frutales'
);


-- 21. Devuelve un listado con los clientes
-- que han realizado algún pedido pero no han realizado ningún pago.

SELECT DISTINCT c.pk_cliente, c.nombre_cliente
FROM cliente c
INNER JOIN pedido pe ON c.pk_cliente = pe.fk_cliente
LEFT JOIN pago p ON c.pk_cliente = p.fk_cliente
WHERE p.fk_cliente IS NULL;


-- 22. Devuelve un listado con los datos de los empleados
-- que no tienen clientes asociados
-- y el nombre de su jefe asociado.

SELECT e.pk_empleado, e.nombre, e.apellido1, e.apellido2,
       j.nombre AS jefe, j.apellido1 AS apellido_jefe
FROM empleado e
LEFT JOIN cliente c ON e.pk_empleado = c.fk_representante_ventas
LEFT JOIN empleado j ON e.fk_jefe = j.pk_empleado
WHERE c.pk_cliente IS NULL;