USE SalesDB;


SELECT 
	o.OrderID ,
	o.ProductID ,
	SUM(o.Sales ),
	o.OrderStatus 
FROM Sales.Orders o 
GROUP BY o.OrderID ,
	o.ProductID ,
	o.OrderStatus ;
-- LIMIT OF GROUP BY


-- window with agaggregate functions

SELECT
	o.OrderID ,
	o.OrderDate ,
	o.ProductID ,
	o.OrderStatus ,
	o.Sales ,
	SUM(o.Sales) OVER() TotalSales ,
	SUM(o.Sales) OVER(PARTITION BY o.ProductID ) TotalSalesByProducts ,
	SUM(o.Sales) OVER (PARTITION BY o.ProductID , o.OrderStatus ) Sales_by_product_and_status
FROM Sales.Orders o;

-- order by with window (order clause)
SELECT 
	o.OrderID ,
	o.OrderDate ,
	o.Sales ,
	RANK() OVER (ORDER BY o.Sales DESC) ranking_by_sales
FROM Sales.Orders o ;

-- frame clause
SELECT 
	o.OrderID ,
	o.OrderDate ,
	o.Sales ,
	SUM(o.Sales )
	OVER (
		ORDER BY MONTH(o.OrderDate ) DESC 
		ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING 
	) moking_running_total
FROM Sales.Orders o ;

SELECT 
	o.OrderID ,
	o.OrderDate ,
	o.OrderStatus ,
	o.Sales ,
	SUM(o.Sales ) OVER (
		PARTITION BY o.OrderStatus 
		ORDER BY o.OrderDate 
		ROWS BETWEEN CURRENT ROW AND 2 FOLLOWING 
	) totalSales
FROM Sales.Orders o ;

--  shortcut only for preceding
SELECT 
	o.OrderID ,
	o.OrderDate ,
	o.OrderStatus ,
	o.Sales ,
	SUM(o.Sales ) OVER (
		PARTITION BY o.OrderStatus 
		ORDER BY o.OrderDate 
		ROWS 2 PRECEDING
	) totalSales
FROM Sales.Orders o ;

-- Q: Rank Customers based on their total sales
SELECT 
	o.CustomerID ,
	SUM(o.Sales ) TotalSales ,
	RANK() OVER (ORDER BY SUM(Sales) DESC ) RankCustomers
FROM Sales.Orders o 
GROUP BY o.CustomerID ;


-- percentage of contrebution in total salary
SELECT 
	o.OrderID ,
	o.ProductID ,
	o.Sales ,
	SUM(o.Sales ) OVER() TotalSales ,
	ROUND(CAST(o.Sales AS FLOAT) /SUM(o.Sales ) OVER() *100 , 2) Parcentage
FROM Sales.Orders o ;

----- AVG 
SELECT 
	o.OrderID ,
	o.OrderDate ,
	o.ProductID ,
	o.Sales ,
	AVG(ISNULL(o.Sales , 0)) OVER() avg_all ,
	AVG(ISNULL(o.Sales , 0)) OVER(PARTITION BY o.ProductID ) avg_product1
FROM Sales.Orders o;


-- greater then average sale
SELECT *
FROM (
	SELECT 
		o.OrderID ,
		o.Sales ,
		AVG(ISNULL(o.Sales , 0)) OVER() avg_all 
	FROM Sales.Orders o
) t
WHERE t.Sales > t.avg_all ;

-- min and max function
SELECT 
	o.OrderID ,
	o.OrderDate ,
	o.Sales ,
	MAX(o.Sales ) OVER() HeighestSale ,
	MIN(o.Sales ) OVER() LowestSale ,
	MAX(o.Sales ) OVER() - o.Sales  DevitionFromMaximum ,
	o.Sales - MIN(o.Sales ) OVER() DevitionFromMinimum 
FROM Sales.Orders o ;
