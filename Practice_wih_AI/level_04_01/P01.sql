USE Master;

-- questions
/*

 30 Problems 

 Basic to Intermediate (1-10) - Single table + functions

1. Display employee names, salary, and a column showing 'High' if salary > 90000, 'Medium' if salary between 70000-90000, 'Low' otherwise using CASE.

2. List employees with their hire date and a column showing 'Recently Hired' if hired in 2020 or later, 'Experienced' if hired before 2017, and 'Regular' otherwise.

3. Using string functions, display firstname and lastname concatenated with a space, and also show the length of their full name.

4. Calculate for each employee: years of service (using DATEDIFF), and a column 'Tenure' with CASE: '<2 years', '2-5 years', '>5 years'.

5. Show employee names and their salary rounded to nearest thousand, also show salary as a percentage of 100000 (two decimal places).

6. List employees with their manager ID, and using ISNULL or COALESCE, display 'Top Management' for NULL manager IDs.

7. Display employee cities and count of employees per city, but only show cities with more than 2 employees.

8. Using CAST/CONVERT, show employee names and hire dates in format 'YYYY-MM-DD'.

9. Find employees whose first name starts with 'J' and ends with 'n' (using LIKE) and salary between 60000 and 90000.

10. Show employees with salary above average salary of all employees (use subquery in WHERE).

 Medium - JOINs and multiple tables (11-20)

11. Display order IDs, customer names, and employee names for all orders using JOIN.

12. List all products that have never been ordered (use LEFT JOIN and check for NULL).

13. Show department names and total salary budget per department (sum of employee salaries), only for departments with total salary > 150000.

14. Display each order with total order value (quantity * unitprice after discount) using JOIN between Orders, OrderDetails, and Products.

15. Find customers who have placed more than 1 order (use GROUP BY and HAVING).

16. Show employee names and their manager names (self-join on Employees table).

17. List all orders that took more than 5 days to ship (calculate using DATEDIFF), including those not shipped yet as 'Pending'.

18. Display product categories with total units sold and total revenue, sorted by revenue descending.

19. Find employees who earn more than the average salary of their department (correlated subquery).

20. Show each employee with their salary grade based on SalaryGrades table (use BETWEEN with JOIN).

 Advanced - SET operations and complex queries (21-30)

21. Using UNION, list all unique cities where either employees or customers are located. Add a column indicating 'Employee City' or 'Customer City'.

22. Using INTERSECT, find cities where both employees and customers are located.

23. Using EXCEPT, find cities where employees are located but no customers exist.

24. Combine CASE with aggregation: Show department-wise count of employees in each salary category (High/Medium/Low).

25. Create a query showing employee performance: For each order handled, display whether the order value is 'High Value' (>1000), 'Medium' (500-1000), or 'Low' (<500). Use CASE with subquery for order total.

26. Find customers who have ordered all product categories (use COUNT DISTINCT with nested subqueries).

27. Show a monthly sales summary for 2024: Month, Total Orders, Total Revenue, using DATE functions and GROUP BY.

28. Using multiple CTEs or subqueries: Show employees who earn above the company average AND manage at least one person.

29. Calculate running total of employee salaries by hire date (use window function if known, or self-join if not).

30. Final challenge: Create a complete sales report showing: order id, customer, employee, total order value, and a 'Priority' column based on: 'High' if order value > $2000 or customer credit limit > $70000, 'Low' if order value < $500, 'Medium' otherwise.

---

 Tips:
- Start with 1-10, then move to 11-20, then tackle 21-30
- For SET operations (21-23), ensure column structures match
- For problems requiring subqueries, try writing them step by step
- Test each query individually and verify results

Try solving these and let me know if you need hints or solutions for any specific problem!
*/

-- Q01:
SELECT 
	e.EmpID ,
	e.FirstName ,
	e.Salary ,
	CASE 
		WHEN e.Salary > 90000 THEN 'High'
		WHEN e.Salary BETWEEN 70000 AND 90000 THEN 'Medium'
		ELSE 'Low'
	END [salary level]
FROM Employees e ;

-- Q02:
SELECT 
	e.EmpID ,
	e.FirstName ,
	e.HireDate ,
	CASE 
		WHEN YEAR(e.HireDate) >= 2020 THEN 'Recently Hired'
		WHEN YEAR(e.HireDate) >= 2017 THEN 'Experienced'
		ELSE 'Regular'
	END AS 'status'
