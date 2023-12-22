use master;

-- Crear la base de datos
IF DB_ID (N'dbejempl') IS NOT NULL
	DROP DATABASE dbEnrollment
GO
CREATE DATABASE dbejempl
GO

-- Usar la base de datos
USE dbejempl;

-- Crear tablas
CREATE TABLE Clientes (
    id_cliente INT PRIMARY KEY,
    nombre VARCHAR(50),
    edad INT
);

CREATE TABLE Productos (
    id_producto INT PRIMARY KEY,
    nombre VARCHAR(50),
    precio DECIMAL(10, 2)
);

CREATE TABLE Ventas (
    id_venta INT PRIMARY KEY,
    id_cliente INT,
    id_producto INT,
    cantidad INT,
    fecha_venta DATE,
    FOREIGN KEY (id_cliente) REFERENCES Clientes(id_cliente),
    FOREIGN KEY (id_producto) REFERENCES Productos(id_producto)
);

CREATE TABLE Empleados (
    id_empleado INT PRIMARY KEY,
    nombre VARCHAR(50),
    departamento VARCHAR(50)
);

CREATE TABLE Asignaciones (
    id_asignacion INT PRIMARY KEY,
    id_empleado INT,
    id_venta INT,
    FOREIGN KEY (id_empleado) REFERENCES Empleados(id_empleado),
    FOREIGN KEY (id_venta) REFERENCES Ventas(id_venta)
);

-- Insertar registros
INSERT INTO Clientes (id_cliente, nombre, edad) VALUES (1, 'Juan', 30);
INSERT INTO Productos (id_producto, nombre, precio) VALUES (1, 'Producto A', 100.00);
INSERT INTO Ventas (id_venta, id_cliente, id_producto, cantidad, fecha_venta) VALUES (1, 1, 1, 2, '2023-12-22');
INSERT INTO Empleados (id_empleado, nombre, departamento) VALUES (1, 'Maria', 'Ventas');
INSERT INTO Asignaciones (id_asignacion, id_empleado, id_venta) VALUES (1, 1, 1);

-- Cursor
DECLARE @cliente_id INT;
DECLARE cliente_cursor CURSOR FOR
SELECT id_cliente FROM Clientes;
OPEN cliente_cursor;
FETCH NEXT FROM cliente_cursor INTO @cliente_id;
WHILE @@FETCH_STATUS = 0
BEGIN
    -- Procesar cada cliente aquí
    FETCH NEXT FROM cliente_cursor INTO @cliente_id;
END
CLOSE cliente_cursor;
DEALLOCATE cliente_cursor;

-- Procedimiento almacenado
CREATE PROCEDURE ObtenerVentasPorCliente
    @cliente_id INT
AS
BEGIN
    SELECT * FROM Ventas WHERE id_cliente = @cliente_id;
END

-- Consultas y joins
SELECT Clientes.nombre, Ventas.fecha_venta, Productos.nombre
FROM Clientes
JOIN Ventas ON Clientes.id_cliente = Ventas.id_cliente
JOIN Productos ON Ventas.id_producto = Productos.id_producto;
