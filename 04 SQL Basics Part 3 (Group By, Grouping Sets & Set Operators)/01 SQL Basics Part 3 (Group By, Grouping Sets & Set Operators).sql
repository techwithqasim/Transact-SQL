-- Group By

SELECT city, count(city) AS Count_of_City
FROM sales.customers
GROUP BY city
ORDER BY city;


-- 2nd Query

SELECT order_id, Year (order_date) as order_year
FROM sales.orders
GROUP BY order_id, Year (order_date);

-- Aggregate Functions
-- SUM, AVG, MIN, MAX AND COUNT

SELECT category_id, SUM (list_price)
FROM production.products
GROUP BY category_id;

SELECT category_id, MIN (list_price)
FROM production.products
GROUP BY category_id;

SELECT category_id, MAX (list_price)
FROM production.products
GROUP BY category_id;

SELECT category_id, AVG (list_price)
FROM production.products
GROUP BY category_id;

SELECT category_id, SUM (list_price) AS sum_value, 
					MIN (list_price) AS min_value, 
					MAX (list_price) AS max_value, 
					AVG (list_price) AS avg_value
FROM production.products
GROUP BY category_id;

-- Having

SELECT category_id, SUM (list_price) AS sum_value, 
					MIN (list_price) AS min_value, 
					MAX (list_price) AS max_value, 
					AVG (list_price) AS avg_value
FROM production.products
GROUP BY category_id
HAVING MIN (list_price) > 100 AND MAX (list_price) > 3000;

-- TABLE

SELECT
    b.brand_name AS brand,
    c.category_name AS category,
    p.model_year,
    round(
        SUM (
            quantity * i.list_price * (1 - discount)
        ),
        0
    ) sales INTO sales.sales_summary
FROM
    sales.order_items i
INNER JOIN production.products p ON p.product_id = i.product_id
INNER JOIN production.brands b ON b.brand_id = p.brand_id
INNER JOIN production.categories c ON c.category_id = p.category_id
GROUP BY
    b.brand_name,
    c.category_name,
    p.model_year
ORDER BY
    b.brand_name,
    c.category_name,
    p.model_year;

SELECT
	*
FROM
	sales.sales_summary
ORDER BY
	brand,
	category,
	model_year;

-- GROUP BY BRAND

SELECT 	brand, SUM (sales) AS total_sales
FROM 	sales.sales_summary
GROUP BY brand
ORDER BY brand;

-- GROUP BY Category

SELECT 	category, SUM (sales) AS total_sales
FROM 	sales.sales_summary
GROUP BY category
ORDER BY category;

-- GROUP BY Category & Brand

SELECT 	brand, category, SUM (sales) AS total_sales
FROM 	sales.sales_summary
GROUP BY brand, category
ORDER BY brand, category;

-- Empty GROUPING SET
SELECT 
	SUM (sales) sales
FROM 
	sales.sales_summary;

-- Grouping Set

SELECT 	brand, 
	category, 
	SUM (sales) AS total_sales
FROM 
	sales.sales_summary
GROUP BY 
	GROUPING SETS(
		(brand, category),
		(brand),
		(category),
		())
ORDER BY brand, category;

-- CUBE

SELECT 	brand,
	category,
	SUM (sales) AS total_sales
FROM
	sales.sales_summary
GROUP BY
	CUBE (brand, category)
ORDER BY brand, category;

-- ROLL UP

SELECT 	brand,
	category,
	SUM (sales) AS total_sales
FROM
	sales.sales_summary
GROUP BY
	ROLLUP (category, brand)
ORDER BY brand, category;


SELECT 	brand,
	category,
	SUM (sales) AS total_sales
FROM
	sales.sales_summary
GROUP BY
	ROLLUP (category, brand)
ORDER BY brand, category;

-- SET OPERATORS
-- UNION --> SAME COLUMNS, NO DUPLICATES
SELECT first_name, last_name
FROM sales.customers
UNION
SELECT first_name, last_name
FROM sales.staffs;

-- UNION ALL
SELECT first_name, last_name
FROM sales.customers
UNION ALL
SELECT first_name, last_name
FROM sales.staffs
ORDER BY first_name, last_name;

-- INTERSECT
SELECT first_name, last_name
FROM sales.customers
INTERSECT
SELECT first_name, last_name
FROM sales.staffs;

SELECT city FROM sales.customers
INTERSECT
SELECT city FROM sales.stores
ORDER BY city;

-- EXCEPT
SELECT city FROM sales.customers
EXCEPT
SELECT city FROM sales.stores
ORDER BY city;