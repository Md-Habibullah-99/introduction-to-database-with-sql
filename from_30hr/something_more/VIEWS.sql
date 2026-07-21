USE SalesDB;
--------------------------      VIEWS       --------------------------

-- creating the views
-- in default schema
CREATE VIEW V_monthly_summary AS 
(
	SELECT 
		DATETRUNC(MONTH, o.OrderDate) AS orderMonth ,
		SUM(o.Sales ) AS totalSales ,
		COUNT(o.OrderID ) AS totalOrders ,
		SUM(o.Quantity ) AS totalQuantity 
	FROM Sales.orders o
	GROUP BY DATETRUNC(MONTH, o.OrderDate)
);
-- in sales schema
CREATE VIEW Sales.V_monthly_summary AS 
(
	SELECT 
		DATETRUNC(MONTH, o.OrderDate) AS orderMonth ,
		SUM(o.Sales ) AS totalSales ,
		COUNT(o.OrderID ) AS totalOrders ,
		SUM(o.Quantity ) AS totalQuantity 
	FROM Sales.orders o
	GROUP BY DATETRUNC(MONTH, o.OrderDate)
);

-- drop view
DROP VIEW V_monthly_summary ;


-- UPDATE views
-- CREATE OR REPLACE VIEW abc..... -- in postgress sql
-- but in mssql:
-- starts with t-sql :
IF OBJECT_ID('Sales.V_monthly_summary','V') IS NOT NULL
	DROP VIEW Sales.V_monthly_summary;
GO
CREATE VIEW Sales.V_monthly_summary AS 
(
	SELECT 
		DATETRUNC(MONTH, o.OrderDate) AS orderMonth ,
		SUM(o.Sales ) AS totalSales ,
		COUNT(o.OrderID ) AS totalOrders ,
		SUM(o.Quantity ) AS totalQuantity ,
		COUNT(DISTINCT o.customerID) AS unique_customers_by_month
	FROM Sales.orders o
	GROUP BY DATETRUNC(MONTH, o.OrderDate)
);





--------   	TASKS:

-- find the running total of sales for each month
SELECT
vms.orderMonth ,
vms.totalSales ,
SUM(vms.totalSales ) OVER (ORDER BY vms.orderMonth) AS rt
FROM Sales.V_monthly_summary vms ;


-- provide a view that combines details from orders, products, customers, and employees.
IF OBJECT_ID('Sales.V_combine_all','V') IS NOT NULL
	DROP VIEW Sales.V_combine_all;
GO
CREATE VIEW Sales.V_combine_all AS 
(
	SELECT 
		e.EmployeeID ,e.Department ,e.FirstName + ' ' + e.LastName AS employee_Name ,e.Gender ,e.BirthDate ,e.ManagerID ,e.Salary ,
		c.CustomerID ,ISNULL(c.FirstName, ' ') + ' ' + ISNULL(c.LastName , ' ') AS customer_name,c.Country ,c.Score ,
		o.OrderID ,o.ProductID ,o.Quantity ,o.OrderStatus ,o.OrderDate ,o.CreationTime ,o.ShipDate ,o.ShipAddress ,o.BillAddress ,o.Sales ,
		p.Category ,p.Price ,p.Product 
	FROM Sales.orders o
	LEFT JOIN Sales.Customers c  -- also we can use full join or inner join but i don't want to lose any orders or sotre some null values 
		ON c.CustomerID = o.CustomerID 
	LEFT JOIN Sales.Employees e 
		ON e.EmployeeID = o.SalesPersonID 
	LEFT JOIN Sales.Products p 
		ON p.ProductID = o.ProductID 
);
-- test
SELECT *
FROM Sales.V_combine_all;


-- provide a view for the EU Sales Team that combines details from all tables and excludes data related to the USA.
CREATE VIEW Sales.V_EU AS 
(
	SELECT 
		e.EmployeeID ,e.Department ,e.FirstName + ' ' + e.LastName AS employee_Name ,e.Gender ,e.BirthDate ,e.ManagerID ,e.Salary ,
		c.CustomerID ,ISNULL(c.FirstName, ' ') + ' ' + ISNULL(c.LastName , ' ') AS customer_name,c.Country ,c.Score ,
		o.OrderID ,o.ProductID ,o.Quantity ,o.OrderStatus ,o.OrderDate ,o.CreationTime ,o.ShipDate ,o.ShipAddress ,o.BillAddress ,o.Sales ,
		p.Category ,p.Price ,p.Product 
	FROM Sales.orders o
	LEFT JOIN Sales.Customers c  -- also we can use full join or inner join but i don't want to lose any orders or sotre some null values 
		ON c.CustomerID = o.CustomerID 
	LEFT JOIN Sales.Employees e 
		ON e.EmployeeID = o.SalesPersonID 
	LEFT JOIN Sales.Products p 
		ON p.ProductID = o.ProductID
	WHERE c.Country <> 'USA'
);
-- test
SELECT *
FROM Sales.V_EU ;

SELECT * FROM Sales.Orders o ;
