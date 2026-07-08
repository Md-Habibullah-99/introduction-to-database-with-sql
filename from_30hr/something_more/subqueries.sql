USE SalesDB;
--------------------------      SUB QUERY       --------------------------


----------  SUB QUERY TYPE

-- scalar sub q
SELECT 
	AVG(p.Price )
FROM Sales.Products p ;

-- row sub q
SELECT 
	p.ProductID 
FROM Sales.Products p;

-- table sub q
SELECT 
	o.OrderID ,
	o.ProductID ,
	o.CustomerID 
FROM Sales.Orders o ;


-----------  LOCATION CLAUSES

-- with from
SELECT 
*
FROM (
SELECT 
	o.OrderID ,
	o.ProductID ,
	o.CustomerID 
FROM Sales.Orders o 
) AS subt;



-- with select
SELECT 
	c.CustomerID ,
	c.Score ,
	(SELECT SUM(o.Sales ) FROM Sales.Orders o WHERE c.CustomerID = o.CustomerID ) AS totalSales
FROM Sales.Customers c;



-- with join clause
SELECT 
	* 
FROM Sales.Customers c 
JOIN (SELECT 
	o.CustomerID ,
	COUNT(*) AS totalOrders 
FROM Sales.Orders o 
GROUP BY o.CustomerID )t
	ON t.CustomerID = c.CustomerID ;



-- with where clause
SELECT 
*
FROM Sales.Employees 
WHERE Salary < (SELECT AVG(e.Salary ) FROM Sales.Employees e);



-- witih IN operator
SELECT 
*
FROM Sales.Employees e 
WHERE e.EmployeeID IN (SELECT o.SalesPersonID  FROM Sales.Orders o );



-- with ANY | ALL
SELECT 
	e.EmployeeID ,
	e.FirstName ,
	e.Salary 
FROM Sales.Employees e 
WHERE e.Gender = 'M' AND e.Salary > ALL (SELECT e2.Salary FROM Sales.Employees e2 WHERE e2.Gender = 'F');



-- NON-CORRELATED and CORRELATED sub query
-- correlated sub query
SELECT 
*,
(SELECT COUNT(*) FROM Sales.Orders o WHERE o.SalesPersonID = e.EmployeeID ) AS totalSales
FROM Sales.Employees e ;

-- correlated sub query EXIST
SELECT 
*,
(SELECT COUNT(*) FROM Sales.Orders o WHERE o.SalesPersonID = e.EmployeeID ) AS totalSales
FROM Sales.Employees e 
WHERE EXISTS (SELECT 1 FROM Sales.Orders o WHERE o.SalesPersonID = e.EmployeeID );



-- tasks:
-- rank coustomers based on their total amount of sales
SELECT 
	*,
	DENSE_RANK() OVER (ORDER BY t.TotalSaleAmount DESC) AS Ranking
FROM (
	SELECT
		DISTINCT c.CustomerID ,
		c.FirstName ,
		SUM(o.Sales ) OVER (PARTITION BY c.CustomerID ) AS TotalSaleAmount
	FROM Sales.Customers c 
	LEFT JOIN Sales.Orders o
		ON c.CustomerID = o.CustomerID 
	LEFT JOIN Sales.Products p 
		ON o.ProductID = p.ProductID 
) AS t;
-- OR
SELECT 
	*,
	DENSE_RANK() OVER (ORDER BY t.TotalSaleAmount DESC) AS Ranking
FROM (
	SELECT
		c.CustomerID ,
		SUM(o.Sales ) AS TotalSaleAmount
	FROM Sales.Customers c 
	LEFT JOIN Sales.Orders o
		ON c.CustomerID = o.CustomerID 
	LEFT JOIN Sales.Products p 
		ON o.ProductID = p.ProductID
	GROUP BY c.CustomerID 
) AS t;


-- Show the product IDs, names, prices and total number of orders.
SELECT 
	p.ProductID ,
	p.Product ,
	p.Price ,
	(SELECT COUNT(o.ProductID ) FROM Sales.Orders o) AS totalNumberOfOrders
FROM Sales.Products p ;


-- show all customer details and find the total orders for each customer.
SELECT 
	c.*,
	t.totalOrders 
FROM Sales.Customers c 
JOIN (SELECT 
	o.CustomerID ,
	COUNT(*) AS totalOrders 
FROM Sales.Orders o 
GROUP BY o.CustomerID ) AS t
	ON t.CustomerID = c.CustomerID ;


-- find the products that have a price higher than the average price of all products.
SELECT 
*
FROM Sales.Products p 
WHERE p.Price > (SELECT AVG(p2.Price ) FROM Sales.Products p2 );


-- show the details of orders made by customers in germany
SELECT 
*
FROM Sales.Orders o 
WHERE o.CustomerID IN (SELECT c.CustomerID FROM Sales.Customers c WHERE c.Country = 'Germany');
-- show the details of orders made by customers not in germany
SELECT 
*
FROM Sales.Orders o 
WHERE o.CustomerID IN (SELECT c.CustomerID FROM Sales.Customers c WHERE c.Country != 'Germany');


-- Find female employees whose salaries are greater than the salaries of any male employees
SELECT 
	e.EmployeeID ,
	e.FirstName ,
	e.Salary 
FROM Sales.Employees e 
WHERE e.Gender = 'F' AND e.Salary > ANY (SELECT e2.Salary FROM Sales.Employees e2 WHERE e2.Gender = 'M');
SELECT 
	e.EmployeeID ,
	e.FirstName ,
	e.Salary 
FROM Sales.Employees e 
WHERE e.Gender = 'F' AND e.Salary > ALL (SELECT e2.Salary FROM Sales.Employees e2 WHERE e2.Gender = 'M');


-- Show all customer details and find the total orders of each customer
SELECT 
*,
(SELECT COUNT(*) FROM Sales.Orders o WHERE o.CustomerID = c.CustomerID  ) AS totalSales
FROM Sales.Customers c ;

-- Show the details of orders made by customers in Germany
SELECT 
*
FROM Sales.Orders o 
WHERE EXISTS (SELECT 1 FROM Sales.Customers c WHERE c.Country = 'Germany' AND o.CustomerID = c.CustomerID );
-- Show the details of orders made by customers not in Germany
SELECT 
*
FROM Sales.Orders o 
WHERE NOT EXISTS (SELECT 1 FROM Sales.Customers c WHERE c.Country = 'Germany' AND o.CustomerID = c.CustomerID );
