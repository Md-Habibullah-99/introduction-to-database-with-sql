USE SalesDB;
--------------------------      STORED PROCEDURE       --------------------------

-- step 1
SELECT 
	COUNT(*) AS TotalCustomers ,
	AVG(c.Score) AS AvgScore
FROM Sales.Customers c 
WHERE c.Country = 'USA';


-- step 2
CREATE PROCEDURE GetCustomerSummary AS
BEGIN
	SELECT 
		COUNT(*) AS TotalCustomers ,
		AVG(c.Score) AS AvgScore
	FROM Sales.Customers c 
	WHERE c.Country = 'USA'
END;

-- step 3
EXEC GetCustomerSummary;


-- parameters
-- for german customers find the total number of customers and the average score
CREATE PROCEDURE GetCustomerSummaryWParams @Country NVARCHAR(50)
AS
BEGIN
	SELECT 
		COUNT(*) AS TotalCustomers ,
		AVG(c.Score) AS AvgScore ,
		@Country
	FROM Sales.Customers c 
	WHERE c.Country = @Country
END;

-- or alter the previous program
ALTER PROCEDURE GetCustomerSummary @Country NVARCHAR(50)
AS
BEGIN
	SELECT 
		COUNT(*) AS TotalCustomers ,
		AVG(c.Score) AS AvgScore ,
		@Country
	FROM Sales.Customers c 
	WHERE c.Country = @Country
END;


-- default value:
ALTER PROCEDURE GetCustomerSummary @Country NVARCHAR(50) = 'USA' 
AS
BEGIN
	SELECT 
		COUNT(*) AS TotalCustomers ,
		AVG(c.Score) AS AvgScore ,
		@Country
	FROM Sales.Customers c 
	WHERE c.Country = @Country
END;



-- find the total number of orders and total sales
ALTER PROCEDURE GetCustomerSummary @Country NVARCHAR(50) = 'USA' 
AS
BEGIN
	SELECT 
		COUNT(*) AS TotalCustomers ,
		AVG(c.Score) AS AvgScore ,
		@Country
	FROM Sales.Customers c 
	WHERE c.Country = @Country;

	SELECT 
		COUNT(o.OrderID ) AS TotalOrders ,
		SUM(o.Sales ) AS TotalSales 
	FROM Sales.Orders o
	JOIN Sales.Customers c 
		ON c.CustomerID = o.CustomerID 
	WHERE c.Country = @Country;
END;



-------------------------		VARIABLES 		---------------------

-- copy the table to temp table:
SELECT *
INTO Sales.#TempCustomers
FROM Sales.Customers c;

-- setup the procedure with variables
ALTER PROCEDURE GetCustomerSummary @Country NVARCHAR(50) = 'USA' 
AS
BEGIN
	
	DECLARE @TotalCustomers INT, @AvgScore FLOAT;

-- PREPARE & CLEANUP the data
IF EXISTS(SELECT 1 FROM Sales.#TempCustomers WHERE Score IS NULL AND Country = @Country) 
BEGIN
	UPDATE Sales.#TempCustomers
	SET Score=0
	WHERE Score IS NULL AND Country = @Country
END 

ELSE 
BEGIN
	PRINT ('No NULL Scores found')
END


-- Generating Reports
	SELECT 
		@TotalCustomers = COUNT(*),
		@AvgScore = AVG(c.Score)
	FROM Sales.#TempCustomers c 
	WHERE c.Country = @Country;

PRINT 'Total Customers from '+ @Country + ':' + CAST(@TotalCustomers AS VARCHAR(30));
PRINT 'Average Score from '+ @Country + ':' + CAST(@AvgScore AS VARCHAR(30));

	SELECT 
		COUNT(o.OrderID ) AS TotalOrders ,
		SUM(o.Sales ) AS TotalSales 
	FROM Sales.Orders o
	JOIN Sales.#TempCustomers c 
		ON c.CustomerID = o.CustomerID 
	WHERE c.Country = @Country;
END;


-- execuite
EXEC GetCustomerSummary ;
EXEC GetCustomerSummary @Country = 'Germany';
EXEC GetCustomerSummaryWParams @Country = 'USA';


-- delete procedure
DROP PROCEDURE GetCustomerSummary;
