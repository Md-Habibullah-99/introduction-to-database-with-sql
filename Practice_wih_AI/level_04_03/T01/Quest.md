

---

## 🎯 ALL CHALLENGES COMPLETE

### Schema Setup (00_schema_setup.sql)
```sql
-- QuickCart E-Commerce Database Schema
-- Created: 2024
-- Purpose: Practice subqueries and CTEs

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
    status VARCHAR(20),
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

-- Mock Data
INSERT INTO customers VALUES
(1, 'Emma', 'Thompson', 'emma.t@email.com', 'New York', '2023-01-15'),
(2, 'James', 'Rodriguez', 'james.r@email.com', 'Los Angeles', '2023-02-20'),
(3, 'Sophia', 'Chen', 'sophia.c@email.com', 'Chicago', '2023-03-10'),
(4, 'Michael', 'Brown', 'michael.b@email.com', 'New York', '2023-04-05'),
(5, 'Olivia', 'Williams', 'olivia.w@email.com', 'Los Angeles', '2023-05-12'),
(6, 'Daniel', 'Kim', 'daniel.k@email.com', 'Chicago', '2023-06-18');

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

INSERT INTO shipments VALUES
(201, 101, 'FedEx', '2024-01-11', '2024-01-13', 12.50),
(202, 103, 'UPS', '2024-01-16', '2024-01-18', 15.75),
(203, 104, 'USPS', '2024-01-19', '2024-01-22', 8.25),
(204, 106, 'FedEx', '2024-01-23', '2024-01-25', 11.00),
(205, 108, 'UPS', '2024-01-29', '2024-01-31', 18.50),
(206, 110, 'USPS', '2024-02-04', '2024-02-06', 9.50);
```

---

## 📝 CHALLENGE 1: Basic Subquery


### Business Context
The operations manager needs to identify high-value delivered orders.

### Task
Find **delivered** orders with `total_amount` greater than the **overall average** order amount.

### Requirements
- Return: `order_id`, `order_date`, `total_amount`, `status`
- Use a **subquery in the WHERE clause**
- Only include orders with status = 'delivered'
- Filter using subquery: `total_amount > overall average`
- Order by: `total_amount DESC`

### Key Learning
- Scalar subquery executes once and returns a single value
- Efficient because it's not correlated with the outer query

---

## 📝 CHALLENGE 2: Basic CTE


### Business Context
The VP of Operations wants to identify above-average spending customers.

### Task
Find customers who are above-average spenders with at least 2 orders.

### Requirements
- Calculate per customer: `total_spent`, `avg_order_value`, `order_count`
- Use **at least one CTE** for customer aggregation
- Filter: customers with >= 2 orders AND total_spent > overall average
- Return: `customer_id`, `first_name`, `last_name`, `total_spent`, `avg_order_value`, `order_count`
- Order by: `total_spent DESC`


### Key Learning
- CTEs break complex queries into logical, readable steps
- CROSS JOIN is safe when the CTE returns exactly one row

---

## 📝 CHALLENGE 3: Correlated Subquery


### Business Context
The logistics team wants to find fast-shipping orders per carrier.

### Task
Find **delivered** orders where shipping duration is **less than the carrier's average**.

### Requirements
- Calculate shipping duration: `DATEDIFF(day, shipment_date, delivery_date)`
- Use a **correlated subquery** in the WHERE clause
- Subquery references outer query's carrier
- Return: `order_id`, `carrier`, `shipment_date`, `delivery_date`, `shipping_duration`
- Order by: `carrier`, then `shipping_duration ASC`


### Key Learning
- Correlated subquery runs once per row in the outer query
- Can be slow on large datasets (N+1 problem)
- Window functions (AVG() OVER) are often more efficient alternatives

---

## 📝 CHALLENGE 4: Chained CTEs


### Business Context
The marketing team wants a customer segmentation report.

### Task
Create a customer segmentation with spending tiers and revenue percentages.

### Requirements
- Use **at least 3 CTEs** chained together
- Calculate: total_spent, spending_rank, spending_tier, revenue_percentage
- Spending tiers: 'High' (top 20%), 'Medium' (middle 60%), 'Low' (bottom 20%)
- Return: `customer_id`, `first_name`, `last_name`, `total_spent`, `spending_rank`, `spending_tier`, `revenue_percentage`
- Order by: `spending_rank`



### Key Learning
- NTILE(n) creates equal-sized buckets
- Window functions can calculate percentages without extra CTEs
- Combining CTEs with window functions is powerful and efficient

---

## 📝 CHALLENGE 5: CTE vs Subquery


### Business Context
The finance team needs a one-time report on January 2024 orders.

### Task
Find customers who ordered in January 2024 with their order history.

### Two Approaches Required
**Approach A**: CTE with aggregation
**Approach B**: Subquery with aggregation

### Requirements
- Return: `customer_id`, `first_name`, `last_name`, `first_order_date`, `most_recent_order_date`, `total_number_of_orders`, `avg_order_amount`
- Filter: Only customers who placed orders in January 2024
- Order by: `customer_id`



### Performance Analysis
| Aspect | CTE Approach | Subquery Approach |
|--------|--------------|-------------------|
| **Readability** | ✅ Excellent - modular steps | ⚠️ Good - nested logic |
| **Performance** | ✅ Same execution plan | ✅ Same execution plan |
| **Reusability** | ✅ CTEs can be referenced | ❌ Must repeat code |
| **Maintainability** | ✅ Easy to modify | ⚠️ Harder to modify |
| **Best Use Case** | Complex multi-step logic | Simple one-time queries |

### Key Learning
- Modern query optimizers generate similar execution plans
- CTEs win on **readability and maintainability**
- Subqueries are fine for simple, one-off queries
- **Decision criteria**: Choose CTE when logic is complex or needs reuse

---

