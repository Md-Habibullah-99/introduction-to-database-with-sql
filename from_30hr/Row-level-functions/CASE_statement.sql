USE SalesDB;


SELECT 
	o.OrderID ,
	o.Quantity  ,
	CASE 
		WHEN o.Quantity >= 3 THEN 'High'
		WHEN o.Quantity >= 2 THEN 'Medium'
		WHEN o.Quantity IS NULL OR o.Quantity = 0 THEN 'N/A'
		ELSE 'Low'
	END AS [status]
FROM Sales.Orders o ;


/*
Generate a report showing the total sales for each category:
- High: if the sales higher than 50
- Medium: if the sales between 20 and 50
- Low: if the sales equal or lower than 20
Sort the result from height sales to lowest.
*/
SELECT 
	Category ,
	SUM(Sales) [total sales] 
FROM (
SELECT 
	OrderID,
	Sales,
	CASE 
		WHEN o.Sales > 50 
			THEN 'High'
		WHEN o.Sales > 20 
			THEN 'Medium'
		WHEN o.Sales IS NULL 
			THEN 'N/A'
		ELSE 'Low'
	END AS Category
FROM Sales.Orders o 
)t 
GROUP BY Category
ORDER BY SUM(Sales)
DESC;

/*
 * Show employee gender as full full text
 */

SELECT 
	EmployeeID ,
	FirstName ,
	CASE 
		WHEN Gender = 'M' THEN 'Male'
		WHEN Gender = 'F' THEN 'Female'
		ELSE 'Not Available'
	END
FROM Sales.Employees ;

-- full form and quick form of case 
SELECT
	c.CustomerID ,
	c.FirstName ,
	c.Country ,
	CASE 
		WHEN c.Country = 'Germany' THEN 'DE'
		WHEN c.Country = 'USA' THEN 'US'
	END AS [full form],
	CASE c.Country 
		WHEN 'Germany' THEN 'DE'
		WHEN 'USA' THEN 'US'
	END AS [quick form]
FROM Sales.Customers c;


SELECT
	o.CustomerID ,
	SUM(CASE  
		WHEN o.Sales > 30 THEN 1
		ELSE 0
	END) AS [totalOrders]
FROM Sales.Orders o
GROUP BY o.CustomerID;
