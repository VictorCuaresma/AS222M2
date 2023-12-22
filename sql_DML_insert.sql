-- -----------------------------------
-- Tema     : Data Manipulation Language (DML)
-- Profesor : Jesús Canales
-- Curso    : Base de Datos A1 
-- -----------------------------------
-- Permiten administrar o manipular datos de una o más tablas.
-- Utilizadas para agregar, modificar, eliminar o leer datos de la base de datos.
-- Estas sentencias son: 
--	  -<> INSERT > Permite la inserción de una o varias filas en una tabla. 
--	  -<> UPDATE > Permite la modificación o actualización de datos de la tabla.
--	  -<> DELETE > Permite la eliminación física de datos de la tabla.
--	  -<> SELECT > Permite la lectura de datos de la tablas de la base de datos

/* Para las demos de la clase utilizaremos la base de datos dbCompuTech 
-- Ejecutar el script de implementación de la base de datos.
-- Verificar la existencia de esquemas.		-> SELECT * FROM sys.schemas;
-- Verificar la existencia de tablas.		-> SELECT * FROM sys.tables
-- Verificar la existencia de relaciones.	-> SELECT * FROM sys.foreign_keys 
*/

--------------------------------------------------------------------------------
/* Reconociendo nuestra base de datos */

-- 1. Poner en uso la base de datos dbCompuTech */ 

-- 2. Listar esquemas de la base de datos */
SELECT * FROM sys.schemas
GO

/* Listar tablas de una base de datos */
SELECT * FROM sys.tables 
GO

/* Listar relaciones de tablas de dbCompuTech */
SELECT 
    fk.name [Constraint], OBJECT_NAME(fk.parent_object_id) [Tabla],
    COL_NAME(fc.parent_object_id,fc.parent_column_id) [Columna FK],
    OBJECT_NAME (fk.referenced_object_id) AS [Tabla base],
    COL_NAME(fc.referenced_object_id, fc.referenced_column_id) AS [Columna PK]
FROM 
    sys.foreign_keys fk INNER JOIN sys.foreign_key_columns fc ON (fk.OBJECT_ID = fc.constraint_object_id)
GO
--------------------------------------------------------------------------------
/* INSERT : sintaxis de inserción de datos en una fila:
		INSERT INTO name_table
			(column1, column2, column3, ...)
		VALUES
			(value1, value2, value3, ...)
*/

-- 1. Insertamos los datos de un cliente
SET DATEFORMAT dmy --fijamos el formato de fecha.
GO
INSERT INTO PERSONA.client
	(names, last_names, email, brithday)--recuerda hay campos con valores default.
VALUES
	('María', 'Guerra Solano', 'maria.guerra@gmail.com', '01/06/2000')
GO

-- 2. Listamos los registros insertados
SELECT * FROM PERSONA.client
GO

--------------------------------------------------------------------------------
/***Tarea 1 -> Inserta registros en las siguientes tablas */

-- 1. Tabla product:
	-- Code: P01
	-- Description: 'Teclado ergonónimo'
	-- Category: 'Accesorio'
	-- Stock: 100
	-- Precio: 60.50
	-- Status: A

-- 2. Tabla client:
	-- Names: Leonardo
	-- Last_Names: Pérez Tarazona
	-- Email: leonardo.perez@outlook.com
	-- Birthday: 25 Marzo 2001
	-- Status: A

-- 3. Tabla sale:
	-- Id: 1
	-- Register_date: 29/09/2023 (fecha del sistema - valor por default)
	-- Client_id: 1
	-- Status: A
	
--------------------------------------------------------------------------------
/* INSERT : sintaxis de inserción de varias filas en una tabla:
		INSERT INTO name_table
			(column1, column2, column3, ...)
		VALUES
			(value1, value2, value3, ...),
			(value1, value2, value3, ...),
			(value1, value2, value3, ...);
*/

-- 1. Insertamos los siguientes productos
INSERT INTO PRODUCTO.product
	(code, description, category, stock, price)
VALUES
	('P02', 'Mouse ergonónimo', 'Accesorio', 110, 150.50),
	('P03', 'Monitor Ultra HD', 'Monitor', 50, 1950.70),
	('P04', 'WebCam Microsoft', 'Accesorio', 70, 220.30),
	('P05', 'Microsoft 365', 'Software', 90, 500.50)
