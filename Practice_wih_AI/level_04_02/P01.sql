USE TechGearAnalytics;


-- T01:
SELECT 
	t.SaleID ,
	t.employeeName ,
	t.running_total_sales_revenue ,
	t.avg_sale_revenue_by_dept  ,
	CASE 
		WHEN t.saleRevenue > t.avg_sale_revenue_by_dept THEN 'Above Target'
		WHEN t.saleRevenue = t.avg_sale_revenue_by_dept THEN 'At Target'
		ELSE 'Below Target'
	END AS sale_category ,
	DENSE_RANK() OVER (PARTITION BY t.Department ORDER BY t.totalSaleRevenue ) AS ranking ,
	LAG(t.saleRevenue) OVER (PARTITION BY t.EmployeeID ORDER BY t.SaleDate  ) AS previousSale 
FROM (
	SELECT 
		s.SaleID ,
		e.EmployeeID  ,
		s.SaleDate ,
		CONCAT(e.FirstName , ' ', e.LastName ) AS employeeName ,
		e.Department ,
		s.Quantity * p.UnitPrice *(1 - s.Discount ) AS saleRevenue ,
		SUM(s.Quantity * p.UnitPrice *(1 - s.Discount )) OVER (PARTITION BY e.EmployeeID) AS totalSaleRevenue ,
		ROUND(SUM(s.Quantity * p.UnitPrice *(1 - s.Discount )) OVER (PARTITION BY e.EmployeeID ORDER BY s.SaleDate ), 2) AS running_total_sales_revenue ,
		ROUND(AVG(s.Quantity * p.UnitPrice *(1 - s.Discount )) OVER (PARTITION BY e.Department ), 2) AS avg_sale_revenue_by_dept 
	FROM Sales s 
	LEFT JOIN Employees e
		ON e.EmployeeID = s.EmployeeID 
	LEFT JOIN Products p 
		ON p.ProductID = s.ProductID 
	) t;



-- T02:
SELECT 
	t.SaleID ,
	t.ProductName ,
	t.Category ,
	t.Quantity ,
	t.totalRevenue ,
	FIRST_VALUE(t.ProductName ) OVER (PARTITION BY t.Category ORDER BY t.totalRevenue DESC) AS bestSellingInCategory ,
	LAST_VALUE(t.ProductName ) OVER (PARTITION BY t.Category ORDER BY t.totalRevenue DESC ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) AS worstSellingInCategory ,
	ROUND(MAX(t.revenue ) OVER (PARTITION BY t.Category ) - t.revenue, 2) AS differenceFromMax ,
	CASE 
		WHEN NTILE(3) OVER (PARTITION BY t.Category ORDER BY t.totalRevenue DESC ) = 1 THEN 'Category Leader'
		WHEN NTILE(3) OVER (PARTITION BY t.Category ORDER BY t.totalRevenue DESC ) = 2 THEN 'Middle Performer'
		WHEN NTILE(3) OVER (PARTITION BY t.Category ORDER BY t.totalRevenue DESC ) = 3 THEN 'Category Trailing'
	END AS categoryRanking
FROM (
	SELECT 
		s.SaleID ,
		p.ProductID ,
		p.ProductName ,
		p.Category ,
		s.Quantity ,
		ROUND(p.UnitPrice * s.Quantity * (1 - s.Discount ), 2) AS revenue ,
		ROUND(SUM(p.UnitPrice * s.Quantity * (1 - s.Discount ) ) OVER (PARTITION BY p.ProductID ), 2) AS totalRevenue 
	FROM Products p 
	LEFT JOIN 
		Sales s ON p.ProductID = s.ProductID 
	)t;
