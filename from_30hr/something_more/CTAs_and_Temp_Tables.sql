USE SalesDB;
--------------------------      CTAs       --------------------------


-- FOR MySQL | Postgres | Oracle ->
--CREATE TABLE CTAsOrders AS 
--(
--	SELECT *
--	FROM Sales.orders
--);

-- FOR sql-server
SELECT 
*
INTO CTAsOrders 
FROM Sales.Orders o ;


-- Refresh CTAs exp : every day
IF OBJECT_ID('Sales.Monthly_orders','U') IS NOT NULL
	DROP TABLE Sales.Monthly_orders;
GO
SELECT
	DATENAME(MONTH, o.OrderDate ) AS orderMonth ,
	SUM(o.OrderID ) AS orders_per_month 
	INTO Sales.Monthly_orders
FROM Sales.Orders o 
GROUP BY DATENAME(MONTH, o.OrderDate );



-- TEMP TABLES
SELECT 
	*
	INTO #TOrders
FROM Sales.Orders o;

SELECT *
FROM #TOrders;

DELETE FROM #TOrders 
WHERE OrderStatus = 'Delivered';



----------------- TASK
-- create a CTAs table that whows the total number of orders for each month
SELECT
	DATENAME(MONTH, o.OrderDate ) AS orderMonth ,
	SUM(o.OrderID ) AS orders_per_month 
	INTO Sales.CTAs_orders_by_month 
FROM Sales.Orders o 
GROUP BY DATENAME(MONTH, o.OrderDate );

SELECT * FROM Sales.CTAs_orders_by_month;

DROP TABLE Sales.CTAs_orders_by_month;
