-- https://chat.deepseek.com/share/oadkwz0po0adnyuv6a

-- with sales table/db

-- Q12
SELECT product_name , price_per_unit
FROM sales
ORDER BY price_per_unit ASC, product_name ASC
LIMIT 2;

-- Q13
SELECT category, ROUND(AVG(price_per_unit),2) AS "Avarage price"
FROM sales
GROUP BY category;

-- Q14
SELECT quantity
FROM sales
WHERE quantity>(
  SELECT AVG(quantity) FROM sales
);

-- Q15
SELECT product_name, SUM(quantity) AS "Total quantity sale"
FROM sales
GROUP BY product_name
HAVING SUM(quantity)<5;

-- Q16
SELECT category,COUNT(*) AS "Number of sale"
FROM sales
GROUP BY category
HAVING COUNT(category)>2;

-- Q17
-- wrong ans
SELECT product_name,sale_date, quantity*price_per_unit AS "Revenue"
FROM sales
ORDER BY sale_date ASC, quantity*price_per_unit DESC
LIMIT 3;
-- right ans:
SELECT product_name,sale_date, quantity*price_per_unit AS "Revenue"
FROM sales
ORDER BY sale_date DESC, quantity*price_per_unit DESC
LIMIT 3;

SELECT * FROM sales;