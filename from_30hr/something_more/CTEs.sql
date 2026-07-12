USE SalesDB;
--------------------------      COMMON TABLE EXPRESSION / CTE       --------------------------
-- standalone CTE
WITH customers AS 
(
	SELECT *
	FROM Sales.Employees  
)
SELECT 
*
FROM Customers c ;

-- multiple standalone CTE
WITH customers AS 
(
	SELECT *
	FROM Sales.Employees  
),
sales AS 
(
	SELECT *
	FROM Sales.Orders o 
)
SELECT 
*
FROM Customers c 
LEFT JOIN sales s
	ON s.SalesPersonID = c.EmployeeID 
ORDER BY s.OrderDate ;



-- Nested CTE
WITH customers AS 
(
	SELECT *
	FROM Sales.Employees  
),
sales AS 
(
	SELECT *
	FROM Sales.Orders o 
),
something AS 
(
	SELECT 
	s.SalesPersonID ,
	SUM(s.Sales ) AS totalSales
	FROM sales s
	GROUP BY s.SalesPersonID 
)
SELECT 
*
FROM Customers c 
LEFT JOIN sales s
	ON s.SalesPersonID = c.EmployeeID 
LEFT JOIN something sm
	ON sm.SalesPersonID = c.EmployeeID  
ORDER BY s.OrderDate;




-- Recursive CTE
-- generate a sequence of numbers from 1 to 20
WITH Series AS 
(
	SELECT 
	1 AS MyNumber
	
	UNION ALL
	
	SELECT 
	s.MyNumber + 1 
	FROM Series s 
	WHERE s.MyNumber < 20
)
SELECT *
FROM Series ;
OPTION (MAXRECURSION 10); -- fixed max recursion 10






-- TASKS:
-- find the total Sales per Customer
WITH CTE_totalSales AS 
(
	SELECT 
		o.CustomerID ,
		SUM(o.Sales ) AS totalSales
	FROM Sales.Orders o GROUP BY o.CustomerID
)
SELECT 
	c.CustomerID ,
	c.FirstName ,
	c.LastName ,
	ISNULL(swci.totalSales, 0) AS totalSales 
FROM Sales.Customers c 
LEFT JOIN CTE_totalSales swci 
	ON c.CustomerID = swci.CustomerID ;

-- find the total Sales per Customer and find the last order date per customer.

WITH CTE_totalSales AS 
(
	SELECT 
		o.CustomerID ,
		SUM(o.Sales ) AS totalSales
	FROM Sales.Orders o GROUP BY o.CustomerID
),
CTE_last_order_date AS 
(
	SELECT 
		o.CustomerID ,
		MAX(o.OrderDate ) AS lastOrderDate
	FROM Sales.Orders o 
	GROUP BY o.CustomerID 
)
SELECT 
	c.CustomerID ,
	c.FirstName ,
	c.LastName ,
	swci.totalSales ,
	lod.lastOrderDate 
FROM Sales.Customers c 
LEFT JOIN CTE_totalSales AS swci 
	ON c.CustomerID = swci.CustomerID 
LEFT JOIN CTE_last_order_date AS lod 
	ON c.CustomerID = lod.CustomerID ;

-- find the total Sales per Customer and find the last order date per customer. and Rank customers based on total sales per customer.

WITH CTE_totalSales AS 
(
	SELECT 
		o.CustomerID ,
		SUM(o.Sales ) AS totalSales
	FROM Sales.Orders o GROUP BY o.CustomerID
),
CTE_last_order_date AS 
(
	SELECT 
		o.CustomerID ,
		MAX(o.OrderDate ) AS lastOrderDate
	FROM Sales.Orders o 
	GROUP BY o.CustomerID 
),
CTE_customerRank AS 
(
	SELECT 
		ts.CustomerID ,
		RANK() OVER (ORDER BY ts.totalSales DESC) AS rankOnSale
	FROM CTE_totalSales AS ts 
)
SELECT 
	c.CustomerID ,
	c.FirstName ,
	c.LastName ,
	swci.totalSales ,
	lod.lastOrderDate ,
	ctr.rankOnSale 
FROM Sales.Customers c 
LEFT JOIN CTE_totalSales AS swci 
	ON c.CustomerID = swci.CustomerID 
LEFT JOIN CTE_last_order_date AS lod 
	ON c.CustomerID = lod.CustomerID 
LEFT JOIN CTE_customerRank AS ctr
	ON c.CustomerID = ctr.CustomerID ;

-- find the total Sales per Customer and find the last order date per customer. and Rank customers based on total sales per customer.
-- Segment customers based on their total sales.

WITH CTE_totalSales AS 
(
	SELECT 
		o.CustomerID ,
		SUM(o.Sales ) AS totalSales
	FROM Sales.Orders o GROUP BY o.CustomerID
),
CTE_last_order_date AS 
(
	SELECT 
		o.CustomerID ,
		MAX(o.OrderDate ) AS lastOrderDate
	FROM Sales.Orders o 
	GROUP BY o.CustomerID 
),
CTE_customerRank AS 
(
	SELECT 
		ts.CustomerID ,
		RANK() OVER (ORDER BY ts.totalSales DESC) AS rankOnSale
	FROM CTE_totalSales AS ts 
),
CTE_segment AS 
(
	SELECT 
	cte_ts.CustomerID ,
	CASE 
		WHEN cte_ts.totalSales > 100 THEN 'High'
		WHEN cte_ts.totalSales > 50 THEN 'Medium'
		ELSE 'Low'
	END AS segment
	FROM CTE_totalSales AS cte_ts
)
SELECT 
	c.CustomerID ,
	c.FirstName ,
	c.LastName ,
	swci.totalSales ,
	lod.lastOrderDate ,
	ctr.rankOnSale ,
	cte_seg.segment 
FROM Sales.Customers c 
LEFT JOIN CTE_totalSales AS swci 
	ON c.CustomerID = swci.CustomerID 
LEFT JOIN CTE_last_order_date AS lod 
	ON c.CustomerID = lod.CustomerID 
LEFT JOIN CTE_customerRank AS ctr
	ON c.CustomerID = ctr.CustomerID 
LEFT JOIN CTE_segment AS cte_seg
	ON c.CustomerID = cte_seg.CustomerID ;



-- Show the employee hierarchy by displaying each employee's level within the organization
WITH CTE_Hierchy AS 
(
	SELECT 
	e.EmployeeID ,
	e.FirstName ,
	e.ManagerID ,
	1 AS level
	FROM Sales.Employees e 
	WHERE e.ManagerID IS NULL
	
	UNION ALL
	
	SELECT 
	e.EmployeeID ,
	e.FirstName ,
	e.ManagerID , 
	ch.level + 1
	FROM Sales.Employees e, CTE_Hierchy ch
	WHERE e.ManagerID = ch.EmployeeID 
)
SELECT 
	*
FROM CTE_Hierchy cte_h;
-- OR with INNER JOIN for filter instade of where
WITH CTE_Hierchy AS 
(
	SELECT 
	e.EmployeeID ,
	e.FirstName ,
	e.ManagerID ,
	1 AS level
	FROM Sales.Employees e 
	WHERE e.ManagerID IS NULL
	
	UNION ALL
	
	SELECT 
	e.EmployeeID ,
	e.FirstName ,
	e.ManagerID , 
	ch.level + 1
	FROM Sales.Employees e
	INNER JOIN CTE_Hierchy ch
		ON e.ManagerID = ch.EmployeeID
)
SELECT 
	*
FROM CTE_Hierchy cte_h;
