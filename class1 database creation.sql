-- Installation Verification
select @@VERSION;

-- Database creation
-- LHS (object Explorer) >> Databases >> New Database >> given_name >> OK
CREATE DATABASE BikeStores;

-- Use database
USE BikeStores;

-- Schema creation
CREATE SCHEMA sales;
go

CREATE SCHEMA production;
go

-- Table creation
CREATE TABLE production.categories(
	category_id INT IDENTITY(1,1) PRIMARY KEY,
	category_name VARCHAR(255)
);

CREATE TABLE production.brands(
	brand_id INT IDENTITY(1,1) PRIMARY KEY,
	brand_name VARCHAR(255)
);

CREATE TABLE production.products(
	product_id INT IDENTITY(1,1) PRIMARY KEY,
	product_name VARCHAR(255),
	brand_id INT NOT NULL,
	category_id INT NOT NULL,
	model_year SMALLINT NOT NULL,
	list_price DECIMAL(10,2) NOT NULL,
	FOREIGN KEY (brand_id)
		REFERENCES production.brands(brand_id)
		ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (category_id)
		REFERENCES production.categories(category_id)
		ON DELETE CASCADE ON UPDATE CASCADE
);

-- deleting tables
DROP TABLE production.products;

-- checking data in table
SELECT * FROM production.categories;

-- adding row in table
--INSERT INTO production.categories(category_id, category_name) VALUES(1, 'Saylani'); -- as already INDENTITY in category_id
INSERT INTO production.categories(category_name) VALUES('Saylani');

-- delete all rows from table
TRUNCATE TABLE production.categories;

--
DROP TABLE production.product;
DROP TABLE production.categories;
DROP TABLE production.brands;

-- using IF EXISTS
DROP TABLE IF EXISTS production.brands;