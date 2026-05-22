-- https://chat.deepseek.com/share/2k9x66x47tu2obzsbp

-- with selse table

--Q01:
SELECT * FROM sales WHERE quantity>2;


--Q02:
SELECT product_name, category 
FROM sales
WHERE sale_date BETWEEN "2025-01-01" AND "2025-01-31"
ORDER BY sale_date ASC;


--Q03
SELECT SUM(quantity*price_per_unit) AS total_revenue
FROM sales
GROUP BY product_name;


--Q04
SELECT category, SUM(quantity) AS "Total quantity", COUNT(quantity) AS "Number of sales Transaction" , AVG(quantity) AS "Avarage quantity per sale"
FROM sales
GROUP BY category;


--Q05
SELECT product_name , SUM(quantity) AS "Total quantity sold"
FROM sales
GROUP BY product_name
HAVING SUM(quantity)>4;