FROM Employees e ;

-- Q03:
SELECT 
	CONCAT(e.FirstName , ' ', e.LastName ) AS 'full_name',
	LEN(CONCAT(e.FirstName , ' ', e.LastName )) AS full_name_len
FROM Employees e ;

-- Q04:
SELECT 
	e.EmpID ,
	e.FirstName ,
	e.HireDate ,
	CASE
		WHEN DATEDIFF(year, e.HireDate, GETDATE()) < 2 THEN '<2 years'
		WHEN DATEDIFF(year, e.HireDate, GETDATE()) BETWEEN 2 AND 5 THEN '2-5 years'
		ELSE '>5 years'
	END Tenure
FROM Employees e ;
-- better
SELECT 
	e.EmpID ,
	e.FirstName ,
	e.HireDate ,
	CASE
	    WHEN DATEDIFF(MONTH, HireDate, GETDATE()) < 24 THEN '<2 years'
	    WHEN DATEDIFF(MONTH, HireDate, GETDATE()) <= 60 THEN '2-5 years'
	    ELSE '>5 years'
	END Tenure
FROM Employees e ;

-- Q05:
SELECT 
	e.EmpID ,
	ROUND(e.Salary / 1000 , 0) * 1000 AS salary_xk ,
	CAST(CAST(ROUND(e.Salary / 1000, 2) AS FLOAT) AS VARCHAR) + '%' AS percentage 
FROM Employees e ;

-- Q06:
SELECT 
	e.EmpID ,
	e.FirstName ,
	ISNULL(CAST(e.ManagerID AS VARCHAR) ,'Top Management')
FROM Employees e ;

-- Q07:
SELECT 
	e.City ,
	COUNT(e.EmpID ) AS employee_per_city
FROM Employees e 
GROUP BY e.City 
HAVING COUNT(e.EmpID ) > 2;

-- Q08:
SELECT 
	e.EmpID ,
	e.FirstName ,
	CAST(e.HireDate AS DATE) AS hireDate -- 'yyyy-MM-dd' is default format
FROM Employees e ;

-- Q09:
SELECT 
	e.EmpID ,
	e.FirstName ,
	e.Salary 
FROM Employees e 
WHERE e.Salary BETWEEN 60000 AND 90000 AND e.FirstName LIKE 'J%n';

-- Q10:
SELECT 
	e.EmpID ,
	e.FirstName ,
	e.Salary 
FROM Employees e 
WHERE e.Salary > (SELECT AVG(salary) AS avg_salary FROM Employees);

-- Q11:
SELECT 
	o.OrderID ,
	c.CustomerName ,
	e.FirstName AS emp_name
FROM Customers c 
INNER JOIN 
	Orders o ON c.CustomerID = o.CustomerID 
INNER JOIN 
	Employees e ON e.EmpID = o.EmpID ;

-- Q12:
SELECT 
	*
FROM Products p 
LEFT JOIN 
	OrderDetails od ON od.ProductID = p.ProductID 
WHERE od.ProductID IS NULL; -- left anti join

-- Q13:
SELECT 
	d.DepartmentID ,
	d.DepartmentName ,
	d.Budget ,
	SUM(ISNULL(e.Salary ,0)) AS total_salary_budget
FROM Departments d 
LEFT JOIN 
	Employees e ON e.DepartmentID = d.DepartmentID 
GROUP BY d.DepartmentID ,d.DepartmentName  ,d.Budget 
HAVING SUM(ISNULL(e.Salary ,0)) > 150000;

-- Q14:
SELECT 
	o.CustomerID ,
	o.OrderID ,
	od.Quantity ,
	CAST(od.Discount *100 AS VARCHAR) + '%' AS discount ,
	p.UnitPrice ,
	p.UnitPrice * (1- od.Discount ) AS after_discount ,
	od.Quantity * (p.UnitPrice * (1- od.Discount )) AS [total order value]
FROM Orders o 
LEFT JOIN 
	OrderDetails od ON o.OrderID = od.OrderID
LEFT JOIN 
	Products p on od.ProductID = p.ProductID;
SELECT 
	*
FROM Orders o 
LEFT JOIN 
	OrderDetails od ON o.OrderID = od.OrderID
LEFT JOIN 
	Products p on od.ProductID = p.ProductID;

-- Q15:
SELECT 
	o.CustomerID ,
	COUNT(*) AS total_orders
