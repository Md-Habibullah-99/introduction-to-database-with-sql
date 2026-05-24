USE SalesDB;

SELECT name FROM sys.tables;   


/* Task: Using SalesDB, Retrive a list of all orders, along with 
the related customer, product, and employee details. for each order,
display:
Order ID, Customer's name, Product name, Sales, Price, Sales person's name 
*/

SELECT 
	o.orderID ,
	c.firstName AS "customer's name",
	p.product AS "product name",
	o.sales ,
	p.price ,
	e.firstName AS "sales person's name"
FROM Sales.orders o 
LEFT JOIN Sales.customers c 
	ON c.customerID = o.customerID
LEFT JOIN Sales.employees e 
	ON e.employeeID = o.SalesPersonID
LEFT JOIN Sales.products p
	ON p.ProductID = o.ProductID;

SELECT * FROM Sales.customers c ;
SELECT * FROM Sales.employees e ;
SELECT * FROM Sales.products p;
SELECT * FROM Sales.orders o;
SELECT * FROM Sales.ordersArchive oa;
