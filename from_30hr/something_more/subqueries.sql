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