FROM Orders o 
GROUP BY o.CustomerID
HAVING COUNT(*)>1;

-- Q16:
SELECT 
	e.EmpID ,
	e.FirstName ,
	ISNULL(em.FirstName, 'N/A') AS manager_name
FROM Employees e 
LEFT JOIN (SELECT 
			e2.FirstName ,
			e2.EmpID
		FROM Employees e2 ) em
		ON e.ManagerID = em.EmpID;

-- Q17:
SELECT 
	*,
	ISNULL(
		CAST(DATEDIFF(day, o.OrderDate , o.ShippedDate ) AS VARCHAR), 
		'Pending') AS took_days_to_ship
FROM Orders o 
WHERE DATEDIFF(day, o.OrderDate , o.ShippedDate ) > 5 OR DATEDIFF(day, o.OrderDate , o.ShippedDate ) IS NULL;

-- Q18:
SELECT 
	*
FROM OrderDetails od;
SELECT 
	p.Category ,
	SUM(od.Quantity ) AS unit_sold ,
	SUM(od.Quantity * (p.UnitPrice * (1-od.Discount ))) AS total_revenue
FROM Products p 
LEFT JOIN 
	OrderDetails od ON p.ProductID = od.ProductID 
GROUP BY p.Category 
ORDER BY SUM(od.Quantity * (p.UnitPrice * (1-od.Discount ))) 
DESC;

-- Q19:
SELECT 
	e.EmpID ,
	e.DepartmentID ,
	e.Salary 
FROM Employees e, (
	SELECT 
		e.DepartmentID ,
		AVG(ISNULL(e.Salary, 0)) AS avg_salary
	FROM Employees e 
	GROUP BY e.DepartmentID 
) avs
WHERE e.DepartmentID = avs.DepartmentID AND e.Salary > avs.avg_salary ;

-- Q20:
SELECT 
	e.EmpID ,
	e.FirstName ,
	e.Salary ,
	sg.GradeLevel 
FROM Employees e 
LEFT JOIN SalaryGrades sg 
	ON e.Salary BETWEEN sg.MinSalary AND sg.MaxSalary ;

-- Q21:
SELECT 
	ecc.city,
	CASE 
		WHEN ecc.city IN (SELECT City FROM Employees) THEN 'Employee city' 
		ELSE 'Customer city'
	END
FROM Employees e ,(SELECT 
	e.City AS city
FROM Employees e 
UNION
SELECT 
	c.City 
FROM Customers c ) ecc
GROUP BY ecc.city ;
-- simple but contain duplicates
SELECT 
	e.City ,
	'Employee city'
FROM Employees e 
UNION
SELECT 
	c.City ,
	'Customer city'
FROM Customers c;

-- Q22:
SELECT 
	e.City AS city
FROM Employees e 
INTERSECT
SELECT 
	c.City 
FROM Customers c;

-- Q23:
SELECT 
	e.City AS city
FROM Employees e 
EXCEPT
SELECT 
	c.City 
FROM Customers c;

-- Q24:
-- wrong ans
SELECT 
	sg.GradeLevel ,
	ISNULL(e.DepartmentID, 'unknown') ,
	CASE
		WHEN e.DepartmentID IS NULL THEN 0
		ELSE COUNT(sg.GradeLevel )
	END AS [department wise salary category]
FROM Employees e 
FULL JOIN SalaryGrades sg 
	ON e.Salary BETWEEN sg.MinSalary AND sg.MaxSalary 
GROUP BY e.DepartmentID ,sg.GradeLevel;
-- right ans:
SELECT 
    e.DepartmentID,
    CASE 
        WHEN e.Salary > 90000 THEN 'High'
        WHEN e.Salary BETWEEN 70000 AND 90000 THEN 'Medium'
        ELSE 'Low'
    END AS SalaryCategory,
    COUNT(*) AS EmployeeCount
FROM Employees e
GROUP BY e.DepartmentID, 
    CASE 
        WHEN e.Salary > 90000 THEN 'High'
        WHEN e.Salary BETWEEN 70000 AND 90000 THEN 'Medium'
        ELSE 'Low'
    END;

