-- ----------------------------------------
-- Tema		: Constraints en SQL Server
-- Profesor : Jesús Canales
-- Curso    : Base de Datos 2 
-- ----------------------------------------

-- <> Datos importantes
-- -- 1. Las restricciones nos ayudan a validar el ingreso correcto de datos.
-- -- 2. Permiten implementar las reglas de negocio en la base de datos
-- -- 3. Todas las constraints deben tener un nombre definido.
-- -- 4. Existen 3 tipos de constraint:
--		 -> Constraint de Integridad de Entidad
--		 -> Constraint de Integridad Referencial
--		 -> Constraint Integridad de Datos


-- <> Nos preparamos para las demos
-- -- 1. Crear una base de datos llamada dbRestrictions con valores por default.
-- -- 2. Poner en uso la base de datos previamente creada.

--------------------------------------------------------------------------------
/* CONSTRAINT DE INTEGRIDAD DE ENTIDAD */

--> Integridad de entidad (PRIMARY KEY)
--> Llamado Clave Principal y no permiten valores nulos ni duplicados, 

--> <> Crear una CONSTRAINT primary key al momento de crear una tabla 

--	1. Creación de la tabla CLIENTE con una constraint PRIMARY KEY
CREATE TABLE client
(
	id int,
	names varchar(60),
	last_names varchar(90),
	status char(1),
	CONSTRAINT client_pk PRIMARY KEY (id)
)
GO

--	2. Revisamos la estructura de la tabla cliente
exec sp_help 'dbo.client'
GO

--> <> Crear una CONSTRAINT primary key después de crear una tabla 

--  1. Crear tabla country (país)
CREATE TABLE country
(id int not null, name_country varchar(80))
GO

--  2. Crear PRIMARY KEY en la tabla country (país)
ALTER TABLE country
	ADD CONSTRAINT country_pk
	PRIMARY KEY (id)
GO

--	3. Revisamos la estructura de la tabla cliente
exec sp_help 'dbo.country'
GO

--  4. Listamos los PKs de la base de datos en uso
SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
WHERE CONSTRAINT_TYPE = 'PRIMARY KEY'
GO
--------------------------------------------------------------------------------
/* CONSTRAINT DE INTEGRIDAD REFERENCIAL - FOREIGN KEY sobre tablas existentes */

--  1. Listar tablas existentes en la base de datos
SELECT * FROM sys.tables
GO

--  2. Agregar columna country_id en tabla Cliente para relacionar con country
ALTER TABLE client
	ADD country_id int
GO

--  3. Verificar estructura de tabla con la nueva columna
exec sp_help 'dbo.client'
GO

--  4. Establecer la relación entre la tabla CLIENTE y la tabla PAIS
ALTER TABLE client
	ADD CONSTRAINT fk_country_client
	FOREIGN KEY (country_id)
	REFERENCES country (id) -- ON UPDATE CASCADE / ON DELETE CASCADE
GO
-----------
--  5. Verificar relación entre client & country
SELECT 
	fk.name [Constraint],
    OBJECT_NAME(fk.parent_object_id) [Tabla],
    COL_NAME(fc.parent_object_id,fc.parent_column_id) [Columna],
    OBJECT_NAME (fk.referenced_object_id) AS [Tabla base],
    COL_NAME(fc.referenced_object_id, fc.referenced_column_id) AS [Columna de tabla base (PK)]
FROM 
	sys.foreign_keys fk
	INNER JOIN sys.foreign_key_columns fc ON (fk.OBJECT_ID = fc.constraint_object_id)
WHERE
	(OBJECT_NAME(fk.parent_object_id) = 'client')
GO




----
--> <> Crear una foreign key al momento de crear una tabla 

--  1. Antes de crear la tabla, verificar las tablas existentes
EXEC sp_tables 
	@table_owner = 'dbo', 
	@table_qualifier = 'dbRestrictions'
GO

--  2. Crear tabla seller (vendedor) con relación a tabla country (país)
CREATE TABLE seller
(
	id int,
	names varchar(60),
	last_name varchar(90),
	country_id int,
	CONSTRAINT pk_seller PRIMARY KEY (id),
	CONSTRAINT fk_country_seller 
	FOREIGN KEY (country_id)
	REFERENCES country (id) -- ON UPDATE CASCADE
)
GO

