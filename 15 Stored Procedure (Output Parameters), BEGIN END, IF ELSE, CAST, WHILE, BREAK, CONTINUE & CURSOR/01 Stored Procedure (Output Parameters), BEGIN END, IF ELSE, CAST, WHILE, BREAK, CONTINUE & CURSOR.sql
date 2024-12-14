USE BikeStores;

-- Stored Procedure Output Parameters
/*
Syntax:
-------------------------------
parameter_name data_type OUTPUT

*/

CREATE PROCEDURE uspFindProductByModel (
    @model_year SMALLINT,
    @product_count INT OUTPUT
) AS
BEGIN
    SELECT 
        product_name,
        list_price
    FROM
        production.products
    WHERE
        model_year = @model_year;

    SELECT @product_count = @@ROWCOUNT;
END;

DECLARE @count INT;

EXEC uspFindProductByModel
    @model_year = 2018,
    @product_count = @count OUTPUT;

SELECT @count AS 'Number of products found';




CREATE PROCEDURE uspFindProductByModel2 (
    @model_year SMALLINT,
    @product_count INT OUTPUT
) AS
BEGIN
    SELECT 
        product_name,
        list_price
    FROM
        production.products
    WHERE
        model_year = @model_year;

	SELECT brand_id, model_year FROM production.products;

    SELECT @product_count = @@ROWCOUNT;
END;


DECLARE @number INT;

EXEC uspFindProductByModel2
	@model_year = 2015,
	@product_count = @number OUTPUT;

SELECT @number AS 'Number of Bicycles';


-- SQL Server BEGIN END
/*
Syntax:
----------------
BEGIN
    { sql_statement | statement_block}
END

*/

-- NESTED BEGIN AND END IN STORED PROCEDURE

CREATE PROCEDURE nested_proc(@proc int) AS
BEGIN
    DECLARE @name VARCHAR(MAX);

    SELECT TOP 1
        @name = product_name
    FROM
        production.products
    ORDER BY
        list_price DESC;
    
    IF @@ROWCOUNT <> 0
    BEGIN
        PRINT 'The most expensive product is ' + @name
    END
    ELSE
    BEGIN
        PRINT 'No product found';
    END;
END

EXECUTE nested_proc
	@proc=1;



CREATE PROCEDURE nested_proc2(@proc int) AS
BEGIN
    DECLARE @name VARCHAR(MAX);

    SELECT TOP 1
        @name = product_name
    FROM
        production.products
    ORDER BY
        list_price ASC;
    
    IF @@ROWCOUNT <> 0
    BEGIN
        PRINT 'The most inexpensive product is ' + @name
    END
    ELSE
    BEGIN
        PRINT 'No product found';
    END;
END

EXECUTE nested_proc2
	@proc=2;


-- SQL Server IF ELSE
/*
Syntax:
-----------------
IF boolean_expression   
BEGIN
    { statement_block }
END

*/

BEGIN
    DECLARE @sales INT;

    SELECT 
        @sales = SUM(list_price * quantity)
    FROM
        sales.order_items i
        INNER JOIN sales.orders o ON o.order_id = i.order_id
    WHERE
        YEAR(order_date) = 2018;

    SELECT @sales;

    IF @sales > 1000000
    BEGIN
        PRINT 'Great! The sales amount in 2018 is greater than 1,000,000';
    END
END

drop PROCEDURE if_proc;

CREATE PROCEDURE if_proc(
		@year INT) AS
BEGIN
    DECLARE @sales INT;

    SELECT 
        @sales = SUM(list_price * quantity)
    FROM
        sales.order_items i
        INNER JOIN sales.orders o ON o.order_id = i.order_id
    WHERE
        YEAR(order_date) = @year;

    SELECT @sales;

    IF @sales > 1000000
    BEGIN
        PRINT 'Great! The sales amount in ' + CAST (@year as VARCHAR) + ' is greater than 1,000,000';
    END
END

EXEC if_proc
	@year = 2018;

-- CAST FUNCTION TO CHANGE THE TYPE OF A VARIABLE OR VALUE
SELECT CAST(25.67 as INT);

SELECT CAST(25.67 as INT) as Casted_Integer;

-- SQL Server WHILE
/*
Syntax:
------------------
WHILE Boolean_expression   
     { sql_statement | statement_block}  

*/

DECLARE @counter INT = 1;

WHILE @counter <= 5
BEGIN
    PRINT @counter;
    SET @counter = @counter + 1;
END





SELECT * INTO production.products_dup
FROM production.products;

SELECT * FROM production.products_dup;


DECLARE @model_year INT = 2016;

CREATE PROCEDURE while_loop(
	@model_year INT
) AS
BEGIN
	DECLARE @year INT;
	SELECT @year = model_year FROM production.products_dup;
WHILE @model_year = 5
BEGIN
    UPDATE ;
END

EXEC while_loop;



-- SQL Server BREAK
/*
Syntax:
--------------------
WHILE Boolean_expression
BEGIN
    -- statements
   IF condition
        BREAK;
    -- other statements    
END

*/

DECLARE @counter INT = 0;

WHILE @counter <= 5
BEGIN
    SET @counter = @counter + 1;
    IF @counter = 4
        BREAK;
    PRINT @counter;
END


-- SQL Server CONTINUE

/*
Syntax:
----------------
WHILE Boolean_expression
BEGIN
    -- code to be executed
    IF condition
        CONTINUE;
    -- code will be skipped if the condition is met
END

*/

DECLARE @counter INT = 0;

WHILE @counter < 5
BEGIN
    SET @counter = @counter + 1;
    IF @counter = 3
        CONTINUE;	
    PRINT @counter;
END


-- SQL Server CURSOR
/*
Syntax:
-----------------------
DECLARE cursor_name CURSOR
    FOR select_statement;

In While Loop:
----------------------------
WHILE @@FETCH_STATUS = 0  
    BEGIN
        FETCH NEXT FROM cursor_name;  
    END;

*/


DECLARE 
    @product_name VARCHAR(MAX), 
    @list_price   DECIMAL;

DECLARE cursor_product CURSOR
FOR SELECT 
        product_name, 
        list_price
    FROM 
        production.products;

OPEN cursor_product;

FETCH NEXT FROM cursor_product INTO 
    @product_name, 
    @list_price;

WHILE @@FETCH_STATUS = 0
    BEGIN
        PRINT @product_name + CAST(@list_price AS varchar);
        FETCH NEXT FROM cursor_product INTO 
            @product_name, 
            @list_price;
    END;

CLOSE cursor_product;

DEALLOCATE cursor_product;

