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
