
USE MidCoursePractice;




-- T01:
SELECT 
o.order_id ,
o.order_date ,
o.total_amount ,
o.status 
FROM orders o  
WHERE o.status = 'delivered' 
	AND 
	o.total_amount > (SELECT AVG(total_amount ) FROM orders)
ORDER BY o.total_amount DESC;




-- T02:
WITH CTE_vp AS 
(
	SELECT 
		c.customer_id ,
		SUM(o.total_amount ) AS total_spend ,
		AVG(o.total_amount ) AS avg_order_value ,
		COUNT(*) AS total_orders
	FROM orders o 
	LEFT JOIN customers c 
		ON o.customer_id = c.customer_id
	GROUP BY c.customer_id 
)
SELECT DISTINCT 
	c.customer_id ,
	c.first_name ,
	c.last_name ,
	cv.total_spend ,
	cv.avg_order_value ,
	cv.total_orders
FROM CTE_vp cv
LEFT JOIN customers c 
	ON c.customer_id = cv.customer_id 
WHERE cv.total_orders > 1 AND cv.total_spend > (
	SELECT 
		SUM(CAST(total_amount AS FLOAT)) / COUNT(DISTINCT customer_id) AS overall_avg_spend
	FROM orders 
)
ORDER BY cv.total_spend DESC;
-- better:
-- Step 1: Calculate each customer's spending metrics
WITH customer_spending AS (
    SELECT 
        c.customer_id,
        c.first_name,
        c.last_name,
        COUNT(o.order_id) AS order_count,
        SUM(o.total_amount) AS total_spent,
        AVG(o.total_amount) AS avg_order_value
    FROM customers c
    INNER JOIN orders o ON c.customer_id = o.customer_id
    GROUP BY c.customer_id, c.first_name, c.last_name
),
-- Step 2: Calculate the overall average customer spend
overall_avg AS (
    SELECT AVG(total_spent) AS avg_customer_spend
    FROM customer_spending
)
-- Step 3: Final selection with filtering
SELECT 
    cs.customer_id,
    cs.first_name,
    cs.last_name,
    cs.total_spent,
    cs.avg_order_value,
    cs.order_count
FROM customer_spending cs
CROSS JOIN overall_avg oa  -- CROSS JOIN is safe here (only 1 row)
WHERE cs.order_count >= 2
    AND cs.total_spent > oa.avg_customer_spend
ORDER BY cs.total_spent DESC;




-- T03:
WITH CTE_dew_and_etc AS 
(
	SELECT 
		s.order_id ,
		s.carrier ,
		s.shipment_date ,
		s.delivery_date ,
		AVG(CAST(DATEDIFF(day, s.shipment_date , s.delivery_date ) AS FLOAT)) OVER (PARTITION BY s.carrier ) AS avg_shipping_duration,
		DATEDIFF(day, s.shipment_date, s.delivery_date  ) AS shipping_duration
	FROM shipments s 
),
CTE_orders AS 
(
	SELECT 
		o.order_id ,
		cde.carrier ,
		cde.shipment_date ,
		cde.delivery_date ,
		cde.shipping_duration
	FROM orders o 
	INNER JOIN CTE_dew_and_etc cde 
		ON o.order_id = cde.order_id
	WHERE o.status = 'delivered' AND cde.shipping_duration < cde.avg_shipping_duration  
)
SELECT 
	co.order_id ,
	co.carrier ,
	co.shipment_date ,
	co.delivery_date ,
	co.shipping_duration
FROM CTE_orders co
ORDER BY co.carrier ,co.shipping_duration ASC;
-- OR:
-- Correlated subquery approach
SELECT 
    o.order_id,
    s.carrier,
    s.shipment_date,
    s.delivery_date,
    DATEDIFF(day, s.shipment_date, s.delivery_date) AS shipping_duration
