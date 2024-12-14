-- verify version
SELECT @@VERSION;

-- use created database
USE BikeStores;

-- Section-01: Querying Data
-- SELECT *(ALL)
SELECT * FROM sales.customers;

-- FROM >> SELECT
SELECT first_name FROM sales.customers;
SELECT first_name, last_name FROM sales.customers;

-- SELECT with filter
SELECT * FROM sales.customers;

-- FROM >> WHERE >> SELECT
SELECT * FROM sales.customers WHERE state = 'NY';

-- SELECT with filter & order
-- FROM >> WHERE >> SELECT >> ORDER BY
SELECT * FROM sales.customers WHERE state = 'NY' ORDER BY first_name;

-- SELECT with filter, order, groupby
-- FROM >> WHERE >> GROUP BY >> SELECT >> ORDER BY
-- SELECT * FROM sales.customers WHERE state = 'CA' GROUP BY city ORDER BY city;
SELECT * FROM sales.customers WHERE state = 'NY' GROUP BY city ORDER BY first_name;

-- FROM >> WHERE >> GROUP BY >> SELECT >> ORDER BY
SELECT city, count(*) AS city_count FROM sales.customers WHERE state = 'NY'
GROUP BY city HAVING count(*) > 10;

-- Execution Plan
-- FROM >> WHERE >> GROUP BY >> SELECT >> ORDER BY

-- Section-02: Sorting Data
SELECT *
FROM sales.customers
ORDER BY first_name ASC, last_name DESC;

-- FROM >> SELECT >> ORDER BY
SELECT first_name, last_name
FROM sales.customers
ORDER BY 1, 2; -- NOT A BEST PRACTICE

SELECT *
FROM sales.customers
ORDER BY LEN(first_name);

-- Section-03: Limiting Data
-- OFFSET --> how much portion we want to skip
-- FETCH --> how much rows do you want
-- FETCH is always used with OFFSET, without it error will occur
-- OFFSET/FETCH have a limitation i.e., they can be used only with ORDER BY
SELECT * FROM sales.customers
ORDER BY first_name
OFFSET 10 ROWS;

-- skip first 10 ROWS & fetch 10 rows after that only
SELECT * FROM sales.customers
ORDER BY first_name
OFFSET 10 ROWS
FETCH NEXT 10 ROWS ONLY;

-- SKIP 0 ROWS
SELECT * FROM sales.customers
ORDER BY first_name
OFFSET 0 ROWS
FETCH NEXT 10 ROWS ONLY;


-- TOP 5 ROWS OF TOTAL ROWS
SELECT TOP 5 * FROM sales.customers;

-- 1445 ROWS TOTAL
-- Accessing 1 Percent of Total Rows
SELECT TOP 1 PERCENT * FROM sales.customers;

-- Accessing All rows Having Same state name of top 2 of Total Rows
SELECT TOP 2 WITH TIES * FROM sales.customers ORDER BY state;

SELECT TOP 3 WITH TIES product_name, list_price
FROM production.products
ORDER BY list_price DESC;