-- Q25:
SELECT 
	e.EmpID ,
	e.FirstName ,
	o.OrderID ,
	ISNULL(od.Quantity * (p.UnitPrice * (1-od.Discount )), 0) AS order_value ,
	CASE 
		WHEN od.Quantity * (p.UnitPrice * (1-od.Discount )) > 1000 THEN 'High Value'
		WHEN od.Quantity * (p.UnitPrice * (1-od.Discount )) BETWEEN 500 AND 1000 THEN 'Medium'
		WHEN od.Quantity IS NULL THEN 'N/A'
		ELSE 'Low'
	END AS [employee performance]
FROM Employees e  
LEFT JOIN 
	Orders o ON o.EmpID = e.EmpID 
LEFT JOIN 
	OrderDetails od ON od.OrderID = o.OrderID 
LEFT JOIN 
	Products p ON od.ProductID = p.ProductID;

-- Q26:
SELECT 
	c.CustomerID ,
	c.CustomerName ,
	COUNT(DISTINCT p.Category) Category_count
FROM Customers c 
LEFT JOIN 
	Orders o ON o.CustomerID = c.CustomerID 
LEFT JOIN 
	OrderDetails od ON od.OrderID = o.OrderID 
LEFT JOIN 
	Products p ON p.ProductID = od.ProductID 
GROUP BY c.CustomerID , c.CustomerName 
HAVING COUNT(p.Category  ) = (SELECT COUNT(DISTINCT Category) FROM Products );

-- Q27:
SELECT 
	DATENAME(month, o.OrderDate ) AS month ,
	COUNT(od.Quantity ) AS total_orders ,
	SUM(ISNULL(od.Quantity * (p.UnitPrice * (1-od.Discount )), 0)) AS total_revenue
FROM Orders o 
LEFT JOIN 
	OrderDetails od ON o.OrderID = od.OrderID
LEFT JOIN 
	Products p ON p.ProductID = od.ProductID 
WHERE YEAR(o.OrderDate ) = 2024
GROUP BY DATENAME(month, o.OrderDate );

-- Q28:
SELECT 
	e.EmpID ,
	e.FirstName ,
	mn.manages_people,
	e.Salary 
FROM Employees e , 
	(
	SELECT 
		e.EmpID ,
		e.FirstName ,
		COUNT(em.FirstName ) AS manages_people
	FROM Employees e 
	LEFT JOIN (SELECT 
				e2.FirstName ,
				e2.ManagerID
			FROM Employees e2 ) em
			ON e.EmpID  = em.ManagerID
	GROUP BY e.EmpID , e.FirstName 
	HAVING COUNT(em.FirstName ) >= 1
	) mn , 
	(
	SELECT 
		AVG(e.Salary ) AS avs
	FROM Employees e 
	) avgs
WHERE mn.EmpID = e.EmpID AND e.Salary > avgs.avs ;

-- Q29:
SELECT 
	e.EmpID ,
	e.HireDate ,
	e.Salary ,
	(
		SELECT 
			SUM(e2.Salary )
		FROM Employees e2 
		WHERE e2.HireDate  <= e.HireDate 
	) AS running_total
FROM Employees e 
ORDER BY e.HireDate ;

-- Q30:
SELECT 
	o.OrderID , 
	c.CustomerName ,
	e.FirstName ,
	SUM(ISNULL(od.Quantity * (p.UnitPrice * (1-od.Discount )), 0)) AS total_order_value ,
	CASE 
		WHEN SUM(ISNULL(od.Quantity * (p.UnitPrice * (1-od.Discount )), 0)) > 2000 OR c.CreditLimit > 70000 THEN 'High' -- there is not credit limit in customers
		WHEN SUM(ISNULL(od.Quantity * (p.UnitPrice * (1-od.Discount )), 0)) < 500 THEN 'Low'
		ELSE 'Medium'
	END
FROM Orders o 
LEFT JOIN 
	OrderDetails od ON o.OrderID = od.OrderID 
LEFT JOIN 
	Products p ON od.ProductID = p.ProductID 
LEFT JOIN 
	Customers c ON o.CustomerID = c.CustomerID
LEFT JOIN
	Employees e ON o.EmpID = e.EmpID
GROUP BY o.OrderID , 
	c.CustomerName ,
	c.CustomerID ,
	e.EmpID ,
	e.FirstName ;




SELECT * FROM OrderDetails;
SELECT * FROM Orders;
SELECT * FROM Products;
SELECT * FROM Employees;
SELECT * FROM Departments;
SELECT * FROM Customers;
SELECT * FROM SalaryGrades;
