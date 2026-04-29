-- https://chat.deepseek.com/share/2k9x66x47tu2obzsbp

-- with sales table

--Q06:
SELECT product_name, quantity, price_per_unit
FROM sales
ORDER BY price_per_unit DESC,quantity DESC LIMIT 3;

--Q07
SELECT category, AVG(quantity*price_per_unit) AS "Average revenue per sale"
FROM sales
GROUP BY category
HAVING COUNT(category)>2;

--Q08
-- wrng ans
/* SELECT product_name, SUM(quantity) AS "Total Quantity sold"
FROM sales
WHERE sale_date BETWEEN '2025-01-01' AND '2025-02-28'
GROUP BY product_name; */
SELECT product_name, SUM(quantity) AS "Total quantity sold"
FROM sales
GROUP BY product_name
HAVING sale_date BETWEEN '2025-01-01' AND '2025-02-28';
-- currect ans
SELECT product_name, SUM(quantity) AS "Total quantity sold"
FROM sales
WHERE sale_date BETWEEN '2025-01-01' AND '2025-02-28'
GROUP BY product_name
HAVING MIN(sale_date) <= '2025-01-31' 
   AND MAX(sale_date) >= '2025-02-01';

--Q09
-- wrong ans
SELECT s1.category, SUM(s1.quantity*s1.price_per_unit) AS "Total revenue",
SUM(s1.quantity*s1.price_per_unit)/COUNT(s1.quantity) AS "Avarage price per unit",(
  SELECT DISTINCT COUNT(s2.product_name)
  FROM sales s2
  GROUP BY s2.category
  HAVING s1.category = s2.category
) AS "Number of DISTINCT products" 
FROM sales s1
GROUP BY s1.category
ORDER BY SUM(s1.quantity*s1.price_per_unit) DESC LIMIT 1;
-- currect ans
SELECT 
  category, 
  SUM(quantity * price_per_unit) AS "Total revenue",
  AVG(price_per_unit) AS "Average price per unit",
  COUNT(DISTINCT product_name) AS "Number of DISTINCT products"
FROM sales
GROUP BY category
ORDER BY SUM(quantity * price_per_unit) DESC 
LIMIT 1;


--Q10
-- wrong ans
SELECT product_name, SUM(quantity) AS total_quantity
FROM sales
GROUP BY product_name
HAVING SUM(quantity)>(
  SELECT SUM(quantity)/COUNT(product_name)
  FROM sales
);
-- currect ans
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
-- or more simple
SELECT product_name, SUM(quantity) AS total_quantity
FROM sales
GROUP BY product_name
HAVING SUM(quantity) > (
  SELECT SUM(quantity) * 1.0 / COUNT(DISTINCT product_name)
  FROM sales
);

--Q11
SELECT product_name,sale_date, quantity*price_per_unit AS "Revenue per each sale"
FROM sales
WHERE quantity*price_per_unit > (
  SELECT AVG(s1.quantity*s1.price_per_unit)
  FROM sales s1
);

SELECT * FROM sales;