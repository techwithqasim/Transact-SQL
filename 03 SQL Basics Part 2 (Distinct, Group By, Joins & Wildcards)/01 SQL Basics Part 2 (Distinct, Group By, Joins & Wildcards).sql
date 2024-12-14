USE BikeStores;

-- SECTION 04: FILTERING DATA
-- DISTINCT always takes first value of duplicate records
-- DISTINCT always takes NULL values first

SELECT city
FROM sales.customers
ORDER BY city;

SELECT DISTINCT city
FROM sales.customers
ORDER BY city;

SELECT city, state
FROM sales.customers
ORDER BY city, state;

SELECT DISTINCT city, state
FROM sales.customers
ORDER BY city, state;

SELECT phone
FROM sales.customers
ORDER BY phone;

SELECT DISTINCT phone
FROM sales.customers
ORDER BY phone;

-- DISTINCT vs. GROUP BY

SELECT city, state
FROM sales.customers
GROUP BY city, state
ORDER BY city, state;

SELECT DISTINCT city, state
FROM sales.customers;

-- single line comment
/*
SELECT
    select_list
FROM
    table_name
WHERE
    search_condition;

NOTE: search_condition can have
1. OPERATOR LIKE <,>, <>/!=, IN, LIKE
2. LOGICAL OPERATORS AND, OR, NOT,
*/

SELECT 
	product_id, 
	product_name, 
	model_year, 
	list_price, 
	category_id
FROM production.products
WHERE category_id = 1 
	AND model_year = 2018 
	AND list_price > 319.99
ORDER BY list_price DESC;

SELECT 
	product_id, 
	product_name, 
	model_year, 
	list_price, 
	category_id
FROM production.products
WHERE list_price BETWEEN 900.99 AND 2000.99
	AND model_year = 2018
ORDER BY list_price DESC;


SELECT 
	product_id, 
	product_name, 
	model_year, 
	list_price, 
	category_id
FROM production.products
WHERE category_id = 1 OR
	model_year = 2018
ORDER BY list_price DESC;


SELECT 
	product_id, 
	product_name, 
	model_year, 
	list_price, 
	category_id
FROM production.products
WHERE list_price IN (2799.99, 1799.99, 899.99)
ORDER BY list_price DESC;


SELECT 
	product_id, 
	product_name, 
	model_year, 
	list_price, 
	category_id
FROM production.products
WHERE product_name LIKE '%Townie%'
ORDER BY list_price DESC;

SELECT 
	product_id, 
	product_name, 
	model_year, 
	list_price, 
	category_id
FROM production.products
WHERE product_name LIKE '%Electra%'
ORDER BY list_price DESC;

/*

Symbol	Description
%	Represents zero or more characters
_	Represents a single character
[]	Represents any single character within the brackets *
^	Represents any character not in the brackets *
-	Represents any single character within the specified range *
{}	Represents any escaped character **

* Not supported in PostgreSQL and MySQL databases.
** Supported only in Oracle databases.

Link: https://www.w3schools.com/sql/sql_wildcards.asp
*/

SELECT 
	product_id, 
	product_name, 
	model_year, 
	list_price, 
	category_id
FROM production.products
WHERE product_name LIKE '__ectra%'
ORDER BY list_price DESC;

-- Alias

SELECT 
	product_id, 
	product_name, 
	model_year AS year, 
	list_price Product_Price, 
	category_id 'Product Category'
FROM production.products


-- SECTION-05: JOINING TABLES

CREATE SCHEMA hr;
go

CREATE TABLE hr.candidates(
	id INT IDENTITY(1,1) PRIMARY KEY,
	fullname VARCHAR(100) NOT NULL
);

CREATE TABLE hr.employees(
	id INT IDENTITY(1,1) PRIMARY KEY,
	fullname VARCHAR(100) NOT NULL
);

INSERT INTO hr.candidates(fullname)
VALUES
	('John Doe'),
    ('Lily Bush'),
    ('Peter Drucker'),
    ('Jane Doe');

SELECT * FROM hr.candidates;

INSERT INTO hr.employees(fullname)
VALUES
	('John Doe'),
    ('Jane Doe'),
    ('Michael Scott'),
    ('Jack Sparrow');

SELECT * FROM hr.employees;

-- INNER join

-- LEFT TABLE ==> candidates
-- RIGHT TABLE ==> employees

SELECT
	c.id,
	c.fullname,
	e.id,
	e.fullname
FROM hr.candidates c
INNER JOIN hr.employees e
ON c.fullname = e.fullname;

-- LEFT JOIN

SELECT
	c.id,
	c.fullname,
	e.id,
	e.fullname
FROM hr.candidates c
LEFT JOIN hr.employees e
ON c.fullname = e.fullname;

-- RIGHT JOIN

SELECT
	c.id,
	c.fullname,
	e.id,
	e.fullname
FROM hr.candidates c
RIGHT JOIN hr.employees e
ON c.fullname = e.fullname;

-- OUTER / FULL JOIN

SELECT
	c.id,
	c.fullname,
	e.id,
	e.fullname
FROM hr.candidates c
FULL JOIN hr.employees e
ON c.fullname = e.fullname;

-- LEFT ANTI JOIN

SELECT
	c.id,
	c.fullname,
	e.id,
	e.fullname
FROM hr.candidates c
LEFT JOIN hr.employees e
ON c.fullname = e.fullname
WHERE e.id IS NULL;

-- RIGHT ANTI JOIN

SELECT
	c.id,
	c.fullname,
	e.id,
	e.fullname
FROM hr.candidates c
RIGHT JOIN hr.employees e
ON c.fullname = e.fullname
WHERE c.id IS NULL;

-- CROSS JOIN

a = (1,2,3)
b = (a,b,c)
axb = (1a)(2a)(3a)(1b)(2b)(3b)(1c)(2c)(3c)

CREATE DATABASE testing;
go

CREATE SCHEMA cross_join;
go

USE testing;
go

CREATE TABLE cross_join.Meals(MealName VARCHAR(100));
CREATE TABLE cross_join.Drinks(DrinkName VARCHAR(100));

INSERT INTO cross_join.Drinks
VALUES('Orange Juice'), ('Tea'), ('Cofee');

INSERT INTO cross_join.Meals
VALUES('Omlet'), ('Fried Egg'), ('Sausage');

SELECT *
FROM cross_join.Drinks;

SELECT *
FROM cross_join.Meals;

SELECT *
FROM cross_join.Meals
CROSS JOIN cross_join.Drinks;

/*
HOMEWORK
1. Wildcards -- PPT
2. SELF JOIN
3. JOINS practice on pandas joins tables
*/

-- SELF JOIN

-- Example:
CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    name VARCHAR(50),
    manager_id INT
);

INSERT INTO employees (employee_id, name, manager_id)
VALUES
    (1, 'Alice', NULL),
    (2, 'Bob', 1),
    (3, 'Charlie', 1),
    (4, 'David', 2),
    (5, 'Eve', 2);

SELECT E1.name AS employee_name, E2.name AS manager_name
FROM employees E1
LEFT JOIN employees E2
ON E1.manager_id = E2.employee_id;
