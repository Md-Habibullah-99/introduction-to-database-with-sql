SELECT *
FROM customers c ;

SELECT * 
FROM orders o ;

--inner join is the default join in join table
SELECT * 
FROM customers c 
INNER JOIN orders o 
ON c.id=o.customer_id ;
--more specific :
SELECT 
	c.id,
	c.first_name,
	o.order_id,
	o.sales
FROM customers c 
INNER JOIN orders o 
ON c.id=o.customer_id ;

--left join
SELECT 
	c.id,
	c.first_name,
	o.order_id,
	o.sales 
FROM customers c 
LEFT JOIN orders o 
ON c.id=o.customer_id ;

--right join
SELECT 
	c.id,
	c.first_name,
	o.order_id,
	o.sales 
FROM customers c 
RIGHT JOIN orders o 
ON c.id=o.customer_id ;
--same result but with left join
SELECT 
	c.id,
	c.first_name,
	o.order_id,
	o.sales 
FROM orders o  
LEFT JOIN customers c
ON c.id=o.customer_id ;

-- full join
SELECT 
	c.id,
	c.first_name,
	o.order_id,
	o.sales 
FROM customers c 
FULL JOIN orders o 
ON c.id=o.customer_id ;



-- Advanced joins

-- left anti join
SELECT 
	c.id,
	c.first_name 
FROM customers c 
LEFT JOIN orders o 
ON c.id=o.customer_id 
WHERE o.customer_id IS NULL;

-- right anti join
SELECT 
	o.customer_id,
	o.order_id ,
	o.sales 
FROM customers c 
RIGHT JOIN orders o 
ON c.id=o.customer_id 
WHERE c.id IS NULL;
-- same result:
SELECT 
	o.customer_id,
	o.order_id ,
	o.sales 
FROM orders o
LEFT JOIN customers c 
ON c.id=o.customer_id 
WHERE c.id IS NULL;

-- full anti join
SELECT 
	c.id,
	c.first_name,
	o.order_id,
	o.sales 
FROM customers c 
FULL JOIN orders o 
ON c.id=o.customer_id 
WHERE c.id IS NULL OR o.customer_id IS NULL;

-- cross join
SELECT *
FROM customers
CROSS JOIN orders;

-- HW
/* 
 * GET ALL CUSTOMERS ALONGI WITH THEIR ORDERS, 
 * BUT ONLY FOR CUSTOMERS WHO HAVE PLACED AN ORDER
 * (WITHOUT UUSING INNER JOIN)
 */

SELECT c.*
FROM customers c ,orders o
WHERE o.customer_id = c.id;
-- or
SELECT c.*
FROM customers c 
LEFT JOIN orders o 
ON c.id=o.customer_id 
WHERE o.customer_id IS NOT NULL;
