-- nomina.sql

-- inserts tabla departamento

INSERT INTO departamento 
    (pk_departamento, departamento) 
  VALUES 
    (1, 'Administración'), 
    (2, 'Compras'),
    (3, 'Contabilidad'),
    (4, 'Informática'),
    (5, 'Recursos Humanos'),
    (6, 'Ventas'),
    (7, 'Marketing'),
    (8, 'Finanzas'),
    (9, 'Recepción');

-- verificamos

SELECT 
    departamento, 
    pk_departamento 
  FROM 
    departamento;

-- inserts tabla cargo

 INSERT INTO cargo (pk_cargo, cargo) VALUES (1, 'Analista');
 INSERT INTO cargo (pk_cargo, cargo) VALUES (2, 'Asistente');
 INSERT INTO cargo (pk_cargo, cargo) VALUES (3, 'Ejecutivo');
 INSERT INTO cargo (pk_cargo, cargo) VALUES (4, 'Gerente');
 INSERT INTO cargo (pk_cargo, cargo) VALUES (5, 'Oficinista');
 INSERT INTO cargo (pk_cargo, cargo) VALUES (6, 'Programador');
 INSERT INTO cargo (pk_cargo, cargo) VALUES (7, 'Secretaria');
 INSERT INTO cargo (pk_cargo, cargo) VALUES (8, 'Vice Presidente');
 INSERT INTO cargo (pk_cargo, cargo) VALUES (9, 'Técnico');
 INSERT INTO cargo (pk_cargo, cargo) VALUES (10, 'Especialista');

 -- verificamos

SELECT * FROM cargo;

 -- inserts tabla empleado
 INSERT INTO empleado (pk_empleado, apellido, nombre, sexo, fecha_nacimiento, estado_civil, hijos, fk_cargo, fk_departamento, fecha_contrato, sueldo) 