-----------
--  5. Verificar relación entre seller & country
SELECT 
	fk.name [Constraint],
    OBJECT_NAME(fk.parent_object_id) [Tabla],
    COL_NAME(fc.parent_object_id,fc.parent_column_id) [Columna],
    OBJECT_NAME (fk.referenced_object_id) AS [Tabla base],
    COL_NAME(fc.referenced_object_id, fc.referenced_column_id) AS [Columna de tabla base (PK)]
FROM 
	sys.foreign_keys fk
	INNER JOIN sys.foreign_key_columns fc ON (fk.OBJECT_ID = fc.constraint_object_id)
WHERE
	(OBJECT_NAME(fk.parent_object_id) = 'seller')
GO




--------------------------------------------------------------------------------
/* CONSTRAINT DE INTEGRIDAD DE DATOS -> UNIQUE */

-----<> Garantiza que no se registren valores duplicados en columnas específicas.
-----<> En una tabla se pueden definir varias restricciones UNIQUE

--  1. Crear tabla vehicle (vehículo) con constraint UNIQUE 
CREATE TABLE vehicle
(
	id int,
	descriptions varchar(70),
	brand varchar(80),
	vehicle_plate char(7),
	CONSTRAINT pk_vehicle PRIMARY KEY (id),
	CONSTRAINT uq_vehicle_plate UNIQUE (vehicle_plate) -- la placa es dato único
)
GO

--  2. Listar restricciones de una tabla
SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
WHERE TABLE_NAME = 'vehicle'
GO
-----------
--> <> Crear constraint UNIQUE en una tabla existente

--  1. Agregamos campo dni en tabla client
ALTER TABLE client
	ADD dni char(8)
GO

--  2. Verificamos que se agregó la columna dni
exec sp_help 'dbo.client'
GO

--  3. Agregamos campo dni en tabla client con restricción única
ALTER TABLE client
	ADD CONSTRAINT uq_dni_client --el dni es único por cliente
	UNIQUE (dni)
GO

--  4. Listar restricciones de tabla client
SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
WHERE TABLE_NAME = 'client'
GO

--------------------------------------------------------------------------------
/* CONSTRAINT DE INTEGRIDAD DE DATOS -> DEFAULT */

-----<> Se asigna un valor predeterminado a la columna

--  1. Crear constraint DEFAULT al crear una tabla
CREATE TABLE product
(
	code char(4),
	descriptions varchar(60),
	brand varchar(80),
	status char(1) 
	CONSTRAINT df_status_product DEFAULT ('A'),--- (A) es activo / (I) inactivo
	CONSTRAINT pk_product PRIMARY KEY (code)
)
GO

--  2. Ver estructura tabla product
exec sp_help 'dbo.product'
GO
-----------
--  3. Insertar registro 
INSERT INTO product
(code, descriptions, brand)
VALUES
('V001', 'Camioneta 4 x 4', 'Toyota') --No registrar el dato de la columna DEFAULT
GO

--  4. Listamos registro (vemos el valor por default)
SELECT * FROM product
GO

--  5. Insertar registro (no utilizar el valor por default)
INSERT INTO product
(code, descriptions, brand, status)
VALUES
('V002', 'Auto', 'Lexus', 'I') -- Si registramos el dato de la columna DEFAULT
GO

--  6. Listamos registro (vemos el valor ingresado sobre el estado)
SELECT * FROM product
GO
------------
--> <> Crear constraint DEFAULT en una tabla existente

--  1. Exploramos la estructura de la tabla vendedor
exec sp_help 'dbo.seller'
GO

--  2. Agregamos una columna register_date (fecha de registro) en tabla seller
ALTER TABLE seller
	ADD register_date date
GO

--  3. Agregamos campo default sea la fecha del sistema al momento de registro
ALTER TABLE seller
	ADD CONSTRAINT df_register_date
	DEFAULT getdate() FOR register_date
GO

--  4. Antes de insertar registros en la tabla seller empecemos por country
INSERT INTO country (id, name_country)
VALUES (1, 'Perú'), (2, 'Colombia')
GO
------------
--  5. Probamos la inserción en tabla seller (sin agregar columna default)
INSERT INTO seller
	(id, names, last_name, country_id)
VALUES
	(1, 'Alberto', 'Lozano Campos', 1)
GO

--  6. Inserción registro con fecha ingresada manualmente de registro
SET DATEFORMAT dmy;
INSERT INTO seller
	(id, names, last_name, country_id, register_date)
VALUES (2, 'Mangnolia', 'Paredes Rodríguez', 1, '05/09/2023')
GO

