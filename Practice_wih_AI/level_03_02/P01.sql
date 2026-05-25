/*
 * This is an excellent foundation. Based on what you’ve learned (SELECT, WHERE, GROUP BY, HAVING, ORDER BY, LIKE, IN, aggregate functions, CREATE TABLE, INSERT, UPDATE, DELETE, TRUNCATE, JOINS, and SET operations), here are 20 questions ranging from easy to tricky.

Try to solve them on paper or in a real database (like SQLite, MySQL, or PostgreSQL).

---

### Setup (Imaginary Tables)

**Table 1: `employees`**

| employee_id | name     | department_id | salary | hire_date  |
|-------------|----------|---------------|--------|------------|
| 1           | Alice    | 10            | 50000  | 2020-01-15 |
| 2           | Bob      | 20            | 60000  | 2019-03-10 |
| 3           | Charlie  | 10            | 55000  | 2021-06-20 |
| 4           | Diana    | 30            | 70000  | 2018-11-02 |
| 5           | Eve      | NULL          | 45000  | 2022-08-30 |

**Table 2: `departments`**

| department_id | department_name |
|---------------|-----------------|
| 10            | Sales           |
| 20            | IT              |
| 30            | HR              |
| 40            | Marketing       |

**Table 3: `orders` (for a different scenario – Q16-Q20)**

| order_id | customer_name | amount | order_date |
|----------|---------------|--------|------------|
| 101      | John          | 250    | 2025-01-01 |
| 102      | John          | 300    | 2025-01-02 |
| 103      | Sarah         | 100    | 2025-01-01 |

---

## 20 SQL Questions

### Basic SELECT & Filtering

1. Write a query to find the names and salaries of employees who earn more than 52000.

2. Write a query to find all employees whose name starts with 'A' or ends with 'e'.

3. Write a query to find employees whose department_id is either 10, 20, or 30. Use `IN`.

### Aggregation & GROUP BY

4. Write a query to count how many employees are in each department (include `NULL` department as a group). Show `department_id` and employee count.

5. Write a query to find the average salary per department, but only show departments whose average salary is greater than 55000. Use `HAVING`.

6. Write a query to find the total salary paid, highest salary, and lowest salary across the whole company.

### LIKE & Wildcards

7. Write a query to find employees whose name has exactly 5 letters.

8. Write a query to find employees whose name contains 'li' (case insensitive – assume default behavior of your SQL).

### UPDATE & DELETE (Write the SQL statements, not just SELECT)

9. Write an `UPDATE` statement to increase the salary of all employees in department 10 by 10%.

10. Write a `DELETE` statement to remove employees who have no department (department_id IS NULL).

11. What is the difference between `DELETE FROM employees;` and `TRUNCATE TABLE employees;`? (Explain in words.)

### CREATE TABLE & INSERT

12. Write a `CREATE TABLE` statement for a new table called `projects` with columns:  
   - `project_id` (integer, primary key)  
   - `project_name` (text, cannot be null)  
   - `budget` (decimal)

13. Write an `INSERT INTO` statement to add two projects: (1, 'AI Research', 100000) and (2, 'Cloud Migration', 75000).

### JOINs (INNER, LEFT, RIGHT – if supported)

14. Write a query using `INNER JOIN` to show employee names along with their department names.

15. Write a query using `LEFT JOIN` to show all employees (even those without a department) and their department names. If no department, show `NULL` as department name.

16. Write a query to find employees who are NOT assigned to any department that exists in the departments table. (Hint: This can be done with `LEFT JOIN` and `WHERE department_name IS NULL`.)

### SET Operations (UNION, INTERSECT, EXCEPT/MINUS)

*Assume your SQL dialect supports these.*

17. Write a query using `UNION` to return a single list of all `department_id` values from both `employees` and `departments` (no duplicates).

18. Write a query using `EXCEPT` (or `MINUS`) to find department IDs that exist in the `departments` table but are NOT used by any employee.

### Mixed / Scenario-Based

19. Write a query to find the second highest salary from the `employees` table. (Do not use `LIMIT 1 OFFSET 1` if your SQL doesn't support it – use a subquery or max trick.)

20. Combine everything:  
   Write a query to show department name, number of employees, and average salary, but only for departments that have at least 2 employees. Order the result by average salary descending.

---

Take your time. Write your answers, and I’ll check them when you’re ready. Good luck!
 */

