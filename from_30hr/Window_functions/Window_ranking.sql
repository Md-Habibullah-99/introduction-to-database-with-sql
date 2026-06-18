USE SalesDB;

-----------  integer based ranking  ---------------
SELECT 
	o.OrderID ,
	o.OrderDate ,
	o.Sales ,
	ROW_NUMBER() OVER(ORDER BY o.Sales DESC) Sales_rank_RowNumber ,
	RANK() OVER(ORDER BY o.Sales DESC) Sales_rank_Rank ,
	DENSE_RANK() OVER(ORDER BY o.Sales DESC) Sales_rank_DenseRank
FROM Sales.Orders o ;



-------   top-n rank
-- find the top highest sales for each product
SELECT *
FROM (
	SELECT
		o.OrderID ,
		o.OrderDate ,
		o.ProductID ,
		o.Sales ,
		RANK() OVER(PARTITION BY o.ProductID ORDER BY o.Sales DESC) rankByProduct 
	FROM Sales.Orders o 
) t
WHERE rankByProduct = 1;

------------  bottom-n rank
-- find the lowest 2 customers based on their total sales
SELECT *
FROM (
	SELECT 
		o.CustomerID ,
		SUM(o.Sales ) totalSales,
		ROW_NUMBER() OVER(ORDER BY SUM(o.Sales ) ) ranking
	FROM Sales.Orders o 
	GROUP BY o.CustomerID 
)t
WHERE ranking <= 2;



---------------   NTILE
SELECT 
	OrderID ,
	Sales ,
	NTILE(1) OVER(ORDER BY Sales DESC) OneBucket ,
	NTILE(2) OVER(ORDER BY Sales DESC) TwoBucket ,
	NTILE(3) OVER(ORDER BY Sales DESC) ThreeBucket ,
	NTILE(4) OVER(ORDER BY Sales DESC) FourBucket 
FROM Sales.Orders ;


-----------------------------    Percentage-based ranking

-- cume_dist
SELECT 
	o.OrderID ,
	o.Sales ,
	CUME_DIST() OVER (ORDER BY o.Sales DESC) percentage_cume_dist ,
	PERCENT_RANK() OVER (ORDER BY o.Sales DESC) percentage_percentage 
FROM Sales.Orders o;





----------------   TATSKS: 

-- assign unique IDs to the row of 'OrdersArchive' table
SELECT 
	ROW_NUMBER() OVER(ORDER BY oa.OrderID ,oa.OrderDate ) unique_id,
	*
FROM Sales.OrdersArchive oa ;


-- identify duplicate rows in the table 'OrdersArchive' and return a clean result without any duplicates
SELECT *
FROM (SELECT 
	*,
	ROW_NUMBER() OVER (PARTITION BY oa.OrderID ORDER BY oa.CreationTime DESC) date_based_ranking
FROM Sales.OrdersArchive oa )t
WHERE date_based_ranking = 1;


-- segment all orders into 3 categories: high , medium and low sales.
SELECT 
	o.OrderID ,
	o.Sales ,
	NTILE(3) OVER (ORDER BY o.Sales DESC) segment ,
	CASE NTILE(3) OVER (ORDER BY o.Sales DESC)
		WHEN  1 THEN 'High'
		WHEN  2 THEN 'Medium'
		WHEN  3 THEN 'Low'
	END AS segment_str
FROM Sales.Orders o ;
-- Or
SELECT 
	*,
	CASE  
		WHEN segment = 1 THEN 'High'
		WHEN segment = 2 THEN 'Medium'
		WHEN segment = 3 THEN 'Low'
	END AS segment_str
FROM (
	SELECT 
		o.OrderID ,
		o.Sales ,
		NTILE(3) OVER (ORDER BY o.Sales DESC) segment 
	FROM Sales.Orders o 
)t;



-- find the products that fall within the highest 40% of price
SELECT 
	*
FROM (
	SELECT 
		*,
		CUME_DIST() OVER (ORDER BY p.Price DESC) percentage
	FROM Sales.Products p 
)t
WHERE t.percentage <= 0.4;
