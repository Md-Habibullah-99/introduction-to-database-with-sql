-- https://chat.deepseek.com/share/2k9x66x47tu2obzsbp

-- with sales table/db
-- 02

-- The ultimate practice

-- Q01:
SELECT product_name, price_per_unit
FROM sales
WHERE price_per_unit>20;

-- Q02:
SELECT COUNT(*) AS "sale in 02"
FROM sales
WHERE sale_date BETWEEN '2025-02-01' AND '2025-02-28';

-- Q03:
SELECT product_name,sale_date, quantity*price_per_unit AS "Revenue"
FROM sales
ORDER BY sale_date DESC
LIMIT 5;


-- Q04:
SELECT 
  product_name, 
  SUM(quantity) AS "Total quantity", 
  SUM(quantity*price_per_unit) AS "Total revenue",
  ROUND(AVG(price_per_unit), 2) AS "Average price per unit"
FROM sales
GROUP BY product_name
HAVING SUM(quantity*price_per_unit)>50;

-- Q05:
SELECT 
  category,
  MIN(quantity) AS "Minimum quantity",
  MAX(quantity) AS "Maximum quantity",
  ROUND(AVG(quantity), 2) AS "Average quantity"
FROM sales
GROUP BY category;

-- Q06:
SELECT product_name,COUNT(product_name) AS "Appeared _ times"
FROM sales
GROUP BY product_name
HAVING COUNT(product_name)>=2;

-- Q07:
SELECT 
  product_name,
  SUM(quantity*price_per_unit) AS "Total revenue"
FROM sales
GROUP BY product_name
HAVING COUNT(product_name)>=2
ORDER BY SUM(quantity*price_per_unit) DESC
LIMIT 2;

-- Q08:
-- risky
SELECT
  product_name,
  quantity
FROM sales
ORDER BY quantity DESC, quantity*price_per_unit DESC
LIMIT 1;
-- Safer approach
SELECT product_name, MAX(quantity) AS quantity
FROM sales
GROUP BY product_name
ORDER BY quantity DESC, MAX(quantity*price_per_unit) DESC
LIMIT 1;

-- Q09:
SELECT 
  STRFTIME('%Y-%m', sale_date) AS "Month name",
  SUM(quantity*price_per_unit) AS "Total revenue",
  COUNT(DISTINCT product_name) AS "Number of Distinct product"
FROM sales
GROUP BY STRFTIME('%Y-%m', sale_date)
ORDER BY STRFTIME('%Y-%m', sale_date) ASC;

-- Q10:
-- tried
/* SELECT 
  s.product_name,
  SUM(s.quantity) AS quantity,
  (
  SELECT 
  CASE
    WHEN SUM(s1.quantity)>SUM(s.quantity) AND 
  FROM sales s1
  GROUP BY STRFTIME('%Y-%m', s1.sale_date),s1.product_name
  ) AS sale_date
FROM sales s
GROUP BY STRFTIME('%Y-%m', sale_date),product_name; */
SELECT s1.product_name, SUM(s1.quantity) AS "Total quantity", STRFTIME('%Y-%m', sale_date)
FROM sales s1
WHERE (
  SELECT SUM(s.quantity) 
  FROM sales s 
  WHERE s.sale_date 
  BETWEEN '2025-01-01' AND '2025-01-31' 
  GROUP BY STRFTIME('%Y-%m', s.sale_date)
  HAVING s1.product_name = s.product_name
) > (
  SELECT SUM(s.quantity) 
  FROM sales s 
  WHERE s.sale_date 
  BETWEEN '2025-02-01' AND '2025-02-28' 
  GROUP BY STRFTIME('%Y-%m', s.sale_date)
  HAVING s1.product_name = s.product_name
)
GROUP BY STRFTIME('%Y-%m', s1.sale_date),s1.product_name;

-- solution:
SELECT product_name
FROM sales
GROUP BY product_name
HAVING 
  SUM(CASE WHEN sale_date BETWEEN '2025-02-01' AND '2025-02-28' THEN quantity ELSE 0 END) >
  SUM(CASE WHEN sale_date BETWEEN '2025-01-01' AND '2025-01-31' THEN quantity ELSE 0 END);

-- Q11:
SELECT 
  product_name,
  SUM(quantity*price_per_unit) AS "Total revenue",
  CASE 
    WHEN SUM(quantity*price_per_unit) > 500 THEN 'High'
    ELSE 'LOW'
  END AS performer
FROM sales
GROUP BY product_name;


SELECT * FROM sales;