-- TASK: IMPORTANT

-- CASE
/*
1----10,000 AS student_id

student_id BETWEEN 400 and 700
*/

SELECT 
	o.order_id,
	SUM(i.quantity * i.list_price)  'order_value',
	CASE
		WHEN SUM(i.quantity * i.list_price) > 20000 THEN 'High Value Order'
		WHEN SUM(i.quantity * i.list_price) < 20000 AND SUM(i.quantity * i.list_price) >= 10000 THEN 'Average Order'
		WHEN SUM(i.quantity * i.list_price) < 10000 AND SUM(i.quantity * i.list_price) >= 5000 THEN 'Fair Order' 
		WHEN SUM(i.quantity * i.list_price) < 5000 THEN 'Low Value Order'
	END as 'Priority'
FROM sales.orders o
INNER JOIN sales.order_items i
ON o.order_id = i.order_id
WHERE YEAR(o.order_date) = 2018 AND order_status IN (1,2)
GROUP BY o.order_id
ORDER BY SUM(i.quantity * i.list_price) DESC;


SELECT 
	o.order_id,
	SUM(i.quantity * i.list_price)  'order_value',
	CASE
		WHEN SUM(i.quantity * i.list_price) >= 20000 THEN 'High Value Order'
		WHEN SUM(i.quantity * i.list_price) BETWEEN 10000 AND 20000 THEN 'Average Order'
		WHEN SUM(i.quantity * i.list_price) BETWEEN 5000 AND 10000 THEN 'Fair Order' 
		WHEN SUM(i.quantity * i.list_price) BETWEEN 0 AND 5000 THEN 'Low Value Order'
	END as 'Priority'
FROM sales.orders o
INNER JOIN sales.order_items i
ON o.order_id = i.order_id
WHERE YEAR(o.order_date) = 2018 AND ((order_status = 1) OR (order_status = 2))
GROUP BY o.order_id
ORDER BY SUM(i.quantity * i.list_price) DESC;


/*
SQL Server COALESCE

-- Returns the first non-null argument.

Syntax:
-------
COALESCE(e1,[e2,...,en])

*/

SELECT COALESCE(NULL, NULL, 10, 20, NULL);
SELECT COALESCE(NULL, 'Hi', 'Hello', NULL);


-- Using SQL Server COALESCE expression to substitute NULL by new values

SELECT first_name, 
		last_name, 
		phone, 
		email
FROM sales.customers
ORDER BY first_name, last_name;


SELECT first_name, 
		last_name, 
		COALESCE (phone, 'N/A'), 
		email
FROM sales.customers
ORDER BY first_name, last_name;



-- Using SQL Server COALESCE expression to use the available data

CREATE TABLE salaries (
    staff_id INT PRIMARY KEY,
    hourly_rate decimal,
    weekly_rate decimal,
    monthly_rate decimal,
    CHECK(
        hourly_rate IS NOT NULL OR 
        weekly_rate IS NOT NULL OR 
        monthly_rate IS NOT NULL)
);

INSERT INTO 
    salaries(
        staff_id, 
        hourly_rate, 
        weekly_rate, 
        monthly_rate
    )
VALUES
    (1,20, NULL,NULL),
    (2,30, NULL,NULL),
    (3,NULL, 1000,NULL),
    (4,NULL, NULL,6000),
    (5,NULL, NULL,6500);

SELECT * FROM salaries;

SELECT staff_id,
		hourly_rate,
		weekly_rate,
		COALESCE (hourly_rate * 22 * 8, weekly_rate * 4, monthly_rate) Monthly_Rate
FROM salaries;

/*
-- COALESCE vs. CASE expression

The COALESCE expression is a syntactic sugar of the CASE expression.

COALESCE(e1,e2,e3)

CASE
    WHEN e1 IS NOT NULL THEN e1
    WHEN e2 IS NOT NULL THEN e2
    ELSE e3
END



SQL Server NULLIF


The NULLIF expression accepts two arguments and 
returns NULL if two arguments are equal. 
Otherwise, it returns the first expression.

Syntax:
-------
NULLIF(expression1, expression2)

*/

SELECT NULLIF(10, 10) result;
SELECT NULLIF(20, 10) result;

SELECT NULLIF('Hello', 'Hello') result;

SELECT NULLIF('Hello', 'Hi') result;

-- Using NULLIF expression to translate a blank string to NULL

CREATE TABLE sales.leads
(
    lead_id    INT	PRIMARY KEY IDENTITY, 
    first_name VARCHAR(100) NOT NULL, 
    last_name  VARCHAR(100) NOT NULL, 
    phone      VARCHAR(20), 
    email      VARCHAR(255) NOT NULL
);

INSERT INTO sales.leads
(
    first_name, 
    last_name, 
    phone, 
    email
)
VALUES
(
    'John', 
    'Doe', 
    '(408)-987-2345', 
    'john.doe@example.com'
),
(
    'Jane', 
    'Doe', 
    '', 
    'jane.doe@example.com'
),
(
    'David', 
    'Doe', 
    NULL, 
    'david.doe@example.com'
);

SELECT * FROM sales.leads;

SELECT * FROM sales.leads WHERE phone IS NULL;

-- NULLIF ('', '') --> NULL
-- NULLIF (NULL, '') --> NULL
SELECT * 
FROM sales.leads 
WHERE NULLIF(phone, '') IS NULL;

-- Alternative Without NULLIF:
SELECT * 
FROM sales.leads 
WHERE phone IS NULL OR phone = '';


DECLARE @a int = 10, @b int = 20;

SELECT
CASE
	WHEN  @a=@b THEN NULL
	ELSE @a
END;


DECLARE @c int = 10, @d int = 20;

SELECT
	NULLIF(@c,@d) AS result;