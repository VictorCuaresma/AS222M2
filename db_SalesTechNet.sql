/* Yo Pregunto, tú respondes (3 primeras respuestas) */

/* Crear base de datos con valores predeterminados SalesTechNet */
DROP DATABASE IF EXISTS db_SalesTechNet;CREATE DATABASE db_SalesTechNet;/* Poner en uso db_SalesTechNet */USE db_SalesTechNet;/* Crear esquema llamado Ventas */CREATE SCHEMA ventas;/* Crear esquema llamado RRHH */
CREATE SCHEMA RRHH;/* Listar esquemas de base de datos */
SELECT schema_nameFROM information_schema.schemata;/* Procedemos a crear una tabla Cliente con los campos: DNI, Nombres y Apellidos */CREATE TABLE cliente (    dni VARCHAR(20) PRIMARY KEY,    nombre VARCHAR(255),    apellidos VARCHAR(255));/* Listar las tablas de la base de datos activa */SELECT table_name = t.nameFROM sys.tables tINNER JOIN sys.schemas s ON t.schema_id = s.schema_id;/* Transferir la tabla Cliente al esquema Ventas */ALTER SCHEMA ventas TRANSFER dbo.Cliente;/* Crear una tabla Producto con los campos: Codigo, Descripción y Precio */
/* Transferir la tabla Producto al esquema Ventas */
CREATE TABLE producto (    codigo VARCHAR(10) PRIMARY KEY,    descripcion VARCHAR(50) NOT NULL,    precio DECIMAL(10,2) NOT NULL);GOUSE ventas;GOALTER SCHEMA ventas TRANSFER dbo.producto;GO/* Crear una tabla Vendedor con los campos: DNI, Nombres, Apellidos y Cargo */
/* Transferir la tabla vendedor al esquema RRHH */
CREATE TABLE vendedor (    dni VARCHAR(15) PRIMARY KEY,    nombre VARCHAR(50),    apellido VARCHAR(50),    cargo VARCHAR(50));ALTER SCHEMA RRHH Transfer dbo.vendedor--- Listar los tipos de datos de SQL Server LocalSELECT name AS 'Tipo de Dato'FROM sys.types;-- Crear tipo de dato SEXO (1 caracter)
-- Crear tipo de dato DNI (8 caracter)
-- Crear tipo de dato PRECIO (decimal 8,2)CREATE TYPE sexo FROM varchar(1);CREATE TYPE dni FROM varchar(8);CREATE TYPE precio FROM decimal(8,2);/* Eliminar tipos de datos de usuario: sexo, dni y precio */
DROP TYPE SEXO;DROP TYPE DNI;DROP TYPE PRECIO;

/* Crear una tabla categoria: codigo, nombre y descripcion, con 4 registros y los liste. Esta debe ser una tabla de tipo variable */
-- Crear el tipo de tabla variableDECLARE @CategoriaTableType TABLE (    codigo INT,    nombre VARCHAR(255),    descripcion VARCHAR(MAX));-- Insertar registros en la tabla categoriaINSERT INTO @CategoriaTableType (codigo, nombre, descripcion)VALUES    (1, 'Categoría 1', 'Descripción de la categoría 1'),    (2, 'Categoría 2', 'Descripción de la categoría 2'),    (3, 'Categoría 3', 'Descripción de la categoría 3'),    (4, 'Categoría 4', 'Descripción de la categoría 4');SELECT codigo, nombre, descripcionFROM @CategoriaTableType;-- Crear un filegroup llamado TECNOLOGIA y asociar un archivo físico en su carpeta data de la unidad c de su disco duroALTER DATABASE db_SalesTechNetADD FILEGROUP tecnologia;ALTER DATABASE db_SalesTechNetADD FILE (    NAME = 'tecnologia_data',    FILENAME = 'C:\data\tecnologia_data.mdf',    SIZE = 100MB,    MAXSIZE = UNLIMITED,    FILEGROWTH = 10MB)TO FILEGROUP tecnologia;/* Tablas */-- Tablas temporales (Locales/Globales)--Tabla GlobalesCREATE TABLE ##tablaEjemplo(Id INT IDENTITY(1,1),Descripcion Varchar (50),FechaActualizacion DATETIME )SELECT * FROM  ##tablaEjemploDROP TABLE  ##tablaEjemploCREATE TABLE #tablaEjemplo(Id INT IDENTITY(1,1),Descripcion Varchar (50),FechaActualizacion DATETIME )SELECT * FROM #tablaEjemploGO-- Tablas particionadas-- Paso 1: Crear los filegroups con sus respectivos datafilesALTER DATABASE db_SalesTechNetADD FILEGROUP VENTA2023;ALTER DATABASE db_SalesTechNetADD FILE(NAME = 'VENTAS_2023', FILENAME = 'C:\DATA\VENTAS_2023.NDF')TO FILEGROUP VENTA2023;ALTER DATABASE db_SalesTechNetADD FILEGROUP VENTA2024;ALTER DATABASE db_SalesTechNetADD FILE(NAME = 'VENTAS_2024', FILENAME = 'C:\DATA\VENTAS_2024.NDF')TO FILEGROUP VENTA2024;ALTER DATABASE db_SalesTechNetADD FILEGROUP VENTA2025;ALTER DATABASE db_SalesTechNetADD FILE(NAME = 'VENTAS_2025', FILENAME = 'C:\DATA\VENTAS_2025.NDF')TO FILEGROUP VENTA2025;-- Paso 2 Función de particiónCREATE PARTITION FUNCTION fnpNumerador(int)
AS RANGE LEFT
FOR VALUES(50, 200)
GO

-- Paso 3 Esquema de partición
CREATE PARTITION SCHEME scpIdentificador
AS PARTITION fnpNumerador
TO('VENTA2023','VENTA2024', 'VENTA2025')
GO

-- Creamos la tabla Particionada
CREATE TABLE VENTA
(
	ID int,
	CODCLIENTE char(4),
	CODVENDEDOR char(4),
	FECVENTA date
) ON scpIdentificador(ID)
GO

-- Insertamos los primeros registros
SET DATEFORMAT dmy
INSERT INTO VENTA
VALUES
(10, 'C001', 'V001', '10/05/2023'),
(60, 'C003', 'V005', '20/05/2024'),
(250, 'C007', 'V002', '10/05/2025')
GO

SELECT * FROM venta;

-- Verificando que los registros hayan ingresado en su partición respectiva
SELECT * , $PARTITION.fnpNumerador(id) AS 'NUMERO PARTICIÓN'
FROM VENTA
GO
-- Insertando más registros de prueba
SET DATEFORMAT dmy
INSERT INTO VENTA
VALUES
(25, 'C001', 'V001', '10/05/2023'),
(115, 'C003', 'V005', '20/05/2024'),
(300, 'C007', 'V002', '10/05/2025')
GO