USE master;

-- Q01:
SELECT 
	e.name,
	e.salary
FROM employees e
WHERE e.salary > 52000;

-- Q02:
SELECT 
	e.name
FROM employees e
WHERE e.name LIKE 'A%' OR e.name LIKE '%e';

-- Q03:
SELECT 
	e.name,
	e.department_id
FROM employees e 
WHERE e.department_id IN (10,20,30);

-- Q04:
SELECT
	e.department_id,
	COUNT(e.employee_id)
FROM employees e 
GROUP BY e.department_id;

-- Q05:
SELECT 
	d.department_name,
	AVG(e.salary) AS avg_salary
FROM employees e
LEFT JOIN
	departments d ON e.department_id = d.department_id
GROUP BY e.department_id, d.department_name
HAVING AVG(e.salary ) > 55000; -- i did it just to get the department names

-- Q06:
SELECT
	SUM(e.salary) AS total_salary,
	MAX(e.salary ) AS highest_salary,
	MIN(e.salary) AS lowest_salary
FROM employees e ;

-- Q07:
SELECT 
	e.name
FROM employees e 
WHERE e.name LIKE '_____';

-- Q08:
SELECT 
	e.name
FROM employees e 
WHERE e.name LIKE '%li%';

-- Q09:
UPDATE employees
SET salary = salary*1.1
WHERE department_id = 10;

-- Q10:
DELETE FROM employees 
WHERE department_id IS NULL ;

-- Q11:
/*
 * we can check conditions and delete spesific row with DELETE FROM employees;
 * but with TRUNCATE TABLE employees; we can delete all of the table 
 * data while keeping the table structure, 
 * we can perform truncate table xyz with delete from xyz, but it will take much
 * longer time then trancate table, i mean the time complexity is greater then trancate table
 * 
 */

-- Q12:
CREATE TABLE projects(
	project_id INT PRIMARY KEY,
	project_name VARCHAR(50) NOT NULL,
	budget FLOAT
);

-- Q13:
INSERT INTO projects 
VALUES
	(1,'AI Research', 100000),
	(2,'Cloud Migration', 75000);

-- Q14:
SELECT 
	e.name,
	d.department_name
FROM employees e 
INNER JOIN
	departments d ON e.department_id = d.department_id;

-- Q15:
SELECT
	e.name,
	d.department_name
FROM employees e 
LEFT JOIN 
	departments d ON e.department_id = d.department_id;

-- Q16:
SELECT
	e.name
FROM employees e 
LEFT JOIN 
	departments d ON e.department_id = d.department_id
WHERE d.department_id IS NULL;

-- Q17:
SELECT
	department_id
FROM employees 
UNION
SELECT
	department_id
FROM departments;

-- Q18:
SELECT
	department_id
FROM departments
EXCEPT
SELECT
	department_id
FROM employees ;

-- Q19:
SELECT TOP 2
	e.salary 
FROM employees e 
ORDER BY e.salary 
DESC; -- I could not find any way to cutoff the first max salary and keep the second most max salary
SELECT
	e.salary 
FROM employees e
ORDER BY e.salary
DESC
OFFSET 1 ROW
FETCH NEXT 1 ROWS ONLY; -- after searching for a while i found this way to cut off first max and keep only second max
-- better
-- Subquery method (works in all SQL)
SELECT MAX(salary) FROM employees 
WHERE salary < (SELECT MAX(salary) FROM employees);

-- Q20:
SELECT
	d.department_name,
	COUNT(*) AS number_of_employee,
	AVG(e.salary ) AS average_salary
FROM departments d  
LEFT JOIN 
	employees e ON d.department_id = e.department_id
GROUP BY d.department_name
HAVING COUNT(*) > 1
ORDER BY AVG(e.salary ) DESC;
-- better
SELECT d.department_name, COUNT(e.employee_id) as number_of_employee, AVG(e.salary)
FROM departments d  
LEFT JOIN employees e ON d.department_id = e.department_id
GROUP BY d.department_name
HAVING COUNT(e.employee_id) > 1
ORDER BY AVG(e.salary) DESC;


SELECT * FROM employees e ;
SELECT * FROM departments d;
SELECT * FROM orders o;

INSERT INTO employees VALUES (5,'abc',NULL,NULL,NULL);
DELETE FROM employees 
WHERE employee_id=5;
