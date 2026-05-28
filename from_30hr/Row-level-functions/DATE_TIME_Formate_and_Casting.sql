USE SalesDB;

-- format
SELECT
	OrderDate AS normal_date,
	FORMAT(OrderDate , 'dd-MM-yyyy') AS formated_date,
	FORMAT(OrderDate , 'dd-MM-yyyy', 'ja-JP') AS formated_date_with_culture,
	FORMAT(CreationTime, 'dd') AS dd,
	FORMAT(CreationTime, 'ddd') AS ddd,
	FORMAT(CreationTime, 'dddd') AS dddd,
	FORMAT(CreationTime, 'MM') AS MM,
	FORMAT(CreationTime, 'MMM') AS MMM,
	FORMAT(CreationTime, 'MMMM') AS MMMM,
	FORMAT(CreationTime, 'MM-dd-yyyy -- HH-mm-ss') AS detaild_formate,
	FORMAT(CreationTime, 'MM-dd-yyyy -- hh-mm-ss') AS detaild_formate_12
FROM Sales.Orders;

SELECT
	FORMAT(123.4, 'P') parcentage,
	FORMAT(123.4, 'N') number,
	FORMAT(123.4, 'C') curency,
	FORMAT(123.4, 'D', 'fr-FR') decimal;


-- TASK: show CreationTime using following formate: Day Wed Jan Q1 2025 12:36:56 PM
SELECT
	OrderID,
	'Day ' + FORMAT(CreationTime, 'ddd MMM Q') + DATENAME(quarter, CreationTime) + FORMAT(CreationTime, ' yyyy hh:mm:ss tt') AS formated_time
FROM Sales.Orders;


-- use case
SELECT
	FORMAT(CreationTime, 'MMM yy') AS month_and_year,
	COUNT(*)
FROM Sales.Orders 
GROUP BY FORMAT(CreationTime, 'MMM yy');



----------------------------------------   casting    ----------------------------------------   

-- convert
SELECT
	CONVERT(INT, '123') AS string_to_int,
	CONVERT(VARCHAR(30), 123) AS int_to_string,
	CONVERT(DATE, '2026-12-10') AS string_to_date,
	CONVERT(DATE, CreationTime) AS date_time_to_date
FROM Sales.Orders;

SELECT
	CreationTime,
	CONVERT(DATE, CreationTime) AS [DATETIME to DATE Convert],
	CONVERT(VARCHAR, CreationTime, 32) AS [USA Style. 32],
	CONVERT(VARCHAR, CreationTime, 34) AS [EURO Style. 34]
FROM Sales.Orders;


---------------------------------    CAST    ---------------------------------    

SELECT 
	CAST('123' AS INT) AS [String to INT],
	CAST(123 AS VARCHAR) AS [INT to String ],
	CAST('2026-2-2' AS DATE) AS [String to date],
	CAST('2026-2-2' AS DATETIME) AS [String to datetime],
	CAST(CAST('2026-2-2' AS DATE) AS DATETIME) AS [DATE to datetime],
	CreationTime,
	CAST(CreationTime AS DATE) AS [DATETIME to date]
FROM Sales.Orders;

SELECT * FROM Sales.Orders o ;
