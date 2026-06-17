USE SalesDB;

-- for normal sum of Sales
SELECT 
	o.OrderID ,
	o.OrderDate ,
	o.Sales ,
	SUM(o.Sales ) OVER(ORDER BY o.OrderID ROWS BETWEEN UNBOUNDED PRECEDING AND  CURRENT ROW ) running_total ,
	SUM(o.Sales ) OVER(ORDER BY o.OrderID ROWS BETWEEN 2 PRECEDING AND CURRENT ROW ) rolling_total
FROM Sales.Orders o 
ORDER BY o.OrderID ;


-- running total
SELECT 
	o.OrderID ,
	o.OrderDate ,
	o.Sales ,
	SUM(o.Sales ) OVER(ORDER BY MONTH(o.OrderDate )) running_total -- default : DESC ROWS BETWEEN UNBOUNDED PRECEDING AND  CURRENT ROW 
FROM Sales.Orders o ;

-- rolling total
SELECT 
	o.OrderID ,
	o.OrderDate ,
	o.Sales ,
	SUM(o.Sales ) OVER(ORDER BY MONTH(o.OrderDate ) ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) rolling_total
FROM Sales.Orders o ;
