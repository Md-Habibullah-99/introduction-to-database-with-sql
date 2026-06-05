
USE SalesDB;

-- coalesce
SELECT 
	AVG(Score) [normal average],
	AVG(COALESCE(Score, 0) ) [with coalesce],
	AVG(ISNULL(Score, 0) ) [with isnull]
FROM Sales.Customers c ;

/*
 * display the full name of customers in a single fild 
 * by merging their first and last names,
 * and add 10 bonus points to each customer's score
*/
SELECT 
	c.CustomerID ,
	c.FirstName ,
	c.LastName ,
	COALESCE(c.FirstName , '') + ' ' + COALESCE(c.LastName , '') AS [full name],
	c.Score ,
	COALESCE(c.Score , 0) + 10 AS [score with bonus]
FROM Sales.Customers c ;

/*
 * sort the customers from lowest to highest scores, 
 * with nulls appearing last
*/ 
-- method 01
SELECT *
FROM Sales.Customers c 
ORDER BY ISNULL(c.Score, 9999999);
-- method 02 the professional one
SELECT 
	c.CustomerID,
	c.Score ,
	CASE
		WHEN c.Score IS NULL THEN 1 ELSE 0 
	END [flag]
FROM Sales.Customers c 
ORDER BY CASE WHEN c.Score IS NULL THEN 1 ELSE 0 END, c.Score ;

----------------------- NULLIF ----------------------
/*
 * find the sales price for each order by dividing the sales by the quantity
 */
SELECT 
	OrderID ,
	Quantity ,
	Sales ,
	Sales/NULLIF(Quantity, 0) [sales price]
FROM Sales.Orders ;

-- SCORE IS NULL
SELECT 
	*
FROM Sales.customers
WHERE Score IS NULL;
-- SCORE IS NOT NULL
SELECT 
	*
FROM Sales.customers
WHERE Score IS NOT NULL;


/*
 * List all details for coustomers who have not placed any orders
 */
SELECT 
	c.*,
	o.OrderID 
FROM Sales.Customers c
LEFT JOIN
	Sales.Orders o ON c.CustomerID = o.CustomerID 
WHERE o.OrderID IS NULL;


