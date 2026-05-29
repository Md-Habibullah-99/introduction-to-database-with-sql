USE SalesDB;

-------------------------------------- date time calculation -------------------------------------- 

-- DATEADD
SELECT
	CreationTime ,
	DATEADD(year, 1, OrderDate ) AS [with order date],
	DATEADD(year, 20, CreationTime ) AS [added 20 years],
	DATEADD(month, 20, CreationTime ) AS [added 20 month],
	DATEADD(day, 20, CreationTime ) AS [added 20 days],
	DATEADD(year, -20, CreationTime ) AS [removed 20 years],
	DATEADD(month, -20, CreationTime ) AS [removed 20 month],
	DATEADD(day, -20, CreationTime ) AS [removed 20 days],
	DATEADD(minute, -20, CreationTime ) AS [removed 20 minutes]
FROM Sales.Orders;


----- DATEDIFF

SELECT
	EmployeeID ,
	BirthDate ,
	DATEDIFF(year, BirthDate , GETDATE()) AS [age]
FROM Sales.Employees ;

SELECT 
	OrderID,
	OrderDate,
	ShipDate,
	DATEDIFF(day, OrderDate, ShipDate) AS [duration in dady]
FROM Sales.Orders;

SELECT 
	MONTH(OrderDate) [Order date],
	AVG(DATEDIFF(day, OrderDate, ShipDate)) AS [avarage shipping day]
FROM Sales.Orders
GROUP BY MONTH(OrderDate);


--------------------------------------------------  ISDATE  -------------------------------------------
SELECT 
	ISDATE(2036) '1',
	ISDATE(5036) '2',
	ISDATE('12336') '3',
	ISDATE('2026-09-21') '4',
	ISDATE('2026-09-32') '5',
	ISDATE('2024-02-29') '6',
	ISDATE('2021-02-29') '7',
	ISDATE('02-29-2021') '8'
;

SELECT 
	OrderDate,
--	CAST(OrderDate AS DATE),
	ISDATE(OrderDate),
	CASE
		WHEN ISDATE(OrderDate) = 1 THEN CAST(OrderDate AS DATE)
		ELSE '9999-01-01'
	END [new order date]
	
FROM 
(
	SELECT '2026-08-20' AS OrderDate UNION
	SELECT '2026-08-21' UNION 
	SELECT '2026-08-23' UNION 
	SELECT '2026-08'
) AS t
--WHERE ISDATE(OrderDate) = 0
;


-- Task
-- find the date difference between the current and previous order date
SELECT 
	OrderID,
	OrderDate [current order date],
	(
	SELECT MAX(o2.OrderDate) 
	FROM Sales.Orders o2 
	WHERE o2.OrderDate < o.OrderDate 
	) [previous order date],
	DATEDIFF(
		day, (
			SELECT MAX(o2.OrderDate) 
			FROM Sales.Orders o2 
			WHERE o2.OrderDate < o.OrderDate 
		), OrderDate
	) [difference from previous]
FROM Sales.Orders o
ORDER BY OrderDate ;

-- simple with window function
SELECT 
	OrderID,
	OrderDate [current order date],
	LAG(o.OrderDate ) OVER (ORDER BY o.OrderDate ) [previous order date],
	DATEDIFF(day, LAG(o.OrderDate ) OVER (ORDER BY o.OrderDate ), OrderDate) [difference]
FROM Sales.Orders o;
