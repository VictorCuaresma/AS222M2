/* Poner en uso BD Master */
USE master
GO

/* Crear base de datos dbCompuTech */
IF DB_ID (N'dbCompuTech') IS NOT NULL
	DROP DATABASE dbCompuTech
GO
CREATE DATABASE dbCompuTech
GO

/* Poner en uso base de datos dbCompuTech */
USE dbCompuTech
GO

/* Crear esquemas: PERSONA, PRODUCTO, VENTAS */
CREATE SCHEMA PERSONA
GO
CREATE SCHEMA PRODUCTO
GO
CREATE SCHEMA VENTAS
GO

/* Creamos tabla client desde el esquema PERSONA */
CREATE TABLE PERSONA.client
(
	id int identity(1,1),
	names varchar(60),
	last_names varchar(90),
	email varchar(100),
	register_date date default getdate(),
	brithday date,
	status char(1) default ('A'),
	CONSTRAINT client_pk PRIMARY KEY (id),
	CONSTRAINT email_unique UNIQUE (email)
)
GO

/* Crear tabla product desde el esquema PRODUCTO */
CREATE TABLE PRODUCTO.product
(
	code char(3),
	description varchar(120),
	category varchar(90),
	stock int,
	price decimal(8,2),
	status char(1) default ('A'),
	CONSTRAINT product_pk PRIMARY KEY (code),
	CONSTRAINT stock_quantity CHECK(stock >0),
	CONSTRAINT price CHECK(price >0)
)
GO

/* Crear tabla sale desde el esquema VENTAS */
CREATE TABLE VENTAS.sale
(
	id int identity(1,1),
	register_date date default getdate(),
	client_id int,
	status char(1) default ('A'),
	CONSTRAINT sale_pk PRIMARY KEY (id)
)
GO

/* Crear tabla sale_detail desde el esquema VENTAS */
CREATE TABLE VENTAS.sale_detail
(
	id int identity(1,1),
	sale_id int,
	product_code char(3),
	quantity int,
	CONSTRAINT sale_detail_pk PRIMARY KEY (id),
	CONSTRAINT quantity CHECK(quantity > 0)
)
GO

/* Creamos relación entre tablas sale y client */
ALTER TABLE VENTAS.sale
	ADD CONSTRAINT sale_client FOREIGN KEY (client_id)
	REFERENCES PERSONA.client (id)
GO

/* Creamos relación entre tablas sale_detail y product */
ALTER TABLE VENTAS.sale_detail
	ADD CONSTRAINT sale_detail_product FOREIGN KEY (product_code)
	REFERENCES PRODUCTO.product (code)
GO

/* Creamos relación entre tablas sale y sale_detail */
ALTER TABLE VENTAS.sale_detail
	ADD CONSTRAINT sale_detail_sale FOREIGN KEY (sale_id)
	REFERENCES VENTAS.sale (id)
GO

