
-- Q01
SElECT category,SUM(quantity*price_per_unit) AS "Total revenue"
FROM sales
GROUP BY category
HAVING SUM(quantity*price_per_unit) > 10000;

-- Q02
SElECT 
  customer_city,
  SUM(quantity) AS "Total quantity sold",
  AVG(price_per_unit) AS "Average price per uint",
  COUNT(*) AS "Number of sales"
FROM sales
GROUP BY customer_city
HAVING COUNT(*)>=2;

-- Q03
SElECT 
  category,
  product_name,
  price_per_unit
FROM sales
GROUP BY category
HAVING price_per_unit=MAX(price_per_unit);

-- Q04
SElECT sale_id, product_name, quantity
FROM sales
WHERE quantity>(
  SElECT AVG(quantity) FROM sales);

-- Q05
SELECT 
  sale_date, 
  SUM(quantity * price_per_unit) AS "Total revenue per day"
FROM sales
GROUP BY sale_date
ORDER BY SUM(quantity * price_per_unit) DESC
LIMIT 2;

SElECT * FROM sales;