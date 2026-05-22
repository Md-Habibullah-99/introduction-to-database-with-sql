-- Q12:
SELECT product_name AS "Product name starts with N"
FROM sales
WHERE product_name LIKE 'N%'
GROUP BY product_name;

-- Q13:
SELECT ROUND(AVG(quantity*price_per_unit), 2) AS "Average Revenue Per Sale"
FROM sales;

-- Q14:
SELECT product_name, sale_date
FROM sales
WHERE sale_date >= '2025-02-10'
ORDER BY sale_date
LIMIT 3;

-- Q15:
SELECT
  category,
  SUM(quantity*price_per_unit) AS "Total Revenue",
  COUNT(*) AS "Sale transactions",
  SUM(quantity*price_per_unit)/COUNT(*) AS "Average Revenue per transactions"
FROM sales
GROUP BY category;

-- Q16:
SELECT 
  product_name, 
  MAX(quantity) AS "Max quantity sold", 
  CASE
    WHEN COUNT(*)=1 THEN 0
    ELSE MIN(quantity)
  END AS "Minimum quantity sold"
FROM sales s1
GROUP BY product_name
HAVING MAX(quantity)>3*(
  SELECT CASE
      WHEN COUNT(*)=1 THEN 0
      ELSE MIN(quantity)
    END
  FROM sales s2
  WHERE s1.product_name = s2.product_name
);


-- Q17:
SELECT product_name, sale_date
FROM sales
ORDER BY sale_date
DESC
LIMIT 1
OFFSET 1;

-- Q18:
SELECT 
  product_name,
  SUM(quantity*price_per_unit) AS "Total Revenue",
  CASE
    WHEN SUM(quantity*price_per_unit) >= 1000 THEN 'Gold'
    WHEN SUM(quantity*price_per_unit) >= 100 AND SUM(quantity*price_per_unit)<1000 THEN 'Silver'
    WHEN SUM(quantity*price_per_unit) < 100 THEN 'Bronze'
  END AS tier
FROM sales
GROUP BY product_name;

-- Q19:
SELECT 
  product_name,
  (
    SELECT s2.price_per_unit
    FROM sales s2
    WHERE s1.product_name = s2.product_name
    GROUP BY s2.product_name
    ORDER BY s2.sale_date
    LIMIT 1
  ) AS "first sale price",
  (
    SELECT s2.sale_date
    FROM sales s2
    WHERE s1.product_name = s2.product_name
    GROUP BY s2.product_name
    ORDER BY s2.sale_date
    LIMIT 1
  ) AS "first sale date",
  (
    SELECT s2.price_per_unit
    FROM sales s2
    WHERE s1.product_name = s2.product_name
    GROUP BY s2.product_name,s2.sale_date
    ORDER BY s2.sale_date DESC
    LIMIT 1
  ) AS "last sale price",
  (
    SELECT s2.sale_date
    FROM sales s2
    WHERE s1.product_name = s2.product_name
    GROUP BY s2.product_name,s2.sale_date
    ORDER BY s2.sale_date DESC
    LIMIT 1
  ) AS "last sale date",
  (
    SELECT s2.price_per_unit
    FROM sales s2
    WHERE s1.product_name = s2.product_name
    GROUP BY s2.product_name,s2.sale_date
    ORDER BY s2.sale_date
    LIMIT 1
  )-(
    SELECT s2.price_per_unit
    FROM sales s2
    WHERE s1.product_name = s2.product_name
    GROUP BY s2.product_name,s2.sale_date
    ORDER BY s2.sale_date DESC
    LIMIT 1
  ) AS "price drop"
FROM sales s1
GROUP BY product_name
HAVING COUNT(*)>=2
ORDER BY (
    SELECT s2.price_per_unit
    FROM sales s2
    WHERE s1.product_name = s2.product_name
    GROUP BY s2.product_name,s2.sale_date
    ORDER BY s2.sale_date
    LIMIT 1
  )-(
    SELECT s2.price_per_unit
    FROM sales s2
    WHERE s1.product_name = s2.product_name
    GROUP BY s2.product_name,s2.sale_date
    ORDER BY s2.sale_date DESC
    LIMIT 1
  )
DESC
LIMIT 1;
-- Easy way:
SELECT 
  s1.product_name,
  (SELECT price_per_unit FROM sales s2 
   WHERE s2.product_name = s1.product_name 
   ORDER BY sale_date LIMIT 1) AS first_price,
  (SELECT price_per_unit FROM sales s3 
   WHERE s3.product_name = s1.product_name 
   ORDER BY sale_date DESC LIMIT 1) AS last_price,
  (SELECT price_per_unit FROM sales s2 
   WHERE s2.product_name = s1.product_name 
   ORDER BY sale_date LIMIT 1) - 
  (SELECT price_per_unit FROM sales s3 
   WHERE s3.product_name = s1.product_name 
   ORDER BY sale_date DESC LIMIT 1) AS drop_amount
FROM sales s1
WHERE product_name IN (SELECT product_name FROM sales GROUP BY product_name HAVING COUNT(*) >= 2)
GROUP BY s1.product_name
ORDER BY drop_amount DESC
LIMIT 1;

-- Q20:
SELECT 
  category,
  SUM(quantity*price_per_unit) AS "Total Revenue",
  ROUND(
  100*SUM(quantity*price_per_unit)/(
    SELECT SUM(s2.quantity*s2.price_per_unit) FROM sales s2
  ), 2) AS "percentage contribution"
FROM sales
GROUP BY category;

-- Q21:
-- wrong ans
SELECT 
  product_name,
  SUM(quantity) AS "Total quantity"
FROM sales
GROUP BY product_name
HAVING SUM(quantity)>(SELECT AVG(s2.quantity) FROM sales s2);
-- currection:
-- Step 1: Find average of product totals
SELECT AVG(product_total) FROM (
  SELECT SUM(quantity) AS product_total
  FROM sales
  GROUP BY product_name
) AS product_averages;

-- Step 2: Use it in main query
SELECT product_name, SUM(quantity) AS total_quantity
FROM sales
GROUP BY product_name
HAVING SUM(quantity) > (
  SELECT AVG(product_total)
  FROM (
    SELECT SUM(quantity) AS product_total
    FROM sales
    GROUP BY product_name
  )
);


-- Q22:
SELECT product_name,SUM(quantity) AS "quantity sold"
FROM sales
GROUP BY product_name
HAVING COUNT(STRFTIME('%Y-%m',sale_date))=1 AND SUM(quantity)>=3;

SELECT * FROM sales;