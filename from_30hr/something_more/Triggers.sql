USE SalesDB;
--------------------------      TRIGGERS       --------------------------

CREATE TABLE Sales.EmployeeLogs (
	LogID INT IDENTITY(1, 1) PRIMARY KEY, --  OR LogID = IEDNTITY(INT, 1, 1) OR IDENTITY(INT , 1, 1) AS LogID
	EmployeeID INT,
	LogMessage VARCHAR(255),
	LogDate DATE
);

CREATE TRIGGER trg_AfterInsertEmployee ON Sales.Employees
AFTER INSERT
AS 
BEGIN 
	INSERT INTO Sales.EmployeeLogs (EmployeeID, LogMessage, LogDate)
	SELECT
		EmployeeID,
		'New Employee Added =' + CAST(EmployeeID AS VARCHAR),
		GETDATE()
	FROM INSERTED
END;


SELECT * FROM Sales.EmployeeLogs el ;

INSERT INTO Sales.Employees 
VALUES (6, 'Maria', 'Doe', 'HR', '1989-10-01', 'F', 50000, 3);
INSERT INTO Sales.Employees 
VALUES (7, 'Maria', 'Doe', 'HR', '1989-10-01', 'F', 50000, 3);
