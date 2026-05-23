--comparison operators
SELECT *
FROM customers c 
WHERE c.country = 'Germany';

SELECT *
FROM customers c 
WHERE c.country <> 'Germany';

SELECT *
FROM customers c 
WHERE c.score > 500;

SELECT *
FROM customers c 
WHERE c.score >= 500;

SELECT *
FROM customers c 
WHERE c.score < 500;

SELECT *
FROM customers c 
WHERE c.score <= 500;

--logical operators
SELECT *
FROM customers c 
WHERE c.country = 'USA' AND c.score > 500;

SELECT *
FROM customers c 
WHERE c.country = 'USA' OR c.score > 500;

SELECT *
FROM customers c 
WHERE NOT c.country = 'USA';

--range
SELECT *
FROM customers c 
WHERE c.score BETWEEN 200 AND 800;

--membership operator
SELECT *
FROM customers c 
WHERE c.country IN ('USA','China','India');

SELECT *
FROM customers c 
WHERE c.country NOT IN ('USA','China','India');

--search
SELECT * 
FROM customers c 
WHERE c.first_name LIKE 'm%';

SELECT * 
FROM customers c 
WHERE c.first_name LIKE '%n';

SELECT * 
FROM customers c 
WHERE c.first_name LIKE '%r%';

SELECT * 
FROM customers c 
WHERE c.first_name LIKE '__r%';