FROM orders o
INNER JOIN shipments s ON o.order_id = s.order_id
WHERE o.status = 'delivered'
    AND DATEDIFF(day, s.shipment_date, s.delivery_date) < (
        -- Correlated subquery: calculates avg for THIS carrier
        SELECT AVG(CAST(DATEDIFF(day, s2.shipment_date, s2.delivery_date) AS FLOAT))
        FROM shipments s2
        WHERE s2.carrier = s.carrier  -- This is the correlation!
    )
ORDER BY s.carrier, shipping_duration ASC;




-- T04:
WITH CTE_customer_total AS 
(
	SELECT 
		o.customer_id ,
		SUM(o.total_amount ) AS total_spent
	FROM orders o
	GROUP BY o.customer_id 
),
CTE_rank AS 
(
	SELECT
		cct.customer_id ,
		cct.total_spent ,
		RANK() OVER (ORDER BY cct.total_spent DESC) AS spending_rank
	FROM CTE_customer_total cct
),
CTE_tier AS 
(
	SELECT
		cct.customer_id ,
		NTILE(5) OVER (ORDER BY cct.total_spent DESC) AS tier ,
		(CAST(cct.total_spent AS FLOAT) / SUM(cct.total_spent ) OVER ()) * 100 AS revenue_percentage
	FROM CTE_customer_total cct
)
SELECT 
	c.customer_id ,
	c.first_name ,
	c.last_name ,
	cr.total_spent,
	cr.spending_rank ,
	CASE ct.tier 
		WHEN 1 THEN 'High'
		WHEN 5 THEN 'Low'
		ELSE 'Medium'
	END AS spending_tier ,
	ct.revenue_percentage
FROM customers c  
INNER JOIN  CTE_rank cr
	ON c.customer_id = cr.customer_id
INNER JOIN CTE_tier ct
	ON c.customer_id = ct.customer_id;




-- T05:
-- CTE approach
WITH CTE_placed_order_in_j AS 
(
	SELECT 
		o.customer_id 
	FROM orders o 
	WHERE YEAR(o.order_date) = 2024 AND MONTH(o.order_date ) = 1
	GROUP BY o.customer_id 
),
CTE_customers AS 
(
	SELECT
		o.customer_id ,
		MIN(o.order_date ) AS first_order_date ,
		MAX(o.order_date ) AS most_recent_order_date ,
		COUNT(*) AS total_number_of_orders ,
		AVG(o.total_amount ) AS avg_order_amount
	FROM orders o
	INNER JOIN CTE_placed_order_in_j cpoj
		ON cpoj.customer_id = o.customer_id
	GROUP BY o.customer_id 
)
SELECT 
	c.customer_id ,
	c.first_name ,
	c.last_name ,
	cc.first_order_date ,
	cc.most_recent_order_date ,
	cc.total_number_of_orders ,
	cc.avg_order_amount 
FROM CTE_customers cc 
INNER JOIN customers c 
	ON cc.customer_id = c.customer_id;

-- sub query approach
SELECT 
	c.customer_id ,
	c.first_name ,
	c.last_name ,
	everything_else.first_order_date ,
	everything_else.most_recent_order_date ,
	everything_else.total_number_of_orders ,
	everything_else.avg_order_amount 
FROM customers c 
INNER JOIN (
	SELECT 
		o.customer_id ,
		MIN(o.order_date ) AS first_order_date ,
		MAX(o.order_date ) AS most_recent_order_date ,
		COUNT(*) AS total_number_of_orders ,
		AVG(o.total_amount ) AS avg_order_amount
	FROM orders o
	WHERE o.customer_id IN (
		SELECT 
			customer_id 
		FROM orders
		WHERE MONTH(order_date) = 1 AND YEAR(order_date) = 2024
		GROUP BY customer_id 
	)
	GROUP BY o.customer_id 
) AS everything_else
ON c.customer_id = everything_else.customer_id ;




SELECT * FROM customers c ;
SELECT * FROM shipments shp ;
SELECT * FROM order_items oi ;
SELECT * FROM orders o ;

