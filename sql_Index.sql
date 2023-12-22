-- -----------------------------------
-- Tema 10  : �ndices en SQL Server
-- Profesor : Jes�s Canales
-- Curso    : Base de Datos 2 
-- -----------------------------------
-- Los datos est�n guardados en una tabla (el libro) que tiene
-- muchas hojas de datos (las p�ginas del libro), 
-- con un �ndice en el que podemos buscar la informaci�n que nos interesa.


/* IO -> Muestra cu�ntas lecturas l�gicas y f�sicas utiliza SQL Server mientras procesa las instrucciones */
SET STATISTICS IO ON
GO

/* TIME -> Muestra el n�mero de milisegundos necesarios para analizar, compilar y ejecutar cada instrucci�n. */
SET STATISTICS TIME ON
GO

--------------------------------------------------------------------------------
/* Configurando entorno  de trabajo */

-- 1. Descargamos backup de base de datos demo AdventureWorks2019 */

-- 2. Restauramos base de datos AdventureWorks2019.back */

-- 3. Ponemos en uso AdventureWorks2019
USE AdventureWorks2019
GO

-- 4. Listar esquemas de la base de datos */
SELECT * FROM AdventureWorks2019.INFORMATION_SCHEMA.SCHEMATA
WHERE SCHEMA_OWNER = 'dbo'
GO

-- 5. Listar tablas de la base de datos */
SELECT * FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE'
GO

--------------------------------------------------------------------------------
/* Demo 1 */

-- 1. Revisando contenido de tabla
SELECT top 10 * FROM sales.SalesOrderHeader
GO

-- 2. Creamos una tabla a partir de SalesOrderHeader
SELECT * INTO SALES.SOH
FROM Sales.SalesOrderHeader
GO

-- 3. Listamos los registros de la nueva tabla creada
SELECT * FROM SALES.SOH
GO

-- 4. Listar si la nueva tabla tiene �ndices
SP_HELPINDEX 'SALES.SOH'
GO

--------------------------------------------------------------------------------
/* Demo 2 */

-- 1. Explorando al detalle los �ndices de SALES.SOH
SELECT OBJECT_NAME(OBJECT_ID) AS TABLENAME,
	INDEX_ID,
	TYPE_DESC
FROM sys.indexes
WHERE OBJECT_ID = OBJECT_ID('SALES.SOH')
GO

-- 2. Buscando una orden espec�fica en base a su ID 
SELECT * FROM SALES.SOH
WHERE SalesOrderID= '67409'
GO

-- 3. Exploramos los paneles:
--	  -<> Resultados
--	  -<> Mensajes
--	  -<> Plan de ejecuci�n

--------------------------------------------------------------------------------
/* Demo 3 */

-- 1. Creamos un �ndice CLUSTERED en base al ID
CREATE CLUSTERED INDEX IDX_SOH_SALESORDERID
ON AdventureWorks2019.SALES.SOH (SALESORDERID)
GO

-- 2. Buscando una orden espec�fica en base a su ID 
SELECT * FROM SALES.SOH
WHERE SalesOrderID= '67409'
GO

-- 3. Exploramos los paneles:
--	  -<> Resultados        : 1 resultado encontrado.
--	  -<> Mensajes          : Disminuye el tiempo de respuesta y costo.
--	  -<> Plan de ejecuci�n : Existe �ndice clustered.

-- 4. Verificar el �ndice que hemos creado
SP_HELPINDEX 'SALES.SOH'
GO

--------------------------------------------------------------------------------
/* Demo 4 */

-- 1. Hacemos una b�squeda de �rdenes en base al CustomerID 29855
SELECT * FROM SALES.SOH
WHERE SOH.CustomerID = '29855'
GO

-- 2. Exploramos los paneles: Resultados, Mensajes y Plan de ejecuci�n.

-- 3. Creamos un �ndice NONCLUSTERED
CREATE NONCLUSTERED INDEX IDX_SOH_CUSTOMERID
ON AdventureWorks2019.SALES.SOH (CUSTOMERID)
GO

-- 4. Hacemos una vez m�s la b�squeda de �rdenes en base al CustomerID 29855
SELECT * FROM SALES.SOH
WHERE SOH.CustomerID = '29855'
GO

-- 5. Exploramos y comparamos los nuevos resultados.

--------------------------------------------------------------------------------
/* Demo 5 */

-- 1. Creamos una nueva tabla basada en PERSON
SELECT * INTO PERSON.LISTPERSON FROM Person.Person
GO

-- 2. Listamos todos los registros de la nueva tabla
SELECT * FROM PERSON.LISTPERSON
GO

-- 3. Listar tipo de persona, apellidos y nombres
SELECT L.PersonType, L.LastName, L.FirstName FROM PERSON.LISTPERSON L
GO

-- 4. Creamos �ndice NONCLUSTERED basado en columnas
CREATE NONCLUSTERED INDEX IDX_PERSONTYPE_LASTN_FIRSTN
ON PERSON.LISTPERSON(PERSONTYPE, LASTNAME, FIRSTNAME)
GO

-- 5. Volvemos a ejecutar la consulta de listado y exploramos los resultados.

--------------------------------------------------------------------------------
/* Demo 6 */

-- 1. Obteniendo el porcentaje de fragmentaci�n de �NDICES
SELECT 
	sys.schemas.name as 'Schema',
	sys.tables.name as 'Table',
	sys.indexes.name as 'Index',
	ddips.avg_fragmentation_in_percent,
	ddips.page_count
FROM
	sys.dm_db_index_physical_stats(db_id(), null, null, null, null) AS DDIPS
	INNER JOIN sys.tables ON sys.tables.object_id = ddips.object_id
	INNER JOIN sys.schemas ON sys.schemas.schema_id = sys.tables.schema_id
	INNER JOIN sys.indexes ON sys.indexes.object_id = ddips.object_id
	AND ddips.index_id = sys.indexes.index_id
WHERE
	ddips.database_id = db_id() 
	AND sys.indexes.name is not null
	AND ddips.avg_fragmentation_in_percent >= 0
ORDER BY ddips.avg_fragmentation_in_percent desc
GO

--------------------------------------------------------------------------------
/* Demo 7 */

-- 1. Recomendaciones para mantenimiento de �NDICES
-- --<> Si el % de Frag. est� entre 0 - 5 (vamos bien)
-- --<> Si est� entre 5 - 30 se recomienda REORGANIZAR
-- --<> Si es mayor a 30 se recomienda RECONSTRUIR

-- 2. Vamos a REORGANIZE �NDICES
ALTER INDEX AK_Product_ProductNumber
	ON Production.Product
	REORGANIZE
GO

-- 3. Vamos a RECONSTRUIR �NDICE
ALTER INDEX AK_Product_ProductNumber
	ON Production.Product
	REBUILD
GO

--------------------------------------------------------------------------------
/* Demo 8 */

-- 1. Listar �NDICES creados en las demos
SP_HELPINDEX 'SALES.SOH'
GO

-- 2. Desactivar los �NDICES de la tabla SALES.SOH
ALTER INDEX ALL ON SALES.SOH DISABLE
GO

-- 3. Eliminar �NDICES de tabla SALES.SOH
DROP INDEX 
	IDX_SOH_CUSTOMERID ON SALES.SOH,
	IDX_SOH_SALESORDERID ON SALES.SOH
GO

-- 4. Explorando al detalle los �ndices de SALES.SOH
SELECT OBJECT_NAME(OBJECT_ID) AS TABLENAME, INDEX_ID, TYPE_DESC
FROM sys.indexes
WHERE OBJECT_ID = OBJECT_ID('SALES.SOH')
GO