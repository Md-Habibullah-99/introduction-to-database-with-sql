/*
 * Questions:
 * Great progress! Now you're thinking like a real SQL analyst.

Based on what you've learned (all JOIN types + anti-joins + cross join), here are **20 questions** using these two tables:

**Table 1: `employees`**  
| employee_id | name     | dept_id | salary | hire_date  |
|-------------|----------|---------|--------|------------|
| 1           | Alice    | 101     | 55000  | 2021-03-15 |
| 2           | Bob      | 102     | 72000  | 2020-06-20 |
| 3           | Charlie  | 101     | 48000  | 2022-01-10 |
| 4           | Diana    | 103     | 61000  | 2019-11-02 |
| 5           | Eve      | NULL    | 68000  | 2023-08-01 |

**Table 2: `departments`**  
| dept_id | dept_name   | budget |
|---------|-------------|--------|
| 101     | Sales       | 200000 |
| 102     | IT          | 350000 |
| 104     | HR          | 150000 |
| 105     | Marketing   | 180000 |

**Table 3: `projects`** (for cross join practice)  
| project_id | project_name |
|------------|--------------|
| 1          | Alpha        |
| 2          | Beta         |

---

## Questions

1. Write an **INNER JOIN** to get employee names along with their department names.

2. Use a **LEFT JOIN** to list all employees and their department names (including employees with no department).

3. Use a **RIGHT JOIN** to list all departments and any employees in them (including departments with no employees).

4. Write a **FULL OUTER JOIN** to show all employees and all departments, matched where possible.

5. Write a **LEFT ANTI JOIN** to find employees who are NOT assigned to any department.

6. Write a **RIGHT ANTI JOIN** to find departments that have NO employees.

7. Write a **CROSS JOIN** between `employees` and `projects` to show every possible employee-project assignment.

8. Using **INNER JOIN**, find employees who earn more than the average salary of their department (hint: you may need a subquery or self-join? — but try with self-JOIN if possible).

9. Use **LEFT JOIN** to show all departments and count how many employees work in each (including departments with 0 employees).

10. Write a **FULL ANTI JOIN** (simulate it using LEFT JOIN + RIGHT JOIN + UNION or WHERE NULL) to find employees with no department AND departments with no employees.

11. Using **INNER JOIN** on three tables (you'll need to create a small `employee_projects` table mentally), assume each employee can work on multiple projects — but without that table, just explain how you'd join `employees`, `departments`, and `projects`.

12. Write a **LEFT JOIN** where you also filter employees hired after 2021-01-01, but still show all departments.

13. Write a **RIGHT JOIN** that shows department budget and the total salary of employees in that department (NULL if no employees).

14. Use a **self JOIN** (INNER JOIN) to find pairs of employees who work in the same department (different employee_id).

15. Write a **LEFT ANTI JOIN** to find departments that have no high-paid employees (salary > 70000).

16. Write a query using **CROSS JOIN** and then filter with `WHERE` to simulate an INNER JOIN condition (e.g., only show cross join rows where employee's dept_id matches department's dept_id).

17. Use **FULL OUTER JOIN** with a WHERE clause to find unmatched rows only (simulate FULL ANTI JOIN).

18. Write a **RIGHT ANTI JOIN** to find employees who are not in department 101 or 102.

19. Chain two **LEFT JOINs**: employees → departments → (imagine a `locations` table with dept_id). Write the structure even if locations table isn't fully defined.

20. Write a query that uses **LEFT JOIN** to find all employees, their department name, and if no department, show 'No Department Assigned' (use COALESCE or IFNULL).

---

**Note for Q7 & Q16**:  
For Q7, just write the CROSS JOIN.  
For Q16, show how CROSS JOIN + WHERE can mimic INNER JOIN (even though inefficient).

Try your answers, and I'll review them. Ready when you are!
 */

DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS departments;
DROP TABLE IF EXISTS projects;

CREATE TABLE employees (
	employee_id INT PRIMARY KEY, 
	name VARCHAR(50), 
	dept_id INT, 
	salary INT, 
	hire_date DATE
);

INSERT INTO employees 
VALUES 
	(1,'Alice',101,55000,'2021-03-15'),
	(2,'Bob',102,72000,'2020-06-20'),
	(3,'Charlie',101,48000,'2022-01-10'),
	(4,'Diana',103,61000,'2019-11-02'),
	(5,'Eve',NULL,68000,'2023-08-01');

CREATE TABLE departments (
	dept_id INT PRIMARY KEY,
	dept_name VARCHAR(50),
	budget INT);

INSERT INTO departments
VALUES 
	(101,'Sales',200000),
	(102,'IT',350000),
	(104,'HR',150000),
	(105,'Marketing',180000);

CREATE TABLE projects (project_id INT, project_name VARCHAR(50));

INSERT INTO projects
VALUES 
	(1,'Alpha'),
	(2,'Beta');
