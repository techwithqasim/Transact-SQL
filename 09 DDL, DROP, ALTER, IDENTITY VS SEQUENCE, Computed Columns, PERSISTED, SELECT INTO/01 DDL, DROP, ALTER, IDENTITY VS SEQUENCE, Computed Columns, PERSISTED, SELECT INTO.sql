-- Section 12 ddl data definition language

create database testdb

select * from sys.databases

select name 
from sys.databases

select name 
from sys.databases
order by name

-- method 2
-- databases >> new data base >> database name> ok

-- sql sever drop database

/* The DROP DATABASE statement allows you to delete one or more databases with the following syntax:

DROP DATABASE  [ IF EXISTS ]
    database_name 
    [,database_name2,...];
*/
drop database sampledb;
drop database if exists testdb;
DROP DATABASE IF EXISTS testing;
DROP DATABASE IF EXISTS class5;
 
--> databases (databasa name)>> delete >> restore uncheck >> check close connection >> ok

-- 3. sql server create schema
 /* The following illustrates the simplified version of the CREATE SCHEMA statement:

CREATE SCHEMA schema_name
    [AUTHORIZATION owner_name] */

create schema customer_services;
go -- await jab tk pichli command complete na ho agay nahi janay dayga

-- method 1 for check schema
-->db_name>> security >> schema>> you will get schema

DROP DATABASE sampleDB;


-- Method 2



CREATE SCHEMA customer_services;
GO

-- Method 2

SELECT * 
FROM sys.schemas;

SELECT * 
FROM sys.sysusers;

-- TASK : Which Schema is in which database?

SELECT s.name FROM sys.schemas s
INNER JOIN sys.sysusers i
ON i.uid = s.principal_id
ORDER BY s.name;


CREATE TABLE customer_services.jobs(
    job_id INT PRIMARY KEY IDENTITY,
    customer_id INT NOT NULL,
    description VARCHAR(200),
    created_at DATETIME2 NOT NULL
);


CREATE TABLE dbo.offices
(
    office_id INT PRIMARY KEY IDENTITY, 
    office_name NVARCHAR(40) NOT NULL, 
    office_address NVARCHAR(255) NOT NULL, 
    phone VARCHAR(20),
);

/*
ALTER SCHEMA target_schema_name   
    TRANSFER [ entity_type :: ] securable_name;

*/

ALTER SCHEMA sales
	TRANSFER OBJECT::dbo.offices;

INSERT INTO 
    sales.offices(office_name, office_address)
VALUES
    ('Silicon Valley','400 North 1st Street, San Jose, CA 95130'),
    ('Sacramento','1070 River Dr., Sacramento, CA 95820');


-- SQL Server DROP SCHEMA
/*
DROP SCHEMA [IF EXISTS] schema_name;
*/

DROP SCHEMA customer_services;

/*
Msg 3729, Level 16, State 1, Line 107
Cannot drop schema 'customer_services' because it is being referenced by object 'jobs'.
*/

DROP TABLE customer_services.jobs;
DROP SCHEMA customer_services;

/*
SQL Server CREATE TABLE

Syntax:
---------
CREATE TABLE [database_name.][schema_name.]table_name (
    pk_column data_type PRIMARY KEY,
    column_1 data_type NOT NULL,
    column_2 data_type,
    ...,
    table_constraints
);

IDENTITY[(seed,increment)]

*/

CREATE TABLE sales.visits (
    visit_id INT PRIMARY KEY IDENTITY (1, 1),
    first_name VARCHAR (50) NOT NULL,
    last_name VARCHAR (50) NOT NULL,
    visited_at DATETIME,
    phone VARCHAR(20),
    store_id INT NOT NULL,
    FOREIGN KEY (store_id) REFERENCES sales.stores (store_id)
);


/*
-- SQL Server Sequence

python: range
sql: identity
sql: sequence

identity vs sequence

1- Multiple Tables --> Sequence <> Otherwise --> Identity
2- The application requires to restart
 the number when a specified value is reached.

CREATE SEQUENCE [schema_name.] sequence_name  
    [ AS integer_type ]  
    [ START WITH start_value ]  
    [ INCREMENT BY increment_value ]  
    [ { MINVALUE [ min_value ] } | { NO MINVALUE } ]  
    [ { MAXVALUE [ max_value ] } | { NO MAXVALUE } ]  
    [ CYCLE | { NO CYCLE } ]  
    [ { CACHE [ cache_size ] } | { NO CACHE } ];

*/


CREATE SEQUENCE [schema_name.] sequence_name  
    [ AS integer_type ]  
    [ START WITH start_value ]  
    [ INCREMENT BY increment_value ]  


CREATE SEQUENCE item_counter 
	AS INT 
	START WITH 10
	INCREMENT BY 10;

SELECT NEXT VALUE FOR item_counter;

-- EXAMPLE: Will be creating a table & 
-- then inserting values using sequence

CREATE SCHEMA procurement;
GO

CREATE TABLE procurement.purchase_orders(
    order_id INT PRIMARY KEY,
    vendor_id int NOT NULL,
    order_date date NOT NULL
);

