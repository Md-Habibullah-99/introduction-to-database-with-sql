-- Q01:
SELECT 
	e.name,
	d.dept_name
FROM employees e 
INNER JOIN departments d
ON e.dept_id = d.dept_id;

-- Q02:
SELECT 
	e.name,
	d.dept_name
FROM employees e 
LEFT JOIN departments d
ON e.dept_id = d.dept_id;

-- Q03:
SELECT 
	e.name,
	d.dept_name
FROM employees e 
RIGHT JOIN departments d
ON e.dept_id = d.dept_id;

-- Q04:
SELECT 
	e.name,
	d.dept_name
FROM employees e 
FULL JOIN departments d
ON e.dept_id = d.dept_id;

-- Q05:
SELECT 
	e.name,
	d.dept_name AS "Department"
FROM employees e 
LEFT JOIN departments d
ON e.dept_id = d.dept_id
WHERE d.dept_name IS NULL;

-- Q06:
SELECT 
	e.name AS "Employees",
	d.dept_name
FROM employees e 
RIGHT JOIN departments d
ON e.dept_id = d.dept_id
WHERE e.dept_id IS NULL;

-- Q07:
SELECT 
	e.name AS "Employees",
	p.project_name 
FROM employees e 
CROSS JOIN projects p;

-- Q08:
SELECT 
	e.name ,
	e.salary ,
	d.dept_name
FROM employees e 
INNER JOIN 
	departments d ON e.dept_id = d.dept_id
WHERE e.salary > (
	SELECT AVG(e2.salary) 
	FROM employees e2 
	WHERE e.dept_id=e2.dept_id
	GROUP BY e2.dept_id
);

-- Q09:
SELECT 
	d.dept_name,
	COUNT(e.dept_id) AS "total_employee"
FROM departments d 
LEFT JOIN 
	employees e ON d.dept_id = e.dept_id
GROUP BY d.dept_name, e.dept_id;

-- Q10:
SELECT 
	e.name,
	d.dept_name 
FROM employees e 
FULL JOIN 
	departments d ON e.dept_id = d.dept_id 
WHERE e.dept_id IS NULL OR  d.dept_id IS NULL;

-- Q11:
/* 
 * since each employee can work in multiple project 
 * i would use cross join , 
 * but if cross join is not allowed i will search for related columns 
 * then with the related columns i will use left join or full join or inner join while prioritizing the demand
 */

-- Q12:
SELECT *
FROM departments d 
LEFT JOIN 
	employees e ON d.dept_id = e.dept_id
WHERE e.hire_date > '2021-01-01' OR e.name IS NULL;

-- Q13:
SELECT 
	d.dept_name ,
	d.budget ,
	SUM(e.salary ) AS total_salary
FROM employees e 
RIGHT JOIN 
	departments d ON e.dept_id = d.dept_id 
GROUP BY d.dept_name, d.budget ;

-- Q14:
SELECT 
	e.name AS emp_1,
	(
	SELECT e2.name 
	FROM employees e2 
	WHERE e2.employee_id <> e.employee_id 
	AND e.dept_id = e2.dept_id 
	) AS emp_2,
	d.dept_name 
FROM employees e 
INNER JOIN 
	departments d ON e.dept_id = d.dept_id;

-- Q15:
SELECT 
	d.dept_name ,
	MAX(e.salary ) AS maximum_salary
FROM departments d 
LEFT JOIN 
	employees e ON e.dept_id = d.dept_id 
GROUP BY d.dept_name 
HAVING NOT MAX(e.salary ) > 70000;

-- Q16:
SELECT 
	*
FROM employees e 
CROSS JOIN 
	departments d 
WHERE e.dept_id = d.dept_id ;

-- Q17:
SELECT *
FROM employees e 
FULL JOIN 
	departments d ON e.dept_id = d.dept_id 
WHERE e.dept_id IS NULL OR d.dept_id IS NULL;

-- Q18:
SELECT 
	e.name,
	d.dept_name,
	d.dept_id 
FROM employees e  
RIGHT JOIN 
	departments d ON d.dept_id = e.dept_id 
WHERE d.dept_id <> 101 AND d.dept_id <> 102;

-- Q19:
SELECT *
FROM employees e 
LEFT JOIN 
	departments d ON e.dept_id = d.dept_id 
LEFT JOIN 
	locations l ON e.employee_id = l.residence_id;

-- Q20:
SELECT 
	e.name,
	ISNULL(d.dept_name , 'No Department Assigned') AS 'department name'
FROM employees e 
LEFT JOIN
	departments d ON e.dept_id = d.dept_id ;


SELECT * FROM employees e ;
SELECT * FROM departments d;
SELECT * FROM projects p;
