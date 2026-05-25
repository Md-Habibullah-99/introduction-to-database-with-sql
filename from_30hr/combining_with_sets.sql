USE SalesDB;


-- MUST HAVE SAME NUMBER OF COLUMNS AND SAME DATA TYPE (ALL FIRST COLUMNS OR ALL N TH COLUMNS)

SELECT 
	CustomerID AS ID ,
	LastName
FROM Sales.Customers c 
UNION
SELECT 
	EmployeeID ,
	LastName
FROM Sales.Employees e ;

SELECT 
	c.FirstName ,
	c.LastName
FROM Sales.Customers c 
UNION
SELECT 
	e.FirstName ,
	e.LastName
FROM Sales.Employees e ;

-- union all
SELECT 
	c.FirstName ,
	c.LastName
FROM Sales.Customers c 
UNION ALL
SELECT 
	e.FirstName ,
	e.LastName
FROM Sales.Employees e ;

-- except
SELECT 
	c.FirstName ,
	c.LastName
FROM Sales.Customers c 
EXCEPT
SELECT 
	e.FirstName ,
	e.LastName
FROM Sales.Employees e ;

-- intersect
SELECT 
	c.FirstName ,
	c.LastName
FROM Sales.Customers c 
INTERSECT 
SELECT 
	e.FirstName ,
	e.LastName
FROM Sales.Employees e ;

SELECT 
'Orders' AS SourceTable , -- good practice to add source table
OrderID, ProductID, CustomerID, SalesPersonID, OrderDate, ShipDate, OrderStatus, ShipAddress, BillAddress, Quantity, Sales, CreationTime 
FROM Sales.Orders o 
UNION
SELECT 
'OrdersArchive' AS SourceTable , -- good practice to add source table
OrderID, ProductID, CustomerID, SalesPersonID, OrderDate, ShipDate, OrderStatus, ShipAddress, BillAddress, Quantity, Sales, CreationTime
FROM Sales.OrdersArchive oa 
ORDER BY OrderID;

SELECT * FROM Sales.Customers c ;
SELECT * FROM Sales.Employees e ;
SELECT * FROM Sales.Orders o ;
SELECT * FROM Sales.OrdersArchive oa ;
SELECT * FROM Sales.Products p ;
