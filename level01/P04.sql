-- https://chat.deepseek.com/share/oadkwz0po0adnyuv6a

-- with sales table/db

-- Q18
SELECT * 
FROM sales
ORDER BY sale_date ASC;

-- Q19
SELECT product_name, price_per_unit
FROM sales
GROUP BY product_name
ORDER BY price_per_unit DESC
LIMIT 2;

-- Q20
SELECT product_name, sale_date
FROM sales
WHERE sale_date BETWEEN '2025-01-01' AND '2025-01-31'
ORDER BY sale_date DESC
LIMIT 2;


SELECT * FROM sales;