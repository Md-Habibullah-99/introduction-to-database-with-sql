🏆 PRACTICE CHALLENGES
### Task 1 (Aggregations)
📝 **Goal**: Find all countries where the total revenue generated from orders exceeds $300.

💡 **Hint**: Requires JOIN, GROUP BY, and HAVING.
```sql
SELECT c.country, SUM(od.qty * p.price) AS total_revenueFROM customers cJOIN orders o ON c.customer_id = o.customer_idJOIN order_details od ON o.order_id = od.order_idJOIN products p ON od.product_id = p.product_idGROUP BY c.countryHAVING SUM(od.qty * p.price) > 300;
```


### Task 2 (Outer Joins)

📝 **Goal**: List the names and countries of all customers who have never placed a single order.

💡 **Hint**: Look closely at customer_id 6 (Fiona Gallagher).
```sql
SELECT c.name, c.countryFROM customers cLEFT JOIN orders o ON c.customer_id = o.customer_idWHERE o.order_id IS NULL;
```


### Task 3 (Subqueries)

📝 **Goal**: Identify all products whose price is strictly higher than the average price of all items in the store.

💡 **Hint**: Requires a subquery evaluating the overall average price.
```sql
SELECT name, priceFROM productsWHERE price > (SELECT AVG(price) FROM products);
```


### Task 4 (CTEs)📝 
**Goal**: Write a query utilizing a Common Table Expression to determine the total amount spent by each customer, then pull the top 2 highest spenders.

💡 **Hint**: Use WITH spent_cte AS (...)
```sql
WITH spent_cte AS (  SELECT c.name, SUM(od.qty * p.price) AS total_spent  FROM customers c  JOIN orders o ON c.customer_id = o.customer_id  JOIN order_details od ON o.order_id = od.order_id  JOIN products p ON od.product_id = p.product_id  GROUP BY c.name)SELECT name, total_spentFROM spent_cteORDER BY total_spent DESCLIMIT 2;
```


### Task 5 (Window Functions)
📝 **Goal**: Rank products within each individual category by their price in descending order using a ranking window function.

💡 **Hint**: Use DENSE_RANK() OVER (PARTITION BY category ORDER BY price DESC).
```sql
SELECT product_id, name, category, price,       DENSE_RANK() OVER(PARTITION BY category ORDER BY price DESC) as rnkFROM products;```
