-- Create the database
CREATE DATABASE MidCoursePractice;
GO

USE MidCoursePractice;
GO

-- Create tables
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100),
    city VARCHAR(50),
    join_date DATE
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    total_amount DECIMAL(10,2),
    status VARCHAR(20), -- 'pending', 'shipped', 'delivered', 'cancelled'
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY,
    order_id INT,
    product_name VARCHAR(100),
    quantity INT,
    unit_price DECIMAL(10,2),
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

CREATE TABLE shipments (
    shipment_id INT PRIMARY KEY,
    order_id INT,
    carrier VARCHAR(50),
    shipment_date DATE,
    delivery_date DATE,
    shipping_cost DECIMAL(10,2),
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);
