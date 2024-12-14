-- Triggers are like SP
-- Trigger based on certain action i.e., Insertion, Updation, Deletion

CREATE TABLE Employee
(
Emp_ID INT Identity,
Emp_name Varchar(30),
Emp_Sal Decimal (10,2)
);

INSERT INTO Employee
VALUES ('Qasim', 1000),
		('Ubaid', 1500),
		('Ayan', 2000);

CREATE TABLE Employee_Audit
(
Emp_ID INT,
Emp_name VARCHAR(30),
Emp_Sal DECIMAL(10,2),
Audit_Action VARCHAR(100),
Audit_Timestamp DATETIME
);


-- Trigger for INSERTION

CREATE TRIGGER audit_insertion_employees
ON Employee
FOR INSERT
AS
	DECLARE @empid INT;
	DECLARE @empname VARCHAR(30);
	DECLARE @empsal DECIMAL(10,2);
	DECLARE @audit VARCHAR(100);

	SELECT @empid = i.Emp_ID from inserted i;
	SELECT @empname = i.Emp_name from inserted i;
	SELECT @empsal = i.Emp_Sal from inserted i;
	SELECT @audit = 'Insert Record - After Insert Trigger';

INSERT INTO Employee_Audit VALUES (@empid, @empname, @empsal, @audit, GETDATE());

PRINT 'After Insert Trigger Fired';


SELECT * FROM Employee;

SELECT * FROM Employee_Audit;


INSERT INTO Employee
VALUES ('Uzair', 25000);

-- Trigger for UPDATION

CREATE TRIGGER audit_updation_employees
ON Employee
FOR UPDATE
AS
	DECLARE @empid INT;
	DECLARE @empname VARCHAR(30);
	DECLARE @empsal DECIMAL(10,2);
	DECLARE @audit VARCHAR(100);

	SELECT @empid = i.Emp_ID from inserted i;
	SELECT @empname = i.Emp_name from inserted i;
	SELECT @empsal = i.Emp_Sal from inserted i;

	IF UPDATE(Emp_name)
		SET @audit='Update Record -- After Update - Name Updated';
	IF UPDATE(Emp_Sal)
		SET @audit='Update Record -- After Update - Salary Updated';

INSERT INTO Employee_Audit VALUES (@empid, @empname, @empsal, @audit, GETDATE());

PRINT 'After Update Trigger Fired';



UPDATE Employee SET Emp_name = 'Adil' where Emp_ID = 2;


SELECT * FROM Employee;

SELECT * FROM Employee_Audit;



-- Trigger for Deletion

CREATE TRIGGER audit_deletion_employees
ON Employee
FOR DELETE
AS
	DECLARE @empid INT;
	DECLARE @empname VARCHAR(30);
	DECLARE @empsal DECIMAL(10,2);
	DECLARE @audit VARCHAR(100);

	SELECT @empid = i.Emp_ID from deleted i;
	SELECT @empname = i.Emp_name from deleted i;
	SELECT @empsal = i.Emp_Sal from deleted i;
	SELECT @audit = 'Deleted Record - After Delete Trigger';

INSERT INTO Employee_Audit VALUES (@empid, @empname, @empsal, @audit, GETDATE());

PRINT 'After Delete Trigger Fired';


DELETE FROM Employee WHERE Emp_ID = 2;

SELECT * FROM Employee;

SELECT * FROM Employee_Audit;


-- TASK 2
TRUNCATE TABLE Employee_Table;
TRUNCATE TABLE Employee_log;

CREATE TABLE Employee_Table
(
E_ID INT IDENTITY,
E_fname VARCHAR (20),
E_lname VARCHAR (20),
);

CREATE TABLE Employee_log
(
E_ID INT,
E_fname VARCHAR (20),
E_lname VARCHAR (20),
log_Action VARCHAR (100),
log_Timestamp datetime
);

-- INSERT

CREATE TRIGGER audit_insertion_employee_table
ON Employee_Table
FOR INSERT
AS
	DECLARE @emp_id INT;
	DECLARE @emp_fname VARCHAR (20);
	DECLARE @emp_lname VARCHAR (20);
	DECLARE @log VARCHAR (100);

	SELECT @emp_id = i.E_ID from inserted i;
	SELECT @emp_fname = i.E_fname from inserted i;
	SELECT @emp_lname = i.E_lname from inserted i;
	SELECT @log = 'Record Inserted - After Insert Trigger';

INSERT INTO Employee_log VALUES (@emp_id, @emp_fname, @emp_lname, @log, GETDATE());

PRINT 'After Trigger - Record Inserted';




INSERT INTO Employee_Table VALUES ('Ali', 'Hassan');

SELECT * FROM Employee_Table;

SELECT * FROM Employee_log;

-- UPDATE

CREATE TRIGGER audit_updation_employee_table
ON Employee_Table
FOR UPDATE
AS
	DECLARE @emp_id INT;
	DECLARE @emp_fname VARCHAR (20);
	DECLARE @emp_lname VARCHAR (20);
	DECLARE @log VARCHAR (100);

	SELECT @emp_id = i.E_ID from inserted i;
	SELECT @emp_fname = i.E_fname from inserted i;
	SELECT @emp_lname = i.E_lname from inserted i;
	
	IF UPDATE(E_fname)
		SET @log='Update Record -- First Name Updated';
	IF UPDATE(E_lname)
		SET @log='Update Record -- Last Name Updated';

INSERT INTO Employee_log VALUES (@emp_id, @emp_fname, @emp_lname, @log, GETDATE());

PRINT 'After Trigger - Record Updated';


UPDATE Employee_Table SET E_fname = 'Qasim' where E_ID = 1;

SELECT * FROM Employee_Table;

SELECT * FROM Employee_log;

-- DELETE

CREATE TRIGGER audit_deletion_employee_table
ON Employee_Table
FOR DELETE
AS
	DECLARE @emp_id INT;
	DECLARE @emp_fname VARCHAR (20);
	DECLARE @emp_lname VARCHAR (20);
	DECLARE @log VARCHAR (100);

	SELECT @emp_id = i.E_ID from deleted i;
	SELECT @emp_fname = i.E_fname from deleted i;
	SELECT @emp_lname = i.E_lname from deleted i;
	SELECT @log = 'Record Deleted - After Delete Trigger';

INSERT INTO Employee_log VALUES (@emp_id, @emp_fname, @emp_lname, @log, GETDATE());

PRINT 'After Trigger - Record Deleted';


DELETE FROM Employee_Table where E_ID = 1;

SELECT * FROM Employee_Table;

SELECT * FROM Employee_log;