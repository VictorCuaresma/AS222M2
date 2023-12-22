-- -----------------------------------------------------------------------------
-- Tema     : Data Manipulation Language (DML) 
-- Profesor : Jesús Canales
-- Curso    : Base de Datos A1 
--------------------------------------------------------------------------------
-----<> SELECT > Permite la recuperación de datos desde una o varias tablas.
-----			 Está conformado por predicados y cláusulas.
-----<> sintaxis:
/*	SELECT ALL | Top | Distinct		--- ¿Qué columnas deseas ver?
	FROM name_table					--- ¿Qué tabla se va a necesitar?
	WHERE condicion					--- Condiciones para listar los datos
	GROUP BY name_column			--- ¿Cómo deben agruparse las filas?
	HAVING condition				--- Condición para el agrupamiento
	ORDER BY name_colum				--- Cómo deben ordenarse los datos resultantes

Recursos para la clase: 
1. Utilizaremos la base de datos AdventureWorks2019 (Ver app y arquitectura).
	App : www.adventure-works.com  
	https://dataedo.com/samples/html/AdventureWorks/doc/AdventureWorks_2/home.html
2. Descargar AdventureWorks2019.bak del repositorio oficial
3. Copiar el archivo descargado en la carpeta data de MS SQL Server
4. Restaurar e implementar AdventureWorks2019 en el servidor local
5. Poner en uso AdventureWorks2019 --> USE AdventureWorks2019;
*/
--------------------------------------------------------------------------------
/* SELECT y los predicados ALL | TOP | DISTINCT */

-- sintaxis >>> SELECT name_column FROM name_table;

-- 1. Primeros pasos con SELECT
SELECT @@version;			-- Imprime versión de Motor SQL Server instalado
SELECT (5 + 10)/3;			-- Imprime el resultado de un cálculo
SELECT 'Hola mundo...';		-- Imprime cadena de caracteres
SELECT GETDATE();			-- Imprime la fecha y hora del sistema

-- 2. Recuperando los registros de todas las columnas de una tabla
SELECT ALL *				
FROM Person.Person			
GO							

SELECT *
FROM Person.Person
GO

-- ** Ambas consultas dan el mismo resultado.
--------------------------------------------------------------------------------

-- 3. Recuperando los registros de algunas columnas de una tabla
SELECT 
	person.PersonType, 
	person.FirstName, 
	person.LastName, 
	person.EmailPromotion
FROM Person.Person
GO


-- 4. Utilizando alias de tabla y columna
SELECT 
	per.PersonType AS 'Tipo persona', 
	per.FirstName AS 'Nombres', 
	per.LastName AS 'Apellidos', 
	per.EmailPromotion AS 'Email Promocional'
FROM Person.Person AS per
GO

--------------------------------------------------------------------------------
-- 5. Listar los 50 primeros registros de una tabla
SELECT TOP 50
	per.BusinessEntityID AS 'ID', 
	per.FirstName AS 'Nombres', 
	per.LastName AS 'Apellidos'
FROM Person.Person AS per
GO

-- 6. Listar el 25% de registros de una tabla
SELECT TOP 25 PERCENT 
	per.BusinessEntityID AS 'ID', 
	per.PersonType AS 'Type Person',
	per.FirstName AS 'Nombres', 
	per.LastName AS 'Apellidos'
FROM Person.Person AS per
GO

-- 6. Recuperando registros omitiendo los duplicados en una tabla
SELECT 
	DISTINCT person.PersonType
FROM Person.Person
GO

--------------------------------------------------------------------------------
/* SELECT y la cláusula WHERE 
-- sintaxis >>> 
	SELECT name_column 
	FROM name_table
	WHERE <conditions>;
*/
-- Adventure Works 2019 -> Tabla person
-- IN = Individual		| EM = Employee				| SP = Sales person 
-- SC = Store contact	| VC = Vendedor contact		| GC = General Contact

-- 1. Listar sólo las personas: SC - VC - GC
SELECT *
FROM person.Person AS per
WHERE per.PersonType IN( 'SC', 'VC', 'GC' )
GO

-- 2. Listar las personas de tipo EM cuyo apellido empiece con B
SELECT *
FROM person.Person AS per
WHERE per.PersonType like 'EM' and per.LastName like 'B%'
GO

--------------------------------------------------------------------------------
-- 3. Listar productos cuyo número inicie con FR y el precio de lista sea >= 300 
SELECT 
	pro.Name as 'Nombre', 
	pro.ProductNumber as 'Número Producto',
	pro.ListPrice as 'Precio de lista' 
FROM Production.Product AS  pro
WHERE 
	pro.ProductNumber like 'FR%' 
	and pro.ListPrice > = 300
GO

-- 4. Listar productos cuya cantidad mínima de inventario esté entre 500 y 800
SELECT 
	pro.Name as 'Nombre',
	pro.ProductNumber as 'Número de producto',
	pro.SafetyStockLevel as 'Inventario',
	pro.ListPrice as 'Precio de lista'
