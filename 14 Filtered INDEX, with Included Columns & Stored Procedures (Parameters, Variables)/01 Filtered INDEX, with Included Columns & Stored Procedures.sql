/*
-- SQL Server Indexes with Included Columns


CREATE UNIQUE INDEX ix_cust_email_inc
ON sales.customers(email)
INCLUDE(first_name,last_name);

*/


CREATE UNIQUE INDEX ix_cust_email
ON sales.customers(email);


select customer_id, email
from sales.customers
where email = 'aaron.knapp@yahoo.com';

select
	first_name,
	last_name,
	email
from sales.customers
where email = 'aaron.knapp@yahoo.com';

select *
from sales.customers

CREATE UNIQUE INDEX ix_cust_email_inc
ON sales.customers(email)
INCLUDE(first_name,last_name);


select
	first_name,
	last_name,
	phone,
	email
from sales.customers
where email = 'aaron.knapp@yahoo.com';


/*
-- SQL Server Filtered Indexes

Syntax:
-----------------------
CREATE INDEX index_name
ON table_name(column_list)
WHERE predicate;

*/

select
	first_name,
	last_name,
	phone
from sales.customers
where phone = '(916) 381-6003';

CREATE INDEX ix_cust_phone
ON sales.customers(phone)
INCLUDE(first_name,last_name) -- optional
WHERE phone IS NOT NULL;

/*
-- SQL Server Indexes on Computed Columns

*/
DROP INDEX IF EXISTS ix_cust_email_inc
ON sales.customers; -- DROP TO AVOID USE IN THIS


select
	first_name,
	last_name,
	email
from 
	sales.customers
where
	SUBSTRING(email, 0,
		CHARINDEX('@', email, 0)
	) = 'garry.espinoza';

select CHARINDEX('@', 'muhammadqasim7k@gmail.com', 0)

select SUBSTRING('muhammadqasim7k@gmail.com', 0,
		CHARINDEX('@', 'muhammadqasim7k@gmail.com', 0))

select SUBSTRING('muhammadqasim7k@gmail.com', 0,16)

ALTER TABLE sales.customers
ADD 
    email_local_part AS 
        SUBSTRING(email, 
            0, 
            CHARINDEX('@', email, 0)
        );


CREATE INDEX ix_cust_email_local_part
ON sales.customers(email_local_part)
INCLUDE(first_name, last_name);

-- uses both both this and primary cluster due to email column
SELECT    
    first_name,
    last_name,
    email
FROM    
    sales.customers
WHERE 
    email_local_part = 'garry.espinoza'; 

-- uses only ix_cust_email_local_part index as first_name and last_name included
SELECT    
    first_name,
    last_name
FROM    
    sales.customers
WHERE 
    email_local_part = 'garry.espinoza';


-- SQL Server Stored Procedures

CREATE PROCEDURE uspProductList
AS
BEGIN
    SELECT 
        product_name, 
        list_price
    FROM 
        production.products
    ORDER BY 
        product_name;
END;


EXECUTE uspProductList;

CREATE PROCEDURE firstprocedure_with_parameter(@prd_name VARCHAR(MAX))
AS
BEGIN
    SELECT 
        product_name, 
        list_price
    FROM 
        production.products
    WHERE 
        product_name = @prd_name;
END;

EXEC firstprocedure_with_parameter 'Electra Cruiser 1 (24-Inch) - 2016';



CREATE PROCEDURE uspFindProducts(
    @min_list_price AS DECIMAL
    ,@max_list_price AS DECIMAL
)
AS
BEGIN
    SELECT
        product_name,
        list_price
    FROM 
        production.products
    WHERE
        list_price >= @min_list_price AND
        list_price <= @max_list_price
    ORDER BY
        list_price;
END;

EXECUTE uspFindProducts 900, 1000;


ALTER PROCEDURE uspFindProducts(
    @min_list_price AS DECIMAL
    ,@max_list_price AS DECIMAL
    ,@name AS VARCHAR(max)
)
AS
BEGIN
    SELECT
        product_name,
        list_price
    FROM 
        production.products
    WHERE
        list_price >= @min_list_price AND
        list_price <= @max_list_price AND
        product_name LIKE '%' + @name + '%'
    ORDER BY
        list_price;
END;

EXECUTE uspFindProducts 
    @min_list_price = 900, 
    @max_list_price = 1000,
    @name = 'Trek';



ALTER PROCEDURE uspFindProducts(
    @min_list_price AS DECIMAL = 0
    ,@max_list_price AS DECIMAL = 999999
    ,@name AS VARCHAR(max)
)
AS
BEGIN
    SELECT
        product_name,
        list_price
    FROM 
        production.products
    WHERE
        list_price >= @min_list_price AND
        list_price <= @max_list_price AND
        product_name LIKE '%' + @name + '%'
    ORDER BY
        list_price;
END;


EXECUTE uspFindProducts @name = 'Trek';


ALTER PROCEDURE uspFindProducts(
    @min_list_price AS DECIMAL = 0
    ,@max_list_price AS DECIMAL = NULL
    ,@name AS VARCHAR(max)
)
AS
BEGIN
    SELECT
        product_name,
        list_price
    FROM 
        production.products
    WHERE
        list_price >= @min_list_price AND
        (@max_list_price IS NULL OR list_price <= @max_list_price) AND
        product_name LIKE '%' + @name + '%'
    ORDER BY
        list_price;
END;

EXECUTE uspFindProducts 
    @min_list_price = 500,
    @name = 'Haro';


-- Variables
/*
Syntax:
---------------------------
DECLARE @model_year SMALLINT;

*/

DECLARE @model_year SMALLINT, 
        @product_name VARCHAR(MAX);
SET @model_year = 2018;
SET @product_name = 'gala';
SELECT @model_year, @product_name;


SELECT 
        COUNT(*) 
    FROM 
        production.products;



CREATE  PROC uspGetProductList(
    @model_year SMALLINT
) AS 
BEGIN
    DECLARE @product_list VARCHAR(MAX);

    SET @product_list = '';

    SELECT
        @product_list = @product_list + product_name 
                        + CHAR(10)
    FROM 
        production.products
    WHERE
        model_year = @model_year
    ORDER BY 
        product_name;

    PRINT @product_list;
END;

EXEC uspGetProductList 2018;

SELECT
        product_name
    FROM 
        production.products
    WHERE
        model_year = 2018
    ORDER BY 
        product_name;