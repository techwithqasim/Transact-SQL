-- Sub Query
-- Query inside Query

SELECT 
	s.order_id,
	s.order_date,
	c.customer_id
FROM sales.orders s
INNER JOIN sales.customers c on c.customer_id = s.customer_id
WHERE c.city = 'New York'
ORDER BY order_date;

-- Sub Query

SELECT 
	order_id,
	order_date,
	customer_id
FROM sales.orders
WHERE customer_id IN (
	SELECT customer_id
	FROM sales.customers
	WHERE city = 'New York')
ORDER BY order_date;

-- Using NOT IN

SELECT 
	order_id,
	order_date,
	customer_id
FROM sales.orders
WHERE customer_id NOT IN (
	SELECT customer_id
	FROM sales.customers
	WHERE city = 'New York')
ORDER BY order_date;

--	Two Subquery

SELECT
    product_name,
    list_price
FROM
    production.products
WHERE
    list_price > (
        SELECT
            AVG (list_price)
        FROM
            production.products
        WHERE
            brand_id IN (
                SELECT
                    brand_id
                FROM
                    production.brands
                WHERE
                    brand_name = 'Strider'
                OR brand_name = 'Trek'
            )
    )
ORDER BY
    list_price;


-- Correlated Subquery

SELECT
    product_name,
    list_price,
    category_id
FROM
    production.products p1
WHERE
    list_price IN (
        SELECT
            MAX (p2.list_price)
        FROM
            production.products p2
        WHERE
            p2.category_id = p1.category_id
        GROUP BY
            p2.category_id
    )
ORDER BY
    category_id,
    product_name;

-- Subquery of Customers with More than Two Orders 

SELECT
    customer_id,
    first_name,
    last_name
FROM
    sales.customers c
WHERE 
	customer_id IN (
		SELECT
			customer_id
		FROM
			sales.orders o
		GROUP BY  customer_id
		HAVING COUNT (customer_id) > 2)
ORDER BY
    first_name,
    last_name;


-- EXISTS

SELECT
    customer_id,
    first_name,
    last_name
FROM
    sales.customers c
WHERE
    EXISTS (
        SELECT
            COUNT (*)
        FROM
            sales.orders o
        WHERE
            customer_id = c.customer_id
        GROUP BY
            customer_id
        HAVING COUNT (*) > 2)
ORDER BY
    first_name,
    last_name;

-- 