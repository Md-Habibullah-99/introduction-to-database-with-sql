CREATE DATABASE MidCoursePractice;
go

USE MidCoursePractice;

-- 1. Create Tables
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(50),
    country VARCHAR(50),
    join_date DATE
);

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(50),
    category VARCHAR(50),
    price DECIMAL(10, 2)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    total_amount DECIMAL(10, 2),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE order_details (
    detail_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    line_total DECIMAL(10, 2),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- 2. Insert Mock Data
INSERT INTO customers VALUES 
(1, 'Maria Anders', 'Germany', '2025-01-15'),
(2, 'John Doe', 'USA', '2025-02-10'),
(3, 'Martin King', 'UK', '2025-03-05'),
(4, 'Alex Smith', 'USA', '2025-03-12'),
(5, 'Sven Ottlieb', 'Germany', '2025-04-01'),
(6, 'Hiro Tanaka', 'Japan', '2025-04-20'); -- Edge Case: No orders placed yet

INSERT INTO products VALUES 
(101, 'Wireless Mouse', 'Electronics', 25.00),
(102, 'Mechanical Keyboard', 'Electronics', 80.00),
(103, 'Ergonomic Chair', 'Furniture', 250.00),
(104, 'Desk Lamp', 'Furniture', 45.00),
(105, 'Coffee Mug', 'Kitchen', 15.00),
(106, '4K Gaming Monitor', 'Electronics', 450.00); -- Edge Case: Never ordered

INSERT INTO orders VALUES 
(5001, 1, '2026-01-10', 105.00),
(5002, 2, '2026-01-12', 500.00),
(5003, 3, '2026-01-15', 45.00),
(5004, 4, '2026-02-01', 190.00),
(5005, 1, '2026-02-20', 250.00),
(5006, 2, '2026-03-02', 80.00);

INSERT INTO order_details VALUES 
(1, 5001, 101, 1, 25.00),
(2, 5001, 102, 1, 80.00),
(3, 5002, 103, 2, 500.00),
(4, 5003, 104, 1, 45.00),
(5, 5004, 101, 2, 50.00),
(6, 5004, 105, 2, 30.00),
(7, 5004, 102, 1, 80.00),
(8, 5005, 103, 1, 250.00),
(9, 5006, 102, 1, 80.00);
