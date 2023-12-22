use dbEnrollment;

-- Busqueda con Joins

-- Seleccionar nombres de estudiantes y nombre de carrera
SELECT s.names, s.last_names, c.names AS career_name
FROM student s
JOIN enrollment e ON s.id = e.student_id -- Unir con la tabla de matrículas
JOIN careers c ON e.careers_id = c.id; -- Unir con la tabla de carreras

-- Seleccionar nombres de estudiantes y nombre de curso
SELECT s.names, s.last_names, co.names AS course_name
FROM student s
JOIN enrollment e ON s.id = e.student_id -- Unir con la tabla de matrículas
JOIN careers_detail cd ON e.careers_id = cd.careers_id -- Unir con los detalles de carrera
JOIN course co ON cd.course_code = co.code; -- Unir con la tabla de cursos

-- Seleccionar nombres de estudiantes, nombre de carrera, nombre de curso y nombre de profesor
SELECT s.names AS student_name, s.last_names AS student_last_name, 
       c.names AS career_name, co.names AS course_name, 
       t.names AS teacher_name
FROM student s
JOIN enrollment e ON s.id = e.student_id -- Unir con la tabla de matrículas
JOIN careers_detail cd ON e.careers_id = cd.careers_id -- Unir con los detalles de carrera
JOIN course co ON cd.course_code = co.code -- Unir con la tabla de cursos
JOIN teachers t ON cd.teachers_id = t.id -- Unir con la tabla de profesores
JOIN careers c ON cd.careers_id = c.id; -- Unir con la tabla de carreras



--Cursor
-- Declarar una variable para almacenar el nombre del estudiante
DECLARE @studentName VARCHAR(100)

-- Declarar un cursor para recorrer los nombres de la tabla student
DECLARE studentCursor CURSOR FOR
SELECT names FROM student

-- Abrir el cursor
OPEN studentCursor

-- Obtener el primer nombre de estudiante
FETCH NEXT FROM studentCursor INTO @studentName

-- Mientras haya nombres de estudiantes por recorrer
WHILE @@FETCH_STATUS = 0
BEGIN
   -- Procesar el nombre del estudiante (en este caso, imprimirlo)
   PRINT @studentName
   
   -- Obtener el siguiente nombre de estudiante
   FETCH NEXT FROM studentCursor INTO @studentName
END

-- Cerrar y liberar el cursor
CLOSE studentCursor
DEALLOCATE studentCursor

-- #02
-- Declarar una variable para almacenar el nombre del profesor
DECLARE @teacherName VARCHAR(100)

-- Declarar un cursor para recorrer los nombres de la tabla TEACHERS
DECLARE teacherCursor CURSOR FOR
SELECT names FROM TEACHERS

-- Abrir el cursor
OPEN teacherCursor

-- Obtener el primer nombre de profesor
FETCH NEXT FROM teacherCursor INTO @teacherName

-- Mientras haya nombres de profesores por recorrer
WHILE @@FETCH_STATUS = 0
BEGIN
   -- Procesar el nombre del profesor (en este caso, imprimirlo)
   PRINT @teacherName
   
   -- Obtener el siguiente nombre de profesor
   FETCH NEXT FROM teacherCursor INTO @teacherName
END

-- Cerrar y liberar el cursor
CLOSE teacherCursor
DEALLOCATE teacherCursor


--#03
DECLARE @courseCode CHAR(4)
DECLARE @courseName VARCHAR(100)
DECLARE courseCursor CURSOR FOR
SELECT code, names FROM course

OPEN courseCursor
FETCH NEXT FROM courseCursor INTO @courseCode, @courseName
WHILE @@FETCH_STATUS = 0
BEGIN
   -- Procesar los datos del curso, por ejemplo, actualizar el nombre del curso
   IF @courseName = 'Old Name' 
   BEGIN
       SET @courseName = 'New Name'
       UPDATE course SET names = @courseName WHERE code = @courseCode
   END

   -- Obtener el siguiente curso
   FETCH NEXT FROM courseCursor INTO @courseCode, @courseName
END

CLOSE courseCursor
DEALLOCATE courseCursor


--Procedimiento Almacenado
CREATE PROCEDURE ProcessStudentNames
AS
BEGIN
    DECLARE @studentName VARCHAR(100)
    DECLARE studentCursor CURSOR FOR
    SELECT names FROM student

    OPEN studentCursor
    FETCH NEXT FROM studentCursor INTO @studentName
    WHILE @@FETCH_STATUS = 0
    BEGIN
       -- Procesar el nombre del estudiante (por ejemplo, realizar alguna operación)
       -- ...

       FETCH NEXT FROM studentCursor INTO @studentName
    END

    CLOSE studentCursor
    DEALLOCATE studentCursor
END

sp_helptext 'ProcessStudentNames';