-- the fix ->
SELECT 
    t.ProductName,
    t.Category,
    t.totalQuantity,
    t.totalRevenue,
    FIRST_VALUE(t.ProductName) OVER (PARTITION BY t.Category ORDER BY t.totalRevenue DESC) AS bestSellingInCategory,
    LAST_VALUE(t.ProductName) OVER (PARTITION BY t.Category ORDER BY t.totalRevenue DESC 
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS worstSellingInCategory,
    ROUND(MAX(t.totalRevenue) OVER (PARTITION BY t.Category) - t.totalRevenue, 2) AS differenceFromMax,
    CASE 
        WHEN DENSE_RANK() OVER (PARTITION BY t.Category ORDER BY t.totalRevenue DESC) = 1 THEN 'Category Leader'
        WHEN DENSE_RANK() OVER (PARTITION BY t.Category ORDER BY t.totalRevenue DESC) = 
            DENSE_RANK() OVER (PARTITION BY t.Category ORDER BY t.totalRevenue ASC) THEN 'Category Trailing'
        ELSE 'Middle Performer'
    END AS categoryRanking
FROM (
    SELECT 
        p.ProductID,
        p.ProductName,
        p.Category,
        SUM(s.Quantity) AS totalQuantity,
        ROUND(SUM(p.UnitPrice * s.Quantity * (1 - s.Discount)), 2) AS totalRevenue
    FROM Products p 
    LEFT JOIN Sales s ON p.ProductID = s.ProductID
    GROUP BY p.ProductID, p.ProductName, p.Category
) t
ORDER BY t.Category, t.totalRevenue DESC;


-- T03:
SELECT 
	t.[Date] ,
	t.totalMonthlyRevenue ,
	NTILE(4) OVER (ORDER BY t.totalMonthlyRevenue DESC) AS quartiles ,
	LEAD(t.totalMonthlyRevenue ) OVER (ORDER BY t.totalMonthlyRevenue ) AS nextMonthsPerformance ,
	(1 - t.totalMonthlyRevenue / LEAD(t.totalMonthlyRevenue ) OVER (ORDER BY t.monthNum ) ) * 100 AS currentToNextChangeByPercentage ,
	CASE NTILE(4) OVER (ORDER BY t.totalMonthlyRevenue DESC)
		WHEN 1 THEN 'Excellent'
		WHEN 2 THEN 'Good'
		WHEN 3 THEN 'Average'
		WHEN 4 THEN 'Poor'
	END AS quartilesPerformance ,
	SUM(t.totalMonthlyRevenue ) OVER (ORDER BY t.monthNum) AS runningTotal
FROM (
	SELECT 
		MONTH(s.SaleDate) AS monthNum ,
		CONCAT(DATENAME(MONTH , s.SaleDate ) ,' ', YEAR(s.SaleDate )) AS Date ,
		ROUND(SUM(p.UnitPrice * s.Quantity * (1 - s.Discount)), 2) AS totalMonthlyRevenue 
	FROM Sales s 
	LEFT JOIN
		Products p ON s.ProductID = p.ProductID
	GROUP BY MONTH(s.SaleDate), DATENAME(MONTH, s.SaleDate), YEAR(s.SaleDate)
)t
ORDER BY t.monthNum ;


-- T04:
SELECT 
	*,
	RANK() OVER (PARTITION BY t.Department  ORDER BY t.SalesRevenue DESC) AS [rank] ,
	DENSE_RANK() OVER (PARTITION BY t.Department ORDER BY t.SalesRevenue DESC) AS [dens Rank] ,
	ROUND(MAX(t.SalesRevenue ) OVER (PARTITION BY t.Department ) - t.SalesRevenue, 2) AS [diff From Max] ,
	CASE DENSE_RANK() OVER (PARTITION BY t.Department ORDER BY t.SalesRevenue DESC)
		WHEN 1 THEN 'Executive'
		WHEN 2 THEN 'Executive'
		WHEN 3 THEN 'Senior'
		WHEN 4 THEN 'Senior'
		ELSE 'Junior'
	END AS [preformance tier] ,
	SUM(t.SalesRevenue ) OVER (PARTITION BY t.Department ) AS [total sales revenue by dept] ,
	ROUND(CAST(t.SalesRevenue AS FLOAT) / SUM(t.SalesRevenue ) OVER (PARTITION BY t.Department ) * 100, 2) AS [contrib percentage] ,
	FIRST_VALUE(t.fullName ) OVER (PARTITION BY t.Department ORDER BY t.SalesRevenue DESC) AS [highest-earning ]
FROM (
	SELECT 
		e.Department ,
		CONCAT(e.FirstName , ' ', e.LastName ) AS fullName,
		SUM(p.UnitPrice * s.Quantity * (1 - s.Discount)) AS SalesRevenue 
	FROM Employees e 
	LEFT JOIN Sales s 
		ON e.EmployeeID = s.EmployeeID 
	LEFT JOIN Products p 
		ON s.ProductID = p.ProductID
	GROUP BY e.EmployeeID , e.Department ,e.FirstName , e.LastName 
	)t
ORDER BY Department , SalesRevenue 
DESC;






SELECT * FROM Employees e ;
SELECT * FROM Products p;
SELECT * FROM Sales s;