--  7. Listar los registros de la tabla seller 
SELECT * FROM seller -- Se valida que registró la fecha del sistema del servidor
GO

--  8. Listar restricciones de tipo DEFAULT
SELECT * FROM sys.default_constraints
GO

--------------------------------------------------------------------------------
/* CONSTRAINT DE INTEGRIDAD DE DATOS -> CHECK */

-----<> Exige la integridad del dominio mediante la limitación de valores que puede aceptar una columna a partir de una expresión lógica.

--  1. Creación de constraint CHECK al crear una tabla ()
CREATE TABLE supplier
(
	id int,
	ruc char(11),
	name varchar(60),
	email varchar(60),
	CONSTRAINT pk_supplier PRIMARY KEY (id),
	CONSTRAINT chk_digit_ruc CHECK (LEN(ruc)= 11) --cantidad digitos esperado
)
GO

--  LEN es una función que permite obtener la cantidad de caracteres
--  Buscamos validar que sólo acepte 11 digitos como número de ruc
---------------------
--  2. Validamos con la inserción de registros (ruc correcto)
INSERT INTO supplier
	(id, ruc, name, email)
VALUES
	(1, '45781236957', 'Tienda Pepito SAC', 'informes@pepito.com')
GO

--  3. Listamos los registros
SELECT * FROM supplier
GO

--  4. Validamos con la inserción de registros (ruc incorrecto)
INSERT INTO supplier --- validamos que no permite si el ruc no es correcto
(id, ruc, name, email)
VALUES
(2, '457812', 'TechComputer EIRL', 'informes@techcomputer.com')
GO

--Verificamos que no se permite la inserción de este segundo registro en supplier

-----------
---<> Creación de constraint CHECK en una tabla existente
---<> Restricción para permitir la inserción de correos válidos

--  1. Agregamos la restricción a un campo de una tabla previamente creada
ALTER TABLE supplier
	ADD CONSTRAINT chk_email 
	CHECK(email LIKE '%@%._%') --validamos formato válido de correo
GO

--  2. Insertamos un registro para validar
INSERT INTO supplier 
	(id, ruc, name, email)
VALUES
	(3, '85142536974', 'Inversiones Juanito SAC', 'informesjuanito.com')
GO

--  3. Listar restricciones de tipo CHECK
SELECT * FROM sys.check_constraints
GO

--------------------------------------------------------------------------------

/* ELIMINACIÓN DE RESTRICCIONES */


--  1. Listar restricciones de tipo CHECK
SELECT * FROM sys.check_constraints
GO

--  2. Eliminamos la restricción CHK_CANT_DIG_RUC
ALTER TABLE supplier
	DROP CONSTRAINT chk_digit_ruc
GO







--------------------------------------------------------------------------------
/* CONSTRAINT IDENTITY - IDENTITY  */

---> En muchos casos coincide con el PRIMARY KEY
---> Debe tener un valor inicial y un incremento

--  1. Creamos la tabla sale (venta) con un campo autoincrementable
CREATE TABLE sale
(
	id int IDENTITY(100, 1), --- Inicia en 100 y va de uno en uno
	date_sale date DEFAULT GETDATE(),
	client_id int,
)
GO

--  2. Insertamos registros para validar el autoincrementable
INSERT INTO sale (client_id)
VALUES
	(2), (6), (2)
GO

--------
--  3. Listamos los registros de la tabla sale (venta)
SELECT * FROM sale
GO

--  4. Resetear IDENTITY
DBCC CHECKIDENT ('sale', RESEED, 300)
GO

--  5. Ahora el IDENTITY inicia en 300
INSERT INTO sale (client_id)
VALUES (10), (12)
GO

--  6. Ahora el IDENTITY inicia en 300
SELECT * FROM sale
GO

--  7. Desactivar IDENTITY
SET IDENTITY_INSERT sale ON
GO
---------------
--  8. Probamos insertar nuevos registros especificando manualmente el id 
INSERT INTO sale
	(id, client_id)
VALUES (400, 3), (420, 9)
GO

--  9. Listamos los registros de la tabla sale (venta)
SELECT * FROM sale
GO

-- 10. Activar IDENTITY
SET IDENTITY_INSERT sale OFF
GO

-- 11. Probamos insertar con indentity especificado 
INSERT INTO sale
	(client_id)
VALUES (3),	(7);
GO

-- 12. Listamos los registros de la tabla sale (venta)
SELECT * FROM sale
GO

-- 13. Listamos los identitys
SELECT * FROM sys.identity_columns
GO