GO

-- 2. Listamos los productos registrados SELECT * FROM PRODUCTO.product

--------------------------------------------------------------------------------
/***Tarea 2 -> Inserta registros en las siguientes tablas */

--<> 1. Insertar los siguientes registros en la tabla client:
-- |names		|lastnames		  |email						  |birthday  ----
-- |Carlos		|Reyes Ruíz		  |carlos.reyes@gmail.com		  |10/07/1999
-- |Oscar Julian|Manco Flores	  |oscar.manco@yahoo.com		  |25/06/1997
-- |Mario		|Dávila Ascencio  |mario.davila@outlook.com		  |15/07/2000
-- |Margarita	|Chumpitaz García |margarita.chumpitaz@yahoo.com  |30/01/1995

--<> 2. Insertar los siguientes registros en la tabla sale_detail:
-- |sale_id |product			| quantity  ----
-- |1		|WebCam Microsoft	| 3
-- |1		|Mouse ergonómico	| 1
-- |1		|Teclado ergonómico	| 3

--<> 3. Registrar las ventas (sale) realizadas a los clientes:
-- |id	|client	
-- |2	|Oscar Julian Manco Flores
-- |3	|Margarita Chumpitaz García
-- |4	|Leonardo Pérez Tarazon

--------------------------------------------------------------------------------
/* INSERT : subimos un poquito más el level... */
-- Queremos pasar datos de algunos campos de una tabla a otra

-- 1. Listamos registros de la tabla product
SELECT * FROM PRODUCTO.product
GO

-- 2. Creamos una nueva tabla desde el esquema PRODUCTO llamada list_product
CREATE TABLE PRODUCTO.list_product
(producto varchar(100), cantidad_disponible int, precio decimal(8,2))
GO

-- 3. Verificamos que aún no hay registros en esta nueva tabla
SELECT * FROM PRODUCTO.list_product
GO

-- 4. Pasamos los datos de los campos: description, stock y price
INSERT INTO PRODUCTO.list_product
	(producto, cantidad_disponible, precio)
SELECT description, stock, price FROM PRODUCTO.product
GO

--------------------------------------------------------------------------------
/***Tarea 3 -> Pasamos registros de una tabla a otra tabla */

--<> 1. Listar los registros de la tabla client.

--<> 2. En el esquema persona crear tabla guests (invitados) con los campos:
--		-> nombres
--		-> apellidos
--		-> correo electrónico
--		-> fecha de nacimiento

--<> 3. Desde la tabla client insertar datos necesarios a la tabla guests.

--<> 4. Listar los registros de la tabla guests.





--------------------------------------------------------------------------------
/* INSERT : subimos un poquito más el level... */
-- Creamos una replica de tabla en estructura y registros

-- 1. Listamos registros de tabla product
SELECT * FROM PRODUCTO.product
GO

-- 2. Creamos la replica de la tabla product en la tabla inventory
SELECT * INTO PRODUCTO.inventory 
FROM PRODUCTO.product
GO

-- 3. Listamos registros de la tabla
SELECT * FROM PRODUCTO.inventory
GO

-- 4. Revisamos las estructuras de las tablas inventory y product
EXEC sp_columns @table_name = 'inventory'
GO
EXEC sp_columns @table_name = 'product'
GO

--------------------------------------------------------------------------------
/* INSERT : esto no para... sigue... sigue */

-- Traemos registros de un archivo externo a una tabla

-- 1. Tenemos un archivo de texto plano (txt) con datos.

-- 2. Exploramos el contenido del archivo.

-- 3. Creamos la tabla, la estructura debe estar basada en el archivo.

-- 4. Procedemos a insertar registros desde el archivo.
BULK INSERT PRODUCTO.category
	FROM 'C:\REGISTROS\categorias.txt' --ubicación del archivo.
	WITH (
		FIELDTERMINATOR=',',
		FIRSTROW = 2)
GO

-- 5. Listamos registros de la tabla category.
SELECT * FROM PRODUCTO.category
GO

--------------------------------------------------------------------------------
/* UPDATE : sintaxis para actualización de datos en una tabla:
		
*/

-- 1. 
drop database dbCompuTech