VALUES
(1, 'Sánchez', 'Federico', 'Hombre', '1961-7-3', 'Casado', 0, 6, 4, '1990-9-27', 25674),
(2, 'Jiménez', 'Joaquín', 'Hombre', '1963-4-1', 'Divorciado', 1, 5, 1, '1990-11-11', 18050),
(3, 'Cantón', 'Eduardo', 'Hombre', '1962-7-19', 'Soltero', 1, 2, 1, '1990-12-31', 16128),
(4, 'Sosa', 'Carla', 'Mujer', '1961-8-7', 'Divorciado', 0, 1, 5, '1991-2-15', 16350),
(5, 'Lara', 'Patricia', 'Mujer', '1967-2-16', 'Casado', 0, 4, 1, '1991-11-21', 29723),
(6, 'Carrasco', 'Ricardo', 'Hombre', '1963-11-20', 'Otro', 0, 3, 1, '1992-5-12', 40000),
(7, 'Campos', 'Silvana', 'Mujer', '1967-3-14', 'Divorciado', 1, 2, 2, '1993-1-30', 16395),
(8, 'Albano', 'Laura', 'Mujer', '1967-2-15', 'Casado', 2, 7, 1, '1993-3-24', 18000),
(9, 'Dávila', 'David', 'Hombre', '1968-3-28', 'Casado', 2, 6, 4, '1994-3-1', 25000),
(10, 'Jiménez', 'Rebeca', 'Mujer', '1969-1-29', 'Soltero', 0, 2, 2, '1994-7-28', 19530),
(11, 'Montes', 'Alonso', 'Hombre', '1970-3-25', 'Casado', 1, 7, 3, '1995-6-23', 15000),
(12, 'Blanco', 'Beatriz', 'Mujer', '1969-10-1', 'Divorciado', 1, 2, 1, '1996-4-30', 13260),
(13, 'Briceño', 'Marcelo', 'Hombre', '1971-5-1', 'Casado', 2, 2, 1, '1997-4-2', 22312),
(14, 'Dávila', 'José', 'Hombre', '1968-9-24', 'Casado', 3, 6, 4, '1999-1-17', 27000),
(15, 'Cepeda', 'Guillermo', 'Hombre', '1975-8-22', 'Divorciado', 1, 4, 2, '1999-2-22', 30000),
(16, 'Sánchez', 'Raúl', 'Hombre', '1974-7-8', 'Soltero', 0, 2, 3, '1999-2-23', 14644),
(17, 'Santos', 'Eliana', 'Mujer', '1975-7-13', 'Divorciado', 1, 1, 5, '1999-3-31', 18060),
(18, 'Landa', 'Carolina', 'Mujer', '1973-6-23', 'Casado', 1, 2, 6, '1999-6-2', 12000),
(19, 'Marín', 'Lucía', 'Mujer', '1975-8-19', 'Casado', 1, 3, 1, '1999-12-17', 24164),
(20, 'Porras', 'Martín', 'Hombre', '1978-11-10', 'Soltero', 0, 6, 4, '2000-1-6', 22000),
(21, 'Stagnone', 'José', 'Hombre', '1975-2-9', 'Casado', 2, 8, 5, '2000-7-2', 50940),
(22, 'Marín', 'Victoria', 'Mujer', '1978-12-15', 'Soltero', 1, 1, 4, '2001-2-2', 23256),
(23, 'López', 'Miguel', 'Hombre', '1979-4-17', 'Casado', 1, 2, 3, '2001-3-17', 17248),
(24, 'Wallis', 'Miguel', 'Hombre', '1962-10-15', 'Divorciado', 0, 1, 5, '2002-4-15', 18820),
(25, 'Amador', 'Jorge', 'Hombre', '1982-6-18', 'Viudo', 2, 2, 3, '2003-9-20', 14964),
(26, 'Abad', 'Palmira', 'Mujer', '1982-9-10', 'Soltero', 1, 2, 6, '2005-4-24', 13650),
(27, 'Sánchez', 'Luis', 'Hombre', '1982-11-6', 'Soltero', 0, 2, 6, '2005-8-24', 18000),
(28, 'De Botto', 'Julio', 'Hombre', '1983-5-18', 'Soltero', 0, 1, 4, '2005-9-13', 20328),
(29, 'Lorenzo', 'Casalta', 'Hombre', '1984-9-3', 'Divorciado', 0, 2, 6, '2012-8-13', 17000),
(30, 'Pérez', 'Eduardo', 'Hombre', '1983-9-15', 'Soltero', 1, 1, 4, '2012-11-2', 20964),
(31, 'Beuermann', 'Celia', 'Mujer', '1984-11-19', 'Soltero', 1, 2, 3, '2013-1-15', 14700),
(32, 'Pietri', 'Juan Carlos', 'Hombre', '1984-6-1', 'Otro', 0, 2, 3, '2013-4-20', 18000),
(33, 'Álvarez', 'Antonia', 'Mujer', '1984-1-1', 'Soltero', 1, 3, 3, '2013-5-22', 22952),
(34, 'Gallo', 'Juan Antonio', 'Hombre', '1988-9-11', 'Casado', 1, 2, 6, '2013-7-15', 13800),
(35, 'Capriles', 'Alfredo', 'Hombre', '1986-1-4', 'Soltero', 0, 2, 2, '2013-8-27', 15912),
(36, 'Rodríguez', 'José Ignacio', 'Hombre', '1988-12-20', 'Otro', 0, 2, 3, '2013-12-11', 14412),
(37, 'Juárez', 'Rubén', 'Hombre', '1987-5-16', 'Divorciado', 3, 4, 6, '2013-12-13', 32516),
(38, 'Pérez', 'Carlos', 'Hombre', '1987-9-9', 'Soltero', 0, 7, 5, '2013-12-14', 12975),
(39, 'Gutiérrez', 'Raúl', 'Hombre', '1988-10-28', 'Divorciado', 3, 2, 2, '2014-1-15', 14560),
(40, 'Da Silva', 'Ariana', 'Mujer', '1985-11-8', 'Casado', 2, 7, 1, '2014-2-7', 12810),
(41, 'Calissano', 'Alicia', 'Mujer', '1986-2-25', 'Divorciado', 1, 3, 1, '2014-7-1', 22292),
(42, 'Camacho', 'Antonio', 'Hombre', '1988-5-22', 'Casado', 2, 4, 5, '2014-7-2', 30000),
(43, 'Galindo', 'Darío', 'Hombre', '1994-5-1', 'Divorciado', 2, 3, 1, '2015-3-30', 23612),
(44, 'Hernández', 'Javier', 'Hombre', '1990-12-13', 'Casado', 1, 5, 5, '2015-5-16', 15000),
(45, 'Albanés', 'Pablo', 'Hombre', '1992-4-29', 'Soltero', 1, 3, 1, '2015-6-14', 29945),
(46, 'Gambacorta', 'Omar', 'Hombre', '1991-5-18', 'Soltero', 1, 4, 3, '2015-6-27', 26852),
(47, 'Milton', 'Liliana', 'Mujer', '1995-11-7', 'Casado', 0, 3, 1, '2015-12-28', 24464),
(48, 'Fuentes', 'Gloria', 'Mujer', '1996-4-5', 'Soltero', 1, 3, 6, '2016-5-20', 23512),
(49, 'Wells', 'Oriana', 'Mujer', '1998-3-5', 'Casado', 1, 3, 1, '2017-6-6', 29495),
(50, 'Krauss', 'Eduardo', 'Hombre', '1992-7-8', 'Soltero', 1, 2, 6, '2017-7-21', 12558),
(51, 'Jiménez', 'Juan', 'Hombre', '2000-5-24', 'Soltero', 0, 1, 4, '2017-10-7', 20532),
(52, 'Márquez', 'Jaime', 'Hombre', '1991-12-21', 'Otro', 0, 4, 4, '2017-11-7', 35911),
(53, 'García', 'Francisco', 'Hombre', '2000-2-9', 'Soltero', 0, 5, 4, '2018-5-11', 12500),
(54, 'Manrique', 'Gonzálo', 'Hombre', '2000-6-3', 'Divorciado', 1, 2, 2, '2018-8-1', 14157),
(55, 'Acevedo', 'Matilde', 'Mujer', '1968-5-16', 'Viudo', 1, 7, 6, '2018-8-21', 12850),
(56, 'Ramírez', 'Mariana', 'Mujer', '2000-6-17', 'Soltero', 1, 3, 6, '2018-10-13', 32846),
(57, 'Chacón', 'Emeterio', 'Hombre', '1999-2-25', 'Soltero', 1, 2, 1, '2018-11-2', 12252),
(58, 'Colón', 'William', 'Hombre', '1990-5-23', 'Divorciado', 2, 2, 2, '2019-2-27', 15132),
(59, 'Rodríguez', 'Manuel', 'Hombre', '1990-1-28', 'Soltero', 0, 8, 1, '2019-4-1', 45000),
(60, 'Bonalde', 'Roberta', 'Mujer', '1997-2-19', 'Soltero', 0, 7, 2, '2019-4-5', 15000);

SELECT * FROM empleado;
-- ahora verifica tú...