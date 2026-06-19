USE SalesDB;

-- LEAD & LAG
SELECT 
	o.OrderID ,
	o.OrderDate ,
	o.Sales ,
	LEAD(o.Sales ,1) 	OVER (ORDER BY o.OrderDate ) lead_1_withoutDefaultValue ,
	LEAD(o.Sales ,1, 0) OVER (ORDER BY o.OrderDate ) lead_1_withDefaultValue ,
	LEAD(o.Sales ,2, 0) OVER (ORDER BY o.OrderDate ) lead_2_withDefaultValue ,
	LAG(o.Sales , 1) 	OVER (ORDER BY o.OrderDate ) lag_1_withoutDefaultValue ,
	LAG(o.Sales ,1, 0)  OVER (ORDER BY o.OrderDate ) lag_1_withDefaultValue ,
	LAG(o.Sales ,2, 0)  OVER (ORDER BY o.OrderDate ) lag_2_withDefaultValue 
FROM Sales.Orders o ;


-- FIRST_VALUE & LAST_VALUE
SELECT 
	o.OrderID ,
	o.Sales ,
	FIRST_VALUE(o.Sales ) OVER(ORDER BY MONTH(o.OrderDate ))
FROM Sales.Orders o;

SELECT 
	o.OrderID ,
	o.Sales ,
	MONTH(o.OrderDate ) month,
	LAST_VALUE(o.Sales ) OVER(ORDER BY MONTH(o.OrderDate ) DESC) --default and use less
FROM Sales.Orders o;

SELECT 
	o.OrderID ,
	o.Sales ,
	MONTH(o.OrderDate ) month,
	LAST_VALUE(o.Sales ) OVER( ORDER BY MONTH(o.OrderDate ) DESC
								ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING)
FROM Sales.Orders o;



-------   TASKS:

-- Analyze the month-over-month performance by finding the percentage change 
-- in sales between the current and previous months
SELECT 
	MONTH(o.OrderDate ) months ,
	SUM(o.Sales ) totalSale ,
	ROUND((LAG(SUM(o.Sales ) ,1,0) OVER (ORDER BY MONTH(o.OrderDate)) / CAST(SUM(o.Sales ) AS FLOAT) )*100 , 2) percentage_change  
FROM Sales.Orders o 
GROUP BY MONTH(o.OrderDate);
-- <- wrong way
-- currect way ->
SELECT 
	*,
	currentMonthSales - previousMonthSales AS MoM_Change ,
	ROUND(CAST((currentMonthSales - previousMonthSales) AS FLOAT ) / PreviousMonthSales * 100 , 2) AS MoM_Perc
FROM (
	SELECT 
		MONTH(o.OrderDate ) months ,
		SUM(o.Sales ) currentMonthSales ,
		LAG(SUM(o.Sales ) ,1) OVER (ORDER BY MONTH(o.OrderDate)) previousMonthSales   
	FROM Sales.Orders o 
	GROUP BY MONTH(o.OrderDate)
)t;


-- Analyze customer loyalty by ranking customers based on the average number of days between orders
SELECT 
	t.CustomerID ,
	AVG(DATEDIFF(day, t.previousOrderDate, t.OrderDate )) avgDate ,
	RANK() OVER (ORDER BY AVG(DATEDIFF(day, t.previousOrderDate, t.OrderDate )) ) rankAvg
FROM (
	SELECT 
		o.OrderID ,
		o.CustomerID ,
		o.OrderDate ,
		LAG(o.OrderDate ) OVER (PARTITION BY o.CustomerID ORDER BY o.OrderDate ) previousOrderDate 
	FROM Sales.Orders o)t 
GROUP BY t.CustomerID 
ORDER BY 
		CASE 
			WHEN AVG(DATEDIFF(day, t.previousOrderDate, t.OrderDate )) IS NULL THEN 1
			ELSE 0
		END;
-- OR
SELECT 
	t.CustomerID ,
	AVG(DATEDIFF(day, t.previousOrderDate, t.OrderDate )) avgDate ,
	RANK() OVER (ORDER BY ISNULL(AVG(DATEDIFF(day, t.previousOrderDate, t.OrderDate )), 999999999) ) rankAvg
FROM (
	SELECT 
		o.OrderID ,
		o.CustomerID ,
		o.OrderDate ,
		LAG(o.OrderDate ) OVER (PARTITION BY o.CustomerID ORDER BY o.OrderDate ) previousOrderDate 
	FROM Sales.Orders o)t 
GROUP BY t.CustomerID;



-- Find the lowest and highest sales for each product
SELECT 
	o.ProductID ,
	o.Sales ,
	FIRST_VALUE(o.Sales ) OVER (PARTITION BY o.ProductID ORDER BY o.Sales ) lowest_sale ,
	LAST_VALUE(o.Sales )  OVER (PARTITION BY o.ProductID ORDER BY o.Sales ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) highest_sale ,
	FIRST_VALUE(o.Sales ) OVER (PARTITION BY o.ProductID ORDER BY o.Sales DESC) highest_sale2 , -- with first value 
	MIN(o.Sales ) OVER (PARTITION BY o.ProductID ) lowest_sale2 ,
	MAX(o.Sales ) OVER (PARTITION BY o.ProductID ) highest_sale3 
FROM Sales.Orders o 
GROUP BY o.ProductID, o.Sales  ;
