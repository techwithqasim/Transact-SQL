CREATE TABLE sales.promotions(
	promotion_id INT PRIMARY KEY IDENTITY(1, 1),
	promotion_name VARCHAR(255) NOT NULL,
	discount NUMERIC(3, 2) DEFAULT 0,
	start_date DATE NOT NULL,
	expired_date DATE NOT NULL
);

SELECT * FROM sales.promotions;

-- SQL Server Simple INSERT

/*
SYNTAX:

INSERT INTO table_name (column_list)
VALUES (value_list);
*/

INSERT INTO sales.promotions (
	promotion_name,
	discount,
	start_date,
	expired_date
)
VALUES (
		'2018 Summer Promotion',
		0.15,
		'20180601',
		'20180901'
);


SELECT * FROM sales.promotions;

-- INSERT with return values

INSERT INTO sales.promotions (
	promotion_name,
	discount,
	start_date,
	expired_date
) OUTPUT inserted.promotion_id
VALUES (
		'2018 Fall Promotion',
		0.15,
		'20181001',
		'20181101'
);

-- INSERT with Multiple Values

INSERT INTO sales.promotions (
	promotion_name,
	discount,
	start_date,
	expired_date
) OUTPUT inserted.promotion_id,
	inserted.promotion_name,
	inserted.discount,
	inserted.start_date,
	inserted.expired_date
VALUES (	
		'2018 Winter Promotion',
		0.2,
		'20181201',
		'20190101'
);

SELECT * FROM sales.promotions;

-- way to add identity column while insertion

SET IDENTITY_INSERT sales.promotions ON;

INSERT INTO sales.promotions (
	promotion_id,
	promotion_name,
	discount,
	start_date,
	expired_date
) OUTPUT inserted.promotion_id,
	inserted.promotion_name,
	inserted.discount,
	inserted.start_date,
	inserted.expired_date
VALUES (	
		 4,
        '2019 Spring Promotion',
        0.25,
        '20190201',
        '20190301'
);

SET IDENTITY_INSERT sales.promotions OFF;



SELECT * FROM sales.promotions;

-- SQL Server INSERT Multiple Rows

/*

*/

INSERT INTO sales.promotions (
    promotion_name,
    discount,
    start_date,
    expired_date
)
VALUES
    (
        '2019 Summer Promotion',
        0.15,
        '20190601',
        '20190901'
    ),
    (
        '2019 Fall Promotion',
        0.20,
        '20191001',
        '20191101'
    ),
    (
        '2019 Winter Promotion',
        0.25,
        '20191201',
        '20200101'
    );

SELECT * FROM sales.promotions;

-- 

INSERT INTO 
	sales.promotions ( 
		promotion_name, discount, start_date, expired_date
	)
OUTPUT inserted.promotion_id
VALUES
	('2020 Summer Promotion',0.25,'20200601','20200901'),
	('2020 Fall Promotion',0.10,'20201001','20201101'),
	('2020 Winter Promotion', 0.25,'20201201','20210101');

SELECT * FROM sales.promotions;

-- SQL Server INSERT SELECT INTO

CREATE TABLE sales.addresses (
    address_id INT IDENTITY PRIMARY KEY,
    street VARCHAR (255) NOT NULL,
    city VARCHAR (50),
    state VARCHAR (25),
    zip_code VARCHAR (5)
);

/*
INSERT  [ TOP ( expression ) [ PERCENT ] ] 
INTO target_table (column_list)
query
*/

-- INSERT
-- INSERT TOP (5) -- ROWS
-- INSERT TOP (5) PERCENT
INSERT TOP (5) PERCENT
INTO sales.addresses (
	street,
	city,
	state,
	zip_code
) SELECT
	street,
	city,
	state,
	zip_code
FROM sales.customers;

TRUNCATE TABLE sales.addresses;

SELECT * FROM sales.addresses;

-- INSERTION WITH QUERY & WHERE CLAUSE

INSERT
INTO sales.addresses (
	street,
	city,
	state,
	zip_code
) SELECT
	street,
	city,
	state,
	zip_code
FROM sales.stores
WHERE city IN ('Santa Cruz', 'Baldwin');

