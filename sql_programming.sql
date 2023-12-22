---------------------------------------------------------------------------------
-- Tema     : Programación con SQL 
-- Profesor : Jesús Canales
-- Curso    : Base de Datos A1 
---------------------------------------------------------------------------------
---<> Variables <>---
-- Entidad a la que se asigna un valor y que puede cambiar durante el proceso.
-- Sintaxis:
--	  DECLARE @name_variable <datatype>
--	  SET @name_variable = <value initial>

--- 1. Imprimir un mensaje
DECLARE @mensaje varchar(100)
SET @mensaje = 'Hola mundo...'
PRINT @mensaje
GO

--- 2. Sumar números
DECLARE @numero_uno int = 30, @numero_dos int = 70, @suma int
SET @suma = @numero_uno + @numero_dos
PRINT 'El valor de la sumatoria es: ' + convert(char(3), @suma)
GO
---------------------------------------------------------------------------------
--- 3. Concatenar cadenas de texto
DECLARE @nombre varchar(60), @apellido varchar(90)
SET @nombre = 'Rosario'
SET @apellido = 'Chumpitaz Manco'
PRINT 'Persona: ' + UPPER(@apellido) + ', ' + @nombre

--- 4. Calcular edad a partir de una fecha de nacimiento
SET DATEFORMAT dmy;
DECLARE @fecha_nacimiento date, @edad int
SET @fecha_nacimiento = '11/12/2000'
SET @edad = DATEDIFF(year, @fecha_nacimiento, getdate())
PRINT 'Tu edad es: ' + convert(char(2), @edad)

--- 5. Calcular total para factura
DECLARE @monto decimal(8,2) = 1000, @igv decimal(8,2), @total decimal(8,2)
SET @igv = @monto * 0.18
SET @total = @monto + @igv
PRINT 'El monto es: ' + 'S/. ' + convert(char(10), @monto)
PRINT 'El IGV es: ' + 'S/. ' + convert(char(10), @igv)
PRINT 'El total es: ' + 'S/. ' + convert(char(10), @total)

---------------------------------------------------------------------------------
---<> Recursos para la clase <>---
--- Utilizaremos la base de datos Enrollment.
--- Diseño físico de la base de datos Enrollment: https://bit.ly/3sgWE2K  
--- Implementar script de estructura y datos de la base de datos.
--- Poner en uso Enrollment --> USE dbEnrollment;

--- 1. Obtener datos de profesor a partir de su id
SET DATEFORMAT dmy;
DECLARE @id int, @fecha_registro date, @nombres varchar(60), @apellidos varchar(100)
DECLARE @especialidad varchar(90), @celular char(9), @correo varchar(100)
SET @id = 1
SELECT 
	@fecha_registro =  register_date,
	@nombres = names,
	@apellidos = last_names,
	@especialidad = specialty,
	@celular = phone,
	@correo = email
FROM teachers 
WHERE id = @id
PRINT 'Se registró el: ' + convert(varchar(10), @fecha_registro)
PRINT 'Apellidos y nombres: ' + concat(upper(@apellidos), ', ', @nombres)
PRINT 'Especialidad: ' + @especialidad
PRINT 'Celular: ' + @celular
PRINT 'Correo electrónico: ' + @correo
GO

