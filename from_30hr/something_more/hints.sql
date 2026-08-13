
USE SalesDB;

----------------  hints   -------------------
SELECT 
	o.Sales,
	c.Country 
FROM Sales.Orders o
LEFT JOIN Sales.Customers c WITH(FORCESEEK) -- forcing it to use table seek, also can fource to use a index or specific type of index
ON o.CustomerID = c.CustomerID
OPTION(HASH JOIN); -- giving an option to use hash join on execution plan -- also cant use WITH and OPTION at the same time 