TRUNCATE TABLE sales.addresses;

SELECT * FROM sales.addresses;

-- SQL Server UPDATE

/*
UPDATE table_name
SET c1 = v1, c2 = v2, ... cn = vn
[WHERE condition]
*/

CREATE TABLE sales.taxes (
	tax_id INT PRIMARY KEY IDENTITY (1, 1),
	state VARCHAR (50) NOT NULL UNIQUE,
	state_tax_rate DEC (3, 2),
	avg_local_tax_rate DEC (3, 2),
	combined_rate AS state_tax_rate + avg_local_tax_rate,
	max_local_tax_rate DEC (3, 2),
	updated_at datetime
);

SELECT * FROM sales.taxes;

/*
UPDATE table_name
SET c1 = v1, c2 = v2, ... cn = vn
[WHERE condition]
*/

-- Update a single column in all rows example
UPDATE sales.taxes
SET updated_at = GETDATE();

SELECT * FROM sales.taxes;

-- Update multiple columns example
-- 2% max => 1% avg

UPDATE sales.taxes
SET max_local_tax_rate += 0.02,
	avg_local_tax_rate += 0.01
WHERE max_local_tax_rate = 0.01;

-- SQL Server UPDATE JOIN
/*
UPDATE 
    t1
SET 
    t1.c1 = t2.c2,
    t1.c2 = expression,
    ...   
FROM 
    t1
    [INNER | LEFT] JOIN t2 ON join_predicate
WHERE 
    where_predicate;
*/

DROP TABLE IF EXISTS sales.targets;

CREATE TABLE sales.targets(
    target_id  INT	PRIMARY KEY, 
    percentage DECIMAL(4, 2) NOT NULL DEFAULT 0
);

INSERT INTO 
    sales.targets(target_id, percentage)
VALUES
    (1,0.2),
    (2,0.3),
    (3,0.5),
    (4,0.6),
    (5,0.8);

SELECT * FROM sales.targets;

-- commisions table
CREATE TABLE sales.commissions
(
    staff_id INT PRIMARY KEY, 
    target_id INT, 
    base_amount DECIMAL(10, 2) NOT NULL DEFAULT 0, 
    commission DECIMAL(10, 2) NOT NULL DEFAULT 0, 
    FOREIGN KEY(target_id) REFERENCES sales.targets(target_id), 
    FOREIGN KEY(staff_id) REFERENCES sales.staffs(staff_id),
);

INSERT INTO 
    sales.commissions(
	staff_id, 
	base_amount, 
	target_id
)
VALUES
    (1,100000,2),
    (2,120000,1),
    (3,80000,3),
    (4,900000,4),
    (5,950000,5);

TRUNCATE TABLE sales.commissions;

SELECT * FROM sales.targets;
SELECT * FROM sales.commissions;

/*
UPDATE 
    t1
SET 
    t1.c1 = t2.c2,
    t1.c2 = expression,
    ...   
FROM 
    t1
    [INNER | LEFT] JOIN t2 ON join_predicate
WHERE 
    where_predicate;
*/

UPDATE sales.commissions
SET commission = base_amount * t.percentage
FROM sales.commissions c
INNER JOIN sales.targets t
ON c.target_id = t.target_id;

SELECT * FROM sales.commissions;

-- suppose

INSERT INTO 
    sales.commissions(staff_id, base_amount, target_id)
VALUES
    (6,100000,NULL),
    (7,120000,NULL);

-- updates the commissions based on targets
-- for new staff
UPDATE sales.commissions
SET commission = base_amount * COALESCE(t.percentage, 0.1)
FROM sales.commissions c
LEFT JOIN sales.targets t
ON c.target_id = t.target_id;

SELECT * FROM sales.commissions;

-- SQL Server DELETE
/*
DELETE [ TOP ( expression ) [ PERCENT ] ]  
FROM table_name
[WHERE search_condition];
*/

SELECT *
INTO production.products_history
FROM  production.products;

SELECT *
FROM production.products_history;

DELETE TOP (5) FROM production.products_history;
DELETE TOP (5) PERCENT FROM production.products_history;
DELETE FROM production.products_history;