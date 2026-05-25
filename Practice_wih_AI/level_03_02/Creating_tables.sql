
USE master;

DROP TABLE IF EXISTS employees ;
DROP TABLE IF EXISTS departments ;
DROP TABLE IF EXISTS orders ;

CREATE TABLE employees (
	employee_id INT PRIMARY KEY ,
	name VARCHAR(50),
	department_id INT,
	salary INT,
	hire_date DATE,
	);

INSERT INTO employees 
VALUES
	(1,'Alice' ,10 ,50000,'2020-01-15'),
	(2,'Bob' ,20 ,60000,'2019-03-10'),
	(3,'Charlie' ,10 ,55000,'2021-06-20'),
	(4,'Diana' ,30 ,70000,'2018-11-02'),
	(5,'Eve' ,NULL ,45000,'2022-08-30');

CREATE TABLE departments (
	department_id INT PRIMARY KEY, 
	department_name VARCHAR(30)
	);

INSERT INTO departments 
VALUES
	(10,'Sales'),
	(20,'IT'),
	(30,'HR'),
	(40,'Marketing');

CREATE TABLE orders (
	order_id INT PRIMARY KEY,
	customer_name VARCHAR(50),
	amount INT,
	order_date DATE
);

INSERT INTO orders
VALUES
	(101,'John',250,'2025-01-01'),
	(102,'John',300,'2025-01-02'),
	(103,'Sarah',100,'2025-01-01');