CREATE SEQUENCE procurement.order_number 
AS INT
START WITH 1
INCREMENT BY 1;


INSERT INTO procurement.purchase_orders
    (order_id,
    vendor_id,
    order_date)
VALUES
    (NEXT VALUE FOR procurement.order_number,1,'2019-04-30');


INSERT INTO procurement.purchase_orders
    (order_id,
    vendor_id,
    order_date)
VALUES
    (NEXT VALUE FOR procurement.order_number,2,'2019-05-01');


INSERT INTO procurement.purchase_orders
    (order_id,
    vendor_id,
    order_date)
VALUES
    (NEXT VALUE FOR procurement.order_number,3,'2019-05-02');


SELECT * 
FROM procurement.purchase_orders;

-- Example: using sequence while creating table

CREATE SEQUENCE procurement.receipt_no 
AS INT
START WITH 1
INCREMENT BY 1;

CREATE TABLE procurement.invoice_receipts
(
    receipt_id   INT PRIMARY KEY
        DEFAULT (NEXT VALUE FOR procurement.receipt_no), 
    order_id     INT NOT NULL, 
    is_late      BIT NOT NULL,
    receipt_date DATE NOT NULL,
    note NVARCHAR(100)
);


INSERT INTO procurement.invoice_receipts(
    order_id, 
    is_late,
    receipt_date,
    note
)
VALUES(1,0,'2019-05-13','Invoice duly received'
);
INSERT INTO procurement.invoice_receipts(
    order_id, 
    is_late,
    receipt_date,
    note
)
VALUES(2,0,'2019-05-15','Invoice duly received'
);

SELECT *
FROM procurement.invoice_receipts;


/*
SQL Server ALTER TABLE ADD Column

Syntax:
--------
ALTER TABLE table_name
ADD column_name data_type column_constraint;
*/

ALTER TABLE procurement.invoice_receipts
ADD query_date DATE;


SELECT *
FROM procurement.invoice_receipts;


/*
SQL Server ALTER TABLE ALTER COLUMN

Syntax:
--------
ALTER TABLE table_name 
ALTER COLUMN column_name new_data_type(size);
*/

ALTER TABLE procurement.invoice_receipts
ALTER COLUMN query_date DATETIME;


/*
SQL Server ALTER TABLE DROP COLUMN

Syntax:
--------
ALTER TABLE table_name
DROP COLUMN column_name;
*/

ALTER TABLE procurement.invoice_receipts
DROP COLUMN query_date;

/*
SQL Server Computed Columns

Syntax:
--------
CREATE TABLE persons
(
    person_id  INT PRIMARY KEY IDENTITY, 
    first_name NVARCHAR(100) NOT NULL, 
    last_name  NVARCHAR(100) NOT NULL, 
    dob        DATE
);
*/

SELECT first_name+ ' ' + last_name as fullname
FROM sales.customers


CREATE TABLE persons
(
    person_id  INT PRIMARY KEY IDENTITY, 
    first_name NVARCHAR(100) NOT NULL, 
    last_name  NVARCHAR(100) NOT NULL, 
    dob        DATE
);

INSERT INTO 
    persons(first_name, last_name, dob)
VALUES
    ('John','Doe','1990-05-01'),
    ('Jane','Doe','1995-03-01');

SELECT first_name+' '+last_name as fullname
FROM persons

SELECT
    person_id,
    first_name + ' ' + last_name AS full_name,
    dob
FROM
    persons
ORDER BY
    full_name;


ALTER TABLE persons
ADD full_name AS (first_name + ' ' + last_name);

ALTER TABLE persons
DROP COLUMN full_name;

ALTER TABLE persons
ADD full_name AS (first_name + ' ' + last_name) PERSISTED;

/*
PERSISTED: Indicates that the computed values are physically stored in the table.
If you omit PERSISTED, the column is virtual, meaning the value is calculated each time it is queried but not stored.
*/

SELECT * 
FROM persons;

-- Computed Column (Non-Deterministic)
ALTER TABLE persons
ADD age_in_years
	AS (CONVERT(INT,CONVERT(CHAR(8),GETDATE(),112))-CONVERT(CHAR(8),dob,112))/10000;

--Deterministic: Those Values that don't change over time
--Non-Deterministic: Those Values that change over time

SELECT 
    person_id, 
    full_name, 
    age_in_years
FROM 
    persons
ORDER BY 
    age_in_years DESC;


SELECT * 
FROM persons;

TRUNCATE TABLE persons;
DROP TABLE persons;

/*
SQL Server SELECT INTO

Syntax:
--------
SELECT 
    select_list
INTO 
    destination
FROM 
    source
[WHERE condition]
*/

CREATE SCHEMA marketing;
GO

SELECT 
    *
INTO 
    marketing.customers
FROM 
    sales.customers;


SELECT 
    *
FROM 
    marketing.customers;


-- Selecting data from one database to another database

SELECT    
    customer_id, 
    first_name, 
    last_name, 
    email
INTO 
    EDA.marketing.customers
FROM    
    sales.customers
WHERE 
    state = 'CA';

SELECT *
FROM EDA.marketing.customers

-- Section 13: SQL Server Data Types & Section 14: Constraints