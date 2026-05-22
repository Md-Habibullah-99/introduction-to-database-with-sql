-- Q01:
SELECT * FROM employees
WHERE city='Boston';

-- Q02:
SELECT AVG(salary) AS "Average salary for all" FROM employees;

-- Q03:
SELECT department,COUNT(*)
FROM employees
GROUP BY department;

-- Q04:
SELECT * 
FROM employees e
WHERE e.salary > 60000
ORDER BY e.salary
DESC;

-- Q05:
SELECT e.name
FROM employees e
WHERE e.name LIKE 'A%';

-- Q06:
SELECT SUM(stock_quantity) AS "Total stock quantity"
FROM products;

-- Q07:
SELECT p.product_name, p.price
FROM products p
WHERE p.price BETWEEN 100 AND 500;

-- Q08:
SELECT e.name, e.department
FROM employees e
WHERE e.department IN ('HR','Sales');

-- Q09:
SELECT e.department, AVG(e.salary) AS "Avg slr"
FROM employees e
GROUP BY e.department
HAVING AVG(e.salary) > 55000;

-- Q10:
SELECT MAX(e.salary) AS "Highest salary"
FROM employees e;

-- Q11:
CREATE TABLE customers(
	customer_id INT,
	full_name VARCHAR(100),
	city TEXT,
	loyality_points INT DEFAULT 0
	);

-- Q12:
INSERT INTO employees
VALUES 
	(5,'Eve','IT',68000,'2023-08-01','Seattle');

-- Q13:
UPDATE employees
SET salary = salary + (salary*0.1)
WHERE department = 'Sales';
-- more simple:
UPDATE employees
SET salary = salary * 1.1
WHERE department = 'Sales';


-- Q14:
DELETE FROM employees
WHERE salary<50000;

-- Q15:
/* with delete from employees/Table name
 * we can perform selective delete like where id = 5 or where id between 4 and 9
 * but with truncate table employees 
 * we can delete all of the data at once . 
 * we can perform same operation with 'delete from '
 * but the time complexity of this is greater then trancate table
 */

-- Q16:
SELECT MIN(p.price) AS "minimum price"
FROM products p;

-- Q17:
SELECT 
	e.department,
	COUNT(*) AS total_emp
FROM employees e
GROUP BY e.department
HAVING COUNT(*)> 1;

-- Q18:
SELECT e.name
FROM employees e
WHERE e.name LIKE '%li%';

-- Q19:
SELECT 
	p.category,
	SUM(p.price*p.stock_quantity) AS "Total price in stock"
FROM products p
GROUP BY p.category
HAVING SUM(p.price*p.stock_quantity) > 5000;

-- Q20:
TRUNCATE TABLE products;
DROP TABLE products;

SELECT * FROM products;
SELECT * FROM employees;

/*
question from deepseek:

Excellent! You've got a solid foundation. Here are **20 practice questions** ranging from easy to medium difficulty, based *only* on what you’ve learned (no JOINs, subqueries, or advanced constraints yet).

Assume you have the following two tables:

**Table 1: `employees`**  
| employee_id | name     | department | salary | hire_date  | city     |
|-------------|----------|------------|--------|------------|----------|
| 1           | Alice    | Sales      | 55000  | 2021-03-15 | Boston   |
| 2           | Bob      | IT         | 72000  | 2020-06-20 | Chicago  |
| 3           | Charlie  | Sales      | 48000  | 2022-01-10 | Boston   |
| 4           | Diana    | HR         | 61000  | 2019-11-02 | Chicago  |

**Table 2: `products`** (created by you)
| product_id | product_name | category | price | stock_quantity |
|------------|--------------|----------|-------|----------------|
| 101        | Laptop       | Elec     | 800   | 15             |
| 102        | Mouse        | Elec     | 25    | 100            |
| 103        | Desk         | Furn     | 450   | 8              |

---

### Questions

1. Write a query to select all employees who live in **Boston**.

2. Write a query to find the **average salary** of all employees.

3. Write a query to count how many employees work in **each department**.

4. Write a query to find employees whose **salary is greater than 60000** and sort them by salary **highest first**.

5. Using `LIKE`, find employees whose **name starts with 'A'**.

6. Write a query to get the **total stock quantity** of all products.

7. Write a query to find products whose **price is between 100 and 500**.

8. Write a query using `IN` to select employees from **Sales and HR** departments.

9. Using `GROUP BY` and `HAVING`, find departments where the **average salary is above 55000**.

10. Write a query to find the **highest salary** in the company.

11. Using `CREATE TABLE`, write the SQL to create a new table called `customers` with columns: `customer_id` (integer), `full_name` (text up to 100 chars), `city` (text), `loyalty_points` (integer, default 0).

12. Write an `INSERT INTO` command to add a new employee: name 'Eve', department 'IT', salary 68000, hire_date '2023-08-01', city 'Seattle'.

13. Write an `UPDATE` statement to give a **10% raise** to all employees in the Sales department.

14. Write a `DELETE` statement to remove employees whose **salary is less than 50000**.

15. What is the difference between `DELETE FROM employees;` and `TRUNCATE TABLE employees;`? (Answer in a sentence or two.)

16. Write a query to find the **cheapest product** (minimum price) from the `products` table.

17. Write a query to list departments that have **more than 1 employee** (use `HAVING`).

18. Write a query to find employees whose **name contains 'li'** (case-insensitive? use LIKE).

19. Write a query to calculate the **total value of all products in stock** (price * stock_quantity) for each category, and show only categories where total value > 5000.

20. Write a query to **remove all rows** from the `products` table but keep the table structure for future use. Then write a query to delete the entire `products` table from the database.

---

Try to answer them one by one, and I’ll check your answers afterward. Good luck!
*/
