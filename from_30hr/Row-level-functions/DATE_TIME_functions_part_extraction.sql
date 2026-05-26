USE SalesDB

----------------- DATE --------------------
SELECT 
	OrderID,
	OrderDate,
	ShipDate,
	CreationTime,
	'2026-05-20' Hard_coded,
	GETDATE() Today
FROM Sales.Orders;


---------------------- Part Extraction ------------------------
SELECT 
	OrderID ,
	CreationTime,
	DAY(CreationTime) day,
	MONTH(CreationTime) month,
	YEAR(CreationTime) year
FROM Sales.Orders;

-- datepart
SELECT 
	OrderID ,
	CreationTime,
	DATEPART(mm, CreationTime ) mm_month,
	DATEPART(month, CreationTime ) month,
	DATEPART(YY, CreationTime ) yy,
	DATEPART(year, CreationTime ) year,
	DATEPART(hh, CreationTime ) hh,
	DATEPART(hour, CreationTime ) hour,
	DATEPART(quarter, CreationTime ) quarter,
	DATEPART(quarter, GETDATE()) today_quarter,
	DATEPART(weekday, CreationTime ) week_day,
	DATEPART(week, CreationTime ) week
FROM Sales.Orders;

-- datename
SELECT 
	OrderID,
	CreationTime ,
	DATENAME(quarter, DATEPART(quarter, CreationTime )) quarter,
	DATENAME(weekday, CreationTime ) week_day,
	DATENAME(month, CreationTime ) month_name,
	DATENAME(MM, GETDATE()) today_month_name,
	DATENAME(year, CreationTime ) year,
	DATENAME(day, CreationTime ) day,
	DATEPART(week, CreationTime ) week
FROM Sales.Orders;

-- datetrunc
SELECT 
	'2026-02-15 15:45:12:000' AS normal_date,
	DATETRUNC(minute, '2026-02-15 15:45:12:000') AS minute,
	DATETRUNC(month, '2026-02-15 15:45:12:000') AS month,
	DATETRUNC(day, '2026-02-15 15:45:12:000') AS day,
	DATETRUNC(hour, '2026-02-15 15:45:12:000') AS hour,
	DATETRUNC(year, CreationTime) AS hour
FROM Sales.Orders;

-- eomonth
SELECT
	'2026-06-15' normal_date,
	EOMONTH('2026-06-15') end_of_month,
	EOMONTH(creationTime) date_with_end_of_month,
	CAST(DATETRUNC(month, (creationTime)) AS DATE) date_with_start_of_month
FROM Sales.Orders o ;


-- use case ANALYSES
SELECT 
	CAST(DATETRUNC(month, (creationTime)) AS DATE) AS date_time,
	COUNT(*)
FROM Sales.Orders
GROUP BY CAST(DATETRUNC(month, (creationTime)) AS DATE);


-- another use case ANALYSES
SELECT 
	YEAR(OrderDate),
	COUNT(*) Number_of_orders
FROM Sales.Orders
GROUP BY YEAR(OrderDate);

SELECT 
	MONTH(OrderDate),
	COUNT(*) Number_of_orders
FROM Sales.Orders
GROUP BY MONTH(OrderDate);

SELECT 
	DATENAME(month, OrderDate) Order_date,
	COUNT(*) Number_of_orders
FROM Sales.Orders
GROUP BY DATENAME(month, OrderDate);

-- use case data filtaring
-- show all order that were placed during the month of february
SELECT *
FROM Sales.Orders o 
WHERE MONTH(o.OrderDate ) = 2 OR DATENAME(month, o.OrderDate ) = 'February'; -- integer is faster then string so avoid datename or datepart
