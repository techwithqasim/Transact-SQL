-- SQL Server Dynamic SQL

-- SIMPLE SQL
SELECT * FROM production.products;

-- Dynamic SQL
EXEC sp_executesql N'SELECT * FROM production.products';


DECLARE 
    @table NVARCHAR(128),
    @sql NVARCHAR(MAX);

SET @table = N'production.parts';

SET @sql = N'SELECT * FROM ' + @table;

EXEC sp_executesql @sql;





DECLARE 
    @table NVARCHAR(128),
	@select NVARCHAR(128),
    @sql NVARCHAR(MAX);

SET @table = N'sales.customers';

SET @select = N'first_name, last_name';

SET @sql = N'SELECT ' + @select + N' FROM ' + @table;

EXEC sp_executesql @sql;





DECLARE 
    @table NVARCHAR(128),
	@select NVARCHAR(128),
	@string NVARCHAR(128),
	@name NVARCHAR(128),
    @sql NVARCHAR(MAX);

SET @table = N'sales.customers';

SET @select = N'first_name, last_name';

SET @string = 'Acevedo';

SET @name = N'@string';

SET @sql = N'SELECT ' + @select + N' FROM ' + @table + N' WHERE last_name = ' + @string;

EXEC sp_executesql @sql;