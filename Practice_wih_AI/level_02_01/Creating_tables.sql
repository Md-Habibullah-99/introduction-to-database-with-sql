
CREATE TABLE employees (
	employee_id INT PRIMARY KEY, 
	name VARCHAR(50),
	department VARCHAR(50),
	salary INT,
	hire_date DATE,
	city VARCHAR(50)
	);

INSERT INTO employees 
VALUES 
	(1,'Alice','Sales',55000,'2021-03-15','Boston'),
	(2,'Bob','IT',72000,'2020-06-20','Chicago'),
	(3,'Charlie','Sales',48000,'2022-01-10','Boston'),
	(4,'Diana','HR',61000,'2019-11-02','Chicago');


CREATE TABLE products (
	product_id INT PRIMARY KEY, 
	product_name VARCHAR(50), 
	category VARCHAR(30), 
	price FLOAT, 
	stock_quantity INT
	);

INSERT INTO products 
VALUES 
	(101,'Laptop','Elec',800,15),
	(102,'Mouse','Elec',25,100),
	(103,'Desk','Furn',450,8);




