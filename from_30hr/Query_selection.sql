SELECT name FROM sys.tables;

SELECT * FROM customers;

SELECT * 
FROM customers c 
WHERE c."country"='Germany';

SELECT *
FROM customers c 
ORDER BY c.country ASC, c.score DESC;

SELECT c.country , SUM(c.score ) AS total_score
FROM customers c 
GROUP BY c.country ;

SELECT 
	c.country , 
	SUM(c.score ) AS total_score,
	COUNT(*) AS total_customers
FROM customers c 
GROUP BY c.country ;