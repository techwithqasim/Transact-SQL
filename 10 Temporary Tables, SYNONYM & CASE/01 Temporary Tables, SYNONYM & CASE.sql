/*
sql server temporary tables

1 - temporary tables
2- global temporary tables

*/

/*
syntax:
temporary tale using select into
SELECT    
    customer_id, 
    first_name, 
    last_name, 
    email
INTO #temporary_table
    FROM    
    sales.customers -- fully qualifies path not necessary
WHERE 
    state = 'CA';

	select 
	* from testdb.marketing.customers;

*/

-- temporary table using create statement
CREATE TABLE #haro_products (
    product_name VARCHAR(MAX),
    list_price DEC(10,2)
);

INSERT INTO #haro_products
SELECT
    product_name,
    list_price
FROM 
    BikeStores.production.products
WHERE
    brand_id = 2;

select * from #haro_products

-- global temperory table

CREATE TABLE ##heller_products (
    product_name VARCHAR(MAX),
    list_price DEC(10,2)
);

INSERT INTO ##heller_products
SELECT
    product_name,
    list_price
FROM 
    BikeStores.production.products
WHERE
    brand_id = 3;

DROP TABLE ##heller_products

/*
-- SQL Server Synonym

Syntax:
-------
CREATE SYNONYM [ schema_name_1. ] synonym_name 
FOR object;

object can be :

[ server_name.[ database_name ] . [ schema_name_2 ]. object_name
*/


CREATE SYNONYM contracts
FOR [BikeStores].[sales].[contracts];

SELECT * FROM contracts;

CREATE SYNONYM orders FOR sales.orders;

SELECT * FROM orders;

SELECT name, base_object_name
FROM sys.synonyms;

DROP SYNONYM IF EXISTS contracts;
DROP SYNONYM IF EXISTS orders;

/*
-- Section 13.

-- VARCHAR
-- DECIMAL
-- INT
-- DATE
-- TIME
-- DATETIME
-- CHAR
*/


/*
Section 14. Constraints
-------------------------
1- PRIMARY KEY
2- FOREIGN KEY
3- NOT NULL
4- UNIQUE
5- CHECK

*/

CREATE DATABASE TDB1;
GO

CREATE SCHEMA production;
GO

CREATE TABLE production.categories (
    category_id INT IDENTITY (1, 1) PRIMARY KEY,
    category_name VARCHAR (255) NOT NULL UNIQUE
);

CREATE TABLE production.brands (
    brand_id INT IDENTITY (1, 1) PRIMARY KEY,
    brand_name VARCHAR (255) NOT NULL UNIQUE
);

CREATE TABLE production.products (
    product_id INT IDENTITY (1, 1) PRIMARY KEY,
    product_name VARCHAR (255) NOT NULL UNIQUE,
    brand_id INT NOT NULL,
    category_id INT NOT NULL,
    model_year SMALLINT NOT NULL,
    list_price DECIMAL (10, 2) NOT NULL,
    FOREIGN KEY (category_id) REFERENCES production.categories (category_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (brand_id) REFERENCES production.brands (brand_id) ON DELETE CASCADE ON UPDATE CASCADE,
    CHECK (model_year >= 2000 AND model_year <= YEAR(GETDATE())),
    CHECK (list_price > 0)
);

/*
-- SQL Server CASE

Syntax:
-------
CASE input   
    WHEN e1 THEN r1
    WHEN e2 THEN r2
    ...
    WHEN en THEN rn
    [ ELSE re ]   
END  

*/

-- Grouped Order Status Counts
SELECT 
	CASE order_status
		WHEN 1 THEN 'Pending'
		WHEN 2 THEN 'Processing'
		WHEN 3 THEN 'Rejected'
		WHEN 4 THEN 'Completed'
	END AS order_status,
	count(order_id) as order_count
FROM sales.orders
GROUP BY order_status
ORDER BY order_status;

-- Summarized Order Status Counts
SELECT    
    SUM(CASE
            WHEN order_status = 1
            THEN 1
            ELSE 0
        END) AS 'Pending', 
    SUM(CASE
            WHEN order_status = 2
            THEN 1
            ELSE 0
        END) AS 'Processing', 
    SUM(CASE
            WHEN order_status = 3
            THEN 1
            ELSE 0
        END) AS 'Rejected', 
    SUM(CASE
            WHEN order_status = 4
            THEN 1
            ELSE 0
        END) AS 'Completed', 
    COUNT(*) AS Total
FROM    
    sales.orders;


