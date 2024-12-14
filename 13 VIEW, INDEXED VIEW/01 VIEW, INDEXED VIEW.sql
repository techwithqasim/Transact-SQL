/*
SQL Server Views

Syntax:
-------
CREATE VIEW [OR ALTER] schema_name.view_name [(column_list)]
AS
    select_statement;

*/


SELECT
    product_name, 
    brand_name, 
    list_price
FROM
    production.products p
INNER JOIN production.brands b 
        ON b.brand_id = p.brand_id;

-- A View is nothing but a name of query
/*
Syntax:
-------
CREATE VIEW [OR ALTER] schema_name.view_name [(column_list)]
AS
    select_statement;

*/
CREATE VIEW sales.product_prices
AS
SELECT
    product_name, 
    brand_name, 
    list_price
FROM
    production.products p
INNER JOIN production.brands b 
        ON b.brand_id = p.brand_id;

SELECT * FROM sales.product_prices;


-- Similar

SELECT * FROM (SELECT
    product_name, 
    brand_name, 
    list_price
FROM
    production.products p
INNER JOIN production.brands b 
        ON b.brand_id = p.brand_id
) AS prices;


-- Example 2: Daily Sales

CREATE OR ALTER VIEW sales.daily_sales
AS
SELECT 
	YEAR(order_date) AS year,
	MONTH(order_date) AS month,
	DAY(order_date) AS day,
	p.product_id
	product_name,
	quantity * i.list_price AS sales,
	first_name+ ' '+last_name AS customer_name
FROM sales.orders O
INNER JOIN sales.order_items i
	ON o.order_id = i.order_id
INNER JOIN sales.customers c
	ON c.customer_id = o.customer_id
INNER JOIN production.products p
	ON p.product_id = i.product_id
;


SELECT * FROM sales.daily_sales;

SELECT * 
FROM sales.daily_sales
ORDER BY
	year, month, day, product_name;




-- Example 3: Staff Sales
CREATE OR ALTER VIEW sales.staff_sales (
        staff_id, 
        staff_name,
        year, 
        sales
)
AS 
    SELECT
		s.staff_id,
        first_name+' '+last_name e,
        YEAR(order_date),
        SUM(list_price * quantity)
    FROM
        sales.order_items i
    INNER JOIN sales.orders o
        ON i.order_id = o.order_id
    INNER JOIN sales.staffs s
        ON s.staff_id = o.staff_id
    GROUP BY 
        s.staff_id,
		first_name, 
        last_name, 
        YEAR(order_date);

-- ORDER BY YEAR(order_date) can't be in views

SELECT * 
FROM sales.staff_sales
ORDER BY year;

-- SQL SERVER Rename View

-- Method 1: (GUI) --> Databases --> VIEWS >> click(vw_name)

-- Method 2:
EXEC sp_rename 
    @objname = 'sales.saff_sales',
    @newname = 'staff_sales';



-- SQL Server List Views
/*
Syntax:
--------
SELECT 
	OBJECT_SCHEMA_NAME(v.object_id) schema_name,
	v.name
FROM 
	sys.views as v;

*/


-- Using sys.views
------------------
SELECT *
FROM sys.views;

SELECT OBJECT_SCHEMA_NAME(vw.object_id) as schema_name,
	name
FROM sys.views as vw;


-- Using sys.objects & filtering
--------------------------------
SELECT OBJECT_SCHEMA_NAME(vw.object_id) as schema_name,
	name,
	*
FROM sys.views as vw;

SELECT * 
FROM sys.objects
WHERE type = 'V';


SELECT 
	OBJECT_SCHEMA_NAME(o.object_id) as schema_name,
	name
FROM sys.objects o
WHERE type = 'V';


-- Getting View Information

-- sys.sql_module for

-- Method 1: sys.sql_module

SELECT definition, *
FROM sys.all_sql_modules
WHERE object_id = object_id('sales.daily_sales');

-- Method 2: using function
SELECT 
    OBJECT_DEFINITION(
        OBJECT_ID(
            'sales.staff_sales'
        )
    ) view_info;


-- SQL Server DROP VIEW

/*
DROP VIEW [IF EXISTS] 
    schema_name.view_name1, 
    schema_name.view_name2,
    ...;

*/

DROP VIEW sales.product_prices;



-- SQL Server Indexed View

-- Normal View don't have PK(index)
-- views --> filtering --> view scan --> execution increase


CREATE VIEW product_master
WITH SCHEMABINDING
AS 
SELECT
    product_id,
    product_name,
    model_year,
    list_price,
    brand_name,
    category_name
FROM
    production.products p
INNER JOIN production.brands b 
    ON b.brand_id = p.brand_id
INNER JOIN production.categories c 
    ON c.category_id = p.category_id;





SET STATISTICS IO ON
GO

SELECT 
    product_name 
FROM
    dbo.product_master
ORDER BY
    product_name;
GO 




CREATE UNIQUE CLUSTERED INDEX 
    ucidx_product_id 
ON dbo.product_master(product_id);


CREATE NONCLUSTERED INDEX 
    ucidx_product_name 
ON dbo.product_master(product_name);