FROM Production.Product as pro
WHERE 
	pro.ListPrice between 500 and 800
GO

--------------------------------------------------------------------------------

-- 5. Listar los productos cuyo color no sea null
SELECT 
	pro.ProductNumber as 'Número de producto',
	pro.Name as 'Nombre',
	pro.StandardCost as 'Costo',
	pro.Color as 'Color'
FROM Production.Product as pro
WHERE pro.Color is not null
GO

-- 6. Listar los productos cuyo nombre inicie con letras: C, D o E.
SELECT 
	pro.name as 'Nombre',
	pro.ProductNumber as 'Código',
	pro.ListPrice as 'Precio',
	pro.DaysToManufacture as 'Días de Fabricación'
FROM Production.Product as pro
WHERE pro.Name like '[cde]%';

--------------------------------------------------------------------------------

-- 7. Listar todos los cargos que no contegan la palabra ventas (sales)
SELECT * 
FROM Person.ContactType -- listar registros de tabla ContactType
GO

SELECT *
FROM Person.ContactType as ct
WHERE ct.Name not like '%sales%';


-- 8. Listar todos los cargos cuyo nombre tenga al final la palabra manager.
SELECT * 
FROM Person.ContactType -- listar registros de tabla ContactType
GO

SELECT *
FROM Person.ContactType as ct
WHERE ct.Name like '%manager';

--------------------------------------------------------------------------------
-- 9. Listar los detalles de pedido que cumplan lo siguiente:
-- -- * El id de orden de pedido esté entre 43659 y 43680.
-- -- * Solamente de los productos cuyo Id sea 776, 762 o 710
-- -- * El precio unitario sea mayor que 28

SELECT 
	sod.SalesOrderID AS 'Id Venta',
	sod.ProductID AS 'Id Producto',
	sod.UnitPrice AS 'Precio Unitario'
FROM 
	Sales.SalesOrderDetail AS sod
WHERE 
	(sod.SalesOrderID between 43659 and 43680)
	AND 
	(sod.ProductID in(776, 762, 710))
	AND
	(sod.UnitPrice > 28)
GO

--------------------------------------------------------------------------------
/* SELECT, Funciones y la cláusula GROUP BY 
-- sintaxis >>> 
	SELECT name_column 
	FROM name_table
	WHERE <conditions>
	GROUP BY name_colum;
*/
SELECT * FROM Sales.SalesOrderDetail;
-- 1. Listar la cantidad de productos atendidos en cada orden de pedido.
SELECT 
	DISTINCT sod.SalesOrderID AS 'Id Orden',
	COUNT(sod.SalesOrderID) AS 'Cantidad de Productos' 
FROM Sales.SalesOrderDetail AS sod
GROUP BY sod.SalesOrderID;

-- 2. Obtener el importe total a pagar por cada orden de pedido
SELECT 
	DISTINCT sod.SalesOrderID AS 'Id Orden',
	SUM(sod.OrderQty * sod.UnitPrice) AS 'Total $ Orden'  
FROM Sales.SalesOrderDetail AS sod
GROUP BY sod.SalesOrderID;

--------------------------------------------------------------------------------
-- 3. Obtener el precio unitario mayor, menor y precio promedio.
SELECT 
	max(sod.UnitPrice) AS 'Precio más alto', 
	min(sod.UnitPrice) AS 'Precio más bajo', 
	avg(sod.UnitPrice) AS 'Precio promedio'
FROM Sales.SalesOrderDetail as sod

-- 4. Listar el precio mayor, menor y  el total por cada orden
SELECT 
	SOD.SalesOrderID AS 'Id Orden',
	max(sod.UnitPrice ) AS 'Precio más alto', 
	min(sod.UnitPrice) AS 'Precio más bajo', 
	sum(sod.OrderQty * sod.UnitPrice) as 'Total'
FROM Sales.SalesOrderDetail as sod
GROUP BY sod.SalesOrderID;

-- 5. Obtener la cantidad de productos por cada orden de pedido
SELECT sod.SalesOrderID as 'ID Orden', count(sod.ProductID) as 'Cant. Prod.'
FROM sales.SalesOrderDetail as sod
GROUP BY sod.SalesOrderID;
GO
SELECT * FROM sales.SalesOrderDetail
--------------------------------------------------------------------------------

/* SELECT, Funciones, cláusula GROUP BY y HAVING
-- sintaxis >>> 
	SELECT name_column 
	FROM name_table
	WHERE <conditions>
	GROUP BY name_colums
	HAVING condition; -- permite establecer condiciones para el resultado agrupado
*/


-- 1. Listar órdenes de pedido cuya cantidad de producto sea mayor o igual a 20 
SELECT 
	sod.SalesOrderID as 'ID Orden', 
	count(sod.ProductID) as 'Cant. Prod.'
FROM sales.SalesOrderDetail as sod
GROUP BY sod.SalesOrderID;


CREATE VIEW v_listadp_personas
AS
SELECT 
	p.PersonType,
	p.FirstName,
	p.LastName
FROM Person.Person p
INNER JOIN ..... TABLA
;

execute sp_helptext v_listadp_personas


DROP VIEW listadp_personas;
select * from listadp_personas;







SELECT 
	sod.SalesOrderID as 'ID Orden', 
	count(sod.ProductID) as 'Cant. Prod.'
FROM sales.SalesOrderDetail as sod
GROUP BY sod.SalesOrderID
HAVING count(sod.ProductID) > = 20
GO
--------------------------------------------------------------------------------
-- 2. Listar los productos pedidos, precio unitario, % Dscto y cantidad atendida.
SELECT 
	sod.ProductID as 'Id Producto',
	sod.UnitPrice as 'Unit Price',
	sod.UnitPriceDiscount as '% Discount',
	sum(sod.OrderQty) as 'Cantidad',
	sum(sod.LineTotal) as 'Total'
FROM Sales.SalesOrderDetail as sod
GROUP BY sod.ProductID, sod.UnitPrice, sod.UnitPriceDiscount
HAVING sod.UnitPriceDiscount <> 0
ORDER BY sod.ProductID asc, sod.UnitPrice desc; 

-- 3. Listar las órdenes que tengan entre 50 y 100 unidades de producto.
SELECT 
	sod.SalesOrderID as 'ID Orden', 
	count(sod.ProductID) as 'Cant. Prod.'
FROM sales.SalesOrderDetail as sod
GROUP BY sod.SalesOrderID
HAVING count(sod.ProductID) between 50 and 100
ORDER BY sod.SalesOrderID asc, count(sod.ProductID) desc
GO

--------------------------------------------------------------------------------
/* SELECT, Funciones, cláusula GROUP BY 
   -----> CUBE : Produce subtotales para las combinaciones de agrupamientos
*/

-- 1. Listar cantidades de productos en cada orden de pedido, incluyendo totales 
SELECT 
	sod.ProductID AS 'PRODUCT',
	sod.SalesOrderID AS 'ID ORDEN',
	sum(sod.OrderQty) as 'cantidad'
FROM Sales.SalesOrderDetail as sod
GROUP BY CUBE(sod.SalesOrderID, sod.ProductID);

-- Verificando resultados de CUBE
SELECT 
sod.SalesOrderID,
sum(sod.OrderQty) as 'Total Cantidad'
FROM sales.SalesOrderDetail as sod
GROUP BY sod.SalesOrderID
HAVING sod.SalesOrderID = 47620;

--------------------------------------------------------------------------------
-- 2. Listar cantidades de productos inventariados en su respectiva locación
SELECT 
	pinven.LocationID AS 'ID Loc.',
	pinven.ProductID AS 'ID Prod.',
	sum(pinven.Quantity) AS 'Cantidad'
FROM Production.ProductInventory as pinven
GROUP BY CUBE(pinven.LocationID, pinven.ProductID);


-- Verificando resultados de CUBE
SELECT 
	pinven.LocationID AS 'ID Loc.',
	sum(pinven.Quantity) AS 'Cantidad'
FROM Production.ProductInventory as pinven
GROUP BY pinven.LocationID
HAVING pinven.LocationID = 1;

SELECT * FROM Production.Location
SELECT * FROM Production.ProductInventory

--------------------------------------------------------------------------------
/* SELECT, Funciones, cláusula GROUP BY 
   -----> ROLLUP : Permite generar reportes que contienen subtotales y totales
*/

-- 1. Listar cantidades de productos en cada orden de pedido, incluyendo totales 
SELECT 
	pinven.LocationID AS 'ID Loc.',
	pinven.ProductID AS 'ID Prod.',
	sum(pinven.Quantity) AS 'Cantidad'
FROM Production.ProductInventory as pinven
GROUP BY ROLLUP(pinven.LocationID, pinven.ProductID);

SELECT 
	pinven.LocationID AS 'ID Loc.',
	pinven.ProductID AS 'ID Prod.',
	sum(pinven.Quantity) AS 'Cantidad'
FROM Production.ProductInventory as pinven
GROUP BY CUBE (pinven.LocationID, pinven.ProductID);

--------------------------------------------------------------------------------

-- 2. Listar cantidades de productos inventariados en su respectiva locación
SELECT 
	pinven.LocationID AS 'ID Loc.',
	pinven.ProductID AS 'ID Prod.',
	sum(pinven.Quantity) AS 'Cantidad'
FROM Production.ProductInventory as pinven
GROUP BY ROLLUP (pinven.LocationID, pinven.ProductID);

SELECT 
	pinven.LocationID AS 'ID Loc.',
	pinven.ProductID AS 'ID Prod.',
	sum(pinven.Quantity) AS 'Cantidad'
FROM Production.ProductInventory as pinven
GROUP BY CUBE (pinven.LocationID, pinven.ProductID);

