USE SalesDB;

SELECT 
	o.OrderID ,
	o.OrderDate ,
	o.ProductID ,
	o.Sales ,
	AVG(o.Sales ) OVER (PARTITION BY o.ProductID ) averageByProduct ,
	AVG(o.Sales ) OVER (PARTITION BY o.ProductID ORDER BY o.OrderDate ) movingAvg ,
	AVG(o.Sales ) OVER (PARTITION BY o.ProductID ORDER BY o.OrderDate ROWS BETWEEN CURRENT ROW AND 1 FOLLOWING ) rollingAvg 
FROM Sales.Orders o ;
