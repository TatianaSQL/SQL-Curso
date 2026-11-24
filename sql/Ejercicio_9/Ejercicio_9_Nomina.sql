USE nomina;


-- 1. Lista el nombre y apellido de los empleados, su sueldo
-- y el nombre del departamento donde trabaja.

SELECT e.nombre, e.apellido, e.sueldo, d.departamento
FROM empleado e
INNER JOIN departamento d ON e.fk_departamento = d.pk_departamento;


-- 2. Lista el nombre y apellido de los empleados,
-- su fecha de contrato y el nombre del cargo.

SELECT e.nombre, e.apellido, e.fecha_contrato, c.cargo
FROM empleado e
INNER JOIN cargo c ON e.fk_cargo = c.pk_cargo;


-- 3. Ordena el resultado por la fecha de contrato.

SELECT e.nombre, e.apellido, e.fecha_contrato, c.cargo
FROM empleado e
INNER JOIN cargo c ON e.fk_cargo = c.pk_cargo
ORDER BY e.fecha_contrato ASC;


-- 4. Lista el código del empleado, su nombre y apellido,
-- el código del departamento y el nombre del departamento
-- de los empleados que ganen más de 2000 euros.

SELECT e.pk_empleado, e.nombre, e.apellido,
       e.fk_departamento, d.departamento
FROM empleado e
INNER JOIN departamento d ON e.fk_departamento = d.pk_departamento
WHERE e.sueldo > 2000;


-- 5. Indica el nombre, apellido y nombre del cargo
-- del empleado más joven.

SELECT e.nombre, e.apellido, c.cargo, e.fecha_nacimiento
FROM empleado e
INNER JOIN cargo c ON e.fk_cargo = c.pk_cargo
ORDER BY e.fecha_nacimiento DESC
LIMIT 1;


-- 6. Indica el nombre, apellido y nombre del departamento
-- de los empleados que tengan hijos.

SELECT e.nombre, e.apellido, d.departamento
FROM empleado e
INNER JOIN departamento d ON e.fk_departamento = d.pk_departamento
WHERE e.hijos > 0;


-- 7. Lista todos los datos de los empleados de Contabilidad.

SELECT e.*
FROM empleado e
INNER JOIN departamento d ON e.fk_departamento = d.pk_departamento
WHERE d.departamento = 'Contabilidad';


-- 8. Lista el nombre y apellido del empleado, el nombre del cargo
-- y el del departamento de los empleados solteros sin hijos.

SELECT e.nombre, e.apellido, c.cargo, d.departamento
FROM empleado e
INNER JOIN cargo c ON e.fk_cargo = c.pk_cargo
INNER JOIN departamento d ON e.fk_departamento = d.pk_departamento
WHERE e.estado_civil = 'Soltero'
  AND e.hijos = 0;


-- 9. Lista los empleados de los departamentos de Compras y Ventas
-- sin utilizar el operador IN.

SELECT e.nombre, e.apellido, d.departamento
FROM empleado e
INNER JOIN departamento d ON e.fk_departamento = d.pk_departamento
WHERE d.departamento = 'Compras'
   OR d.departamento = 'Ventas';


-- 10. Lista los empleados de los departamentos de Compras y Ventas
-- utilizando el operador IN.

SELECT e.nombre, e.apellido, d.departamento
FROM empleado e
INNER JOIN departamento d ON e.fk_departamento = d.pk_departamento
WHERE d.departamento IN ('Compras', 'Ventas');


-- 11. Lista el nombre y apellido del empleado, el nombre del cargo
-- y del departamento de aquellas personas que tienen más de 20 años
-- en la empresa.
-- Ordena por departamento ascendente y tiempo trabajado descendente.

SELECT e.nombre, e.apellido, c.cargo, d.departamento,
       e.fecha_contrato
FROM empleado e
INNER JOIN cargo c ON e.fk_cargo = c.pk_cargo
INNER JOIN departamento d ON e.fk_departamento = d.pk_departamento
WHERE TIMESTAMPDIFF(YEAR, e.fecha_contrato, CURDATE()) > 20
ORDER BY d.departamento ASC, e.fecha_contrato ASC;


-- 12. Lista nombre y apellido, edad, nombre del cargo,
-- nombre del departamento de los empleados Solteros,
-- Divorciados o Viudos que tengan más de un hijo.

SELECT e.nombre, e.apellido,
       TIMESTAMPDIFF(YEAR, e.fecha_nacimiento, CURDATE()) AS edad,
       c.cargo, d.departamento
FROM empleado e
INNER JOIN cargo c ON e.fk_cargo = c.pk_cargo
INNER JOIN departamento d ON e.fk_departamento = d.pk_departamento
WHERE e.estado_civil IN ('Soltero', 'Divorciado', 'Viudo')
  AND e.hijos > 1;


-- 13. Lista todos los departamentos registrados,
-- junto con el código, nombre y apellido del empleado.
-- También muestra los departamentos que no tienen empleados.

SELECT d.pk_departamento, d.departamento,
       e.pk_empleado, e.nombre, e.apellido
FROM departamento d
LEFT JOIN empleado e ON d.pk_departamento = e.fk_departamento;


-- 14. Lista todos los cargos registrados,
-- junto con el nombre y apellido del empleado,
-- la edad y estado civil.
-- También muestra los cargos que no tienen empleados.

SELECT c.pk_cargo, c.cargo,
       e.nombre, e.apellido,
       TIMESTAMPDIFF(YEAR, e.fecha_nacimiento, CURDATE()) AS edad,
       e.estado_civil
FROM cargo c
LEFT JOIN empleado e ON c.pk_cargo = e.fk_cargo;


-- 15. Lista los departamentos sin empleados asociados.

SELECT d.pk_departamento, d.departamento
FROM departamento d
LEFT JOIN empleado e ON d.pk_departamento = e.fk_departamento
WHERE e.pk_empleado IS NULL;


-- 16. ¿Se puede asignar a un empleado un cargo que no esté
-- registrado en la tabla de cargos?

-- No. La clave foránea fk_cargo de la tabla empleado
-- referencia pk_cargo de la tabla cargo.
-- La restricción FOREIGN KEY impide asignar un cargo
-- que no exista en la tabla cargo.