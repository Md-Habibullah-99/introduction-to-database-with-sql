USE MidCoursePractice;

-- Insert customers
INSERT INTO customers VALUES
(1, 'Emma', 'Thompson', 'emma.t@email.com', 'New York', '2023-01-15'),
(2, 'James', 'Rodriguez', 'james.r@email.com', 'Los Angeles', '2023-02-20'),
(3, 'Sophia', 'Chen', 'sophia.c@email.com', 'Chicago', '2023-03-10'),
(4, 'Michael', 'Brown', 'michael.b@email.com', 'New York', '2023-04-05'),
(5, 'Olivia', 'Williams', 'olivia.w@email.com', 'Los Angeles', '2023-05-12'),
(6, 'Daniel', 'Kim', 'daniel.k@email.com', 'Chicago', '2023-06-18');

-- Insert orders
INSERT INTO orders VALUES
(101, 1, '2024-01-10', 150.00, 'delivered'),
(102, 2, '2024-01-12', 89.99, 'shipped'),
(103, 1, '2024-01-15', 245.50, 'delivered'),
(104, 3, '2024-01-18', 67.25, 'delivered'),
(105, 4, '2024-01-20', 310.00, 'pending'),
(106, 2, '2024-01-22', 120.75, 'delivered'),
(107, 5, '2024-01-25', 99.99, 'cancelled'),
(108, 1, '2024-01-28', 430.00, 'delivered'),
(109, 6, '2024-02-01', 75.50, 'shipped'),
(110, 3, '2024-02-03', 210.00, 'delivered');

-- Insert order_items
INSERT INTO order_items VALUES
(1, 101, 'Wireless Mouse', 2, 25.00),
(2, 101, 'USB-C Cable', 3, 33.33),
(3, 102, 'Notebook Set', 5, 17.99),
(4, 103, 'Desk Lamp', 1, 45.50),
(5, 103, 'Bluetooth Speaker', 2, 100.00),
(6, 104, 'Pencil Case', 3, 22.42),
(7, 105, 'External Hard Drive', 1, 310.00),
(8, 106, 'Phone Stand', 4, 30.19),
(9, 107, 'Yoga Mat', 1, 99.99),
(10, 108, 'Monitor', 1, 430.00),
(11, 109, 'Coffee Mug', 5, 15.10),
(12, 110, 'Desk Organizer', 2, 105.00);

-- Insert shipments
INSERT INTO shipments VALUES
(201, 101, 'FedEx', '2024-01-11', '2024-01-13', 12.50),
(202, 103, 'UPS', '2024-01-16', '2024-01-18', 15.75),
(203, 104, 'USPS', '2024-01-19', '2024-01-22', 8.25),
(204, 106, 'FedEx', '2024-01-23', '2024-01-25', 11.00),
(205, 108, 'UPS', '2024-01-29', '2024-01-31', 18.50),
(206, 110, 'USPS', '2024-02-04', '2024-02-06', 9.50);
