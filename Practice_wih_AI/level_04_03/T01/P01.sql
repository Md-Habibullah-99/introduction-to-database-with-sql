
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



-- T06:
WITH CTE_levels AS 
(
	SELECT 
	e.employee_id ,
	e.first_name ,
	e.last_name ,
	e.job_title ,
	e.manager_id ,
	0 AS level ,
	CONCAT(e.job_title , ' ->') AS path
	FROM employees e 
	WHERE e.manager_id IS NULL
	
	UNION ALL
	
	SELECT 
	e.employee_id ,
	e.first_name ,
	e.last_name ,
	e.job_title ,
	e.manager_id ,
	cl.level + 1 ,
	CONCAT(e.job_title , ' ->')
	FROM employees e
	INNER JOIN CTE_levels cl
		ON e.manager_id = cl.employee_id  
)
SELECT *
FROM CTE_levels cl
ORDER BY cl.level , cl.employee_id ;
-- currect one
WITH CTE_levels AS 
(
    -- Anchor: CEO (top of hierarchy)
    SELECT 
        e.employee_id,
        e.first_name,
        e.last_name,
        e.job_title,
        e.manager_id,
        0 AS level,
        CAST(e.job_title AS VARCHAR(500)) AS path  -- Start with CEO's title
    FROM employees e 
    WHERE e.manager_id IS NULL
    
    UNION ALL
    
    -- Recursive: Find direct reports
    SELECT 
        e.employee_id,
        e.first_name,
        e.last_name,
        e.job_title,
        e.manager_id,
        cl.level + 1,
        CAST(CONCAT(cl.path , ' -> ' , e.job_title) AS VARCHAR(500))  -- Append current title
    FROM employees e
    INNER JOIN CTE_levels cl
        ON e.manager_id = cl.employee_id  
)
SELECT *
FROM CTE_levels cl
ORDER BY cl.level, cl.employee_id;



-- T07:
WITH CTE_level AS (
	SELECT 
		e.employee_id ,
		e.manager_id ,
		e.department ,
		0 AS level
	FROM employees e
	WHERE e.manager_id IS NULL
	
	UNION ALL
	
	SELECT 
		e.employee_id ,
		e.manager_id ,
		e.department ,
		cl.level + 1
	FROM employees e
	INNER JOIN CTE_level AS cl 
		ON cl.employee_id = e.manager_id
),
CTE_departments AS (
	SELECT
		cl.employee_id ,
		cl.manager_id ,
		cl.department ,
		e.job_title ,
		cl.[level] ,
		CAST(e.job_title AS VARCHAR(500)) AS path
	FROM CTE_level AS cl
	LEFT JOIN employees e
		ON e.employee_id = cl.employee_id 
	WHERE cl.[level] = 1
	
	UNION ALL
	
	SELECT
		e.employee_id ,
		e.manager_id ,
		e.department ,
		e.job_title ,
		cd.[level] + 1 ,
		CAST(cd.path + ' -> ' + e.job_title AS VARCHAR(500)) 
	FROM employees e
	INNER JOIN CTE_departments AS cd 
		ON cd.employee_id = e.manager_id
)
SELECT 
	cd.department ,
	cd.employee_id ,
	e.first_name ,
	e.last_name ,
	e.job_title ,
	cd.manager_id ,
	cd.[level] ,
	cd.[path] 
FROM CTE_departments AS cd 
LEFT JOIN employees e 
	ON e.employee_id = cd.employee_id 
ORDER BY cd.department , cd.[level] ,cd.employee_id ;


-- T08:
WITH CTE_level AS 
(
	SELECT 
		e.employee_id ,
		e.manager_id ,
		e.department ,
		e.salary ,
		1 AS level
	FROM employees e
	WHERE e.manager_id = 1
	
	UNION ALL
	
	SELECT 
		e.employee_id ,
		e.manager_id ,
		e.department ,
		e.salary ,
		cl.level + 1
	FROM employees e
	INNER JOIN CTE_level AS cl 
		ON cl.employee_id = e.manager_id
),
CTE_rol_up AS 
(
	SELECT 
		* ,
		(SELECT COUNT(cl2.employee_id) FROM CTE_level cl2 WHERE cl2.manager_id = cl.employee_id AND cl2.[level] = 2) AS direct_reports ,
		(SELECT COUNT(cl2.employee_id) FROM CTE_level cl2 WHERE cl2.department = cl.department ) AS total_team_size ,
		SUM(cl.salary) OVER (PARTITION BY cl.department) AS total_team_salary
	FROM CTE_level cl
)
SELECT 
	cru.manager_id ,
	e.first_name + ' ' + e.last_name AS manager_name ,
	e.job_title ,
	cru.direct_reports ,
	cru.total_team_size ,
	cru.total_team_salary ,
	cru.total_team_salary / (cru.total_team_size + 1.0) AS avg_salary
FROM CTE_rol_up cru
LEFT JOIN employees e
	ON e.employee_id = cru.employee_id 
WHERE cru.manager_id = 1
ORDER BY cru.total_team_salary DESC;

-- Challenge 8: CORRECTED VERSION
WITH RECURSIVE team_hierarchy AS (
    -- Anchor: Start with all employees (leaf nodes)
    SELECT 
        employee_id,
        manager_id,
        first_name,
        last_name,
        job_title,
        salary,
        0 AS depth,
        employee_id AS root_manager_id  -- Track who is the top manager of this subtree
    FROM employees e
    WHERE employee_id NOT IN (SELECT DISTINCT manager_id FROM employees WHERE manager_id IS NOT NULL)
    
    UNION ALL
    
    -- Recursive: Build upward from leaf to manager
    SELECT 
        e.employee_id,
        e.manager_id,
        e.first_name,
        e.last_name,
        e.job_title,
        e.salary,
        th.depth + 1,
        th.root_manager_id
    FROM employees e
    INNER JOIN team_hierarchy th ON e.employee_id = th.manager_id
),
manager_teams AS (
    -- Aggregated team data for each manager
    SELECT 
        root_manager_id AS manager_id,
        COUNT(*) AS total_team_size,
        SUM(salary) AS total_team_salary,
        AVG(salary) AS avg_team_salary
    FROM team_hierarchy
    GROUP BY root_manager_id
)
SELECT 
    e.employee_id AS manager_id,
    e.first_name + ' ' + e.last_name AS manager_name,
    e.job_title,
    (SELECT COUNT(*) FROM employees WHERE manager_id = e.employee_id) AS direct_reports,
    mt.total_team_size,
    mt.total_team_salary,
    mt.avg_team_salary
FROM employees e
INNER JOIN manager_teams mt ON e.employee_id = mt.manager_id
WHERE e.employee_id IN (SELECT DISTINCT manager_id FROM employees WHERE manager_id IS NOT NULL)
ORDER BY mt.total_team_salary DESC;




SELECT * FROM customers c ;
SELECT * FROM shipments shp ;
SELECT * FROM order_items oi ;
SELECT * FROM orders o ;
SELECT * FROM employees e;