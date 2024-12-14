-- Example 2: A CTE to return the sales amounts by sales staffs in 2018
SELECT 
	first_name + ' ' + last_name as staff,
	SUM(quantity * list_price) as sales,
	YEAR(order_date) as year
FROM sales.orders o
INNER JOIN sales.order_items i ON o.order_id = i.order_id
INNER JOIN sales.staffs s ON o.staff_id = s.staff_id
GROUP BY 
	first_name + ' ' + last_name,
	YEAR(order_date)
HAVING 
	YEAR(order_date) = 2018

-- SQL Server CTEs 
-- CTEs Stands for Common Table Expressions
/*
Syntax
------
WITH expression_name[(column_name [,...])]
AS
    (CTE_definition)
SQL_statement;
*/

WITH cte_total_sales (staff, sales, year) AS (
	SELECT 
		first_name + ' ' + last_name,
		SUM(quantity * list_price),
		YEAR(order_date)
	FROM sales.orders o
	INNER JOIN sales.order_items i ON o.order_id = i.order_id
	INNER JOIN sales.staffs s ON o.staff_id = s.staff_id
	GROUP BY 
		first_name + ' ' + last_name,
		YEAR(order_date)
)

SELECT staff, sales, year
FROM cte_total_sales
WHERE year =2018;

/*
Example 2: Write a CTE to return the 
average number of sales orders in 2018 
for all sales staffs.
*/

-- Query:
SELECT 
		staff_id,
		COUNT(*) orders_count
FROM sales.orders
WHERE YEAR(order_date) = 2018
GROUP BY staff_id;


-- Query With CTE:
WITH cte_average_sales AS (
	SELECT 
		staff_id,
		COUNT(*) orders_count
	FROM sales.orders
	WHERE YEAR(order_date) = 2018
	GROUP BY staff_id
)

SELECT AVG(orders_count) average_orders_by_Staff 
FROM cte_average_sales;

-- Multiple	SQL Server CTE in a single query
/*The following example uses two CTE
cte_category_counts and cte_category_sales 
to return the number of the products and 
sales for each product category. 
The outer query joins two CTEs using the 
category_id column.
*/

WITH cte_category_counts (
	category_id, 
    category_name, 
    product_count
)
AS (
	SELECT 
		c.category_id,
		c.category_name,
		COUNT(p.product_id)
	FROM production.products p
	INNER JOIN production.categories c
		ON p.category_id = c.category_id
	GROUP BY c.category_id, c.category_name
),
cte_category_sales (
		category_id,
		sales
)
AS (
	SELECT 
		p.category_id,
		SUM(i.quantity * i.list_price * (1 - i.discount))
	FROM sales.order_items i
	INNER JOIN sales.orders o 
			ON o.order_id = i.order_id
	INNER JOIN production.products p
			ON p.product_id = i.product_id
	GROUP BY p.category_id
)

SELECT 
	cc.category_id,
	cc.category_name,
	cc.product_count,
	cs.sales
FROM 
	cte_category_counts cc
	INNER JOIN cte_category_sales cs
		ON cc.category_id = cs.category_id
ORDER BY cc.category_name;


--- Example on Web

WITH cte_category_counts (
    category_id, 
    category_name, 
    product_count
)
AS (
    SELECT 
        c.category_id, 
        c.category_name, 
        COUNT(p.product_id)
    FROM 
        production.products p
        INNER JOIN production.categories c 
            ON c.category_id = p.category_id
    GROUP BY 
        c.category_id, 
        c.category_name
),
cte_category_sales(category_id, sales) AS (
    SELECT    
        p.category_id, 
        SUM(i.quantity * i.list_price * (1 - i.discount))
    FROM    
        sales.order_items i
        INNER JOIN production.products p 
            ON p.product_id = i.product_id
        INNER JOIN sales.orders o 
            ON o.order_id = i.order_id
    WHERE order_status = 4 -- completed
    GROUP BY 
        p.category_id
) 

SELECT 
    c.category_id, 
    c.category_name, 
    c.product_count, 
    s.sales
FROM
    cte_category_counts c
    INNER JOIN cte_category_sales s 
        ON s.category_id = c.category_id
ORDER BY 
    c.category_name;


-- SQL Server recursive CTE
/*
Syntax
-------
WITH expression_name (column_list)
AS
(
    -- Anchor member
    initial_query  
    UNION ALL
    -- Recursive member that references expression_name.
    recursive_query  
)
-- references expression name
SELECT *
FROM   expression_nam
*/

-- Example1: ecursive CTE to returns weekdays from Monday to Saturday

WITH cte_daysName (n, weekday)
AS (
	SELECT
		0,
		DATENAME(DW,0)
	UNION ALL
	SELECT
		n+1,
		DATENAME(DW, n+1)
	FROM cte_daysName
	WHERE n<6
)

SELECT n, weekday
FROM cte_daysName;

SELECT *
FROM cte_daysName;

-- Another Example Recursive CTE
/*
In this table, a staff reports to zero or one manager.
A manager may have zero or more staffs. The top manager
has no manager. The relationship is specified in the
values of the manager_id column. If a staff does not
report to any staff (in case of the top manager), the
value in the manager_id is NULL.
*/

WITH cte_hierarchical_data AS (
    SELECT       
        staff_id, 
        first_name,
        manager_id
    FROM       
        sales.staffs
    WHERE manager_id IS NULL
    UNION ALL
    SELECT 
        s.staff_id, 
        s.first_name,
        s.manager_id
    FROM 
        sales.staffs s
        INNER JOIN cte_hierarchical_data hd
            ON hd.staff_id = s.manager_id
)
SELECT * FROM cte_hierarchical_data;

-- Pivot Tables

SELECT *
	FROM (
	SELECT 
		category_name, 
		product_id,
		model_year
	FROM 
		production.products p
		INNER JOIN production.categories c 
			ON c.category_id = p.category_id
) t
PIVOT (
	COUNT(product_id)
	FOR category_name IN (
	[Children Bicycles],
	[Comfort Bicycles],
	[Cruisers Bicycles],
	[Cyclocross Bicycles],
	[Electric Bikes],
	[Mountain Bikes],
	[Road Bikes])
) AS pivot_table;