USE SalesDB;
--------------------------      INDEXES       --------------------------

--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
---------------------------  structure (clustered index and non-cluster index)  --------------
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- syntext:
-- CREATE [CLUSTERED | NONCLUSTERED] INDEX index_name ON table_name (column1, column2, .............)


SELECT *
FROM Sales.DBCustomers dbc 
WHERE dbc.CustomerID = 1; -- heap cluster

-- CLUSTERED
CREATE CLUSTERED INDEX idx_DBCustomers_CustomerID
ON Sales.DBCustomers (CustomerID);

SELECT *
FROM Sales.DBCustomers dbc 
WHERE dbc.CustomerID = 1;


-- NONCLUSTERED
CREATE NONCLUSTERED INDEX idx_DBCustomers_LastName
ON Sales.DBCustomers (LastName);

SELECT *
FROM Sales.DBCustomers dbc 
WHERE dbc.LastName = 'Brown';

CREATE INDEX idx_DBCustomers_FirstName
ON Sales.DBCustomers (FirstName);

SELECT *
FROM Sales.DBCustomers dbc 
WHERE dbc.FirstName = 'Anna';

-- drop them
DROP INDEX idx_DBCustomers_CustomerID ON Sales.DBCustomers;
DROP INDEX idx_DBCustomers_FirstName ON Sales.DBCustomers;
DROP INDEX idx_DBCustomers_LastName ON Sales.DBCustomers;


---------------------- composite index -------------
SELECT *
FROM Sales.DBCustomers 
WHERE Country = 'USA' AND Score > 500; -- same order of collumn check as index

SELECT *
FROM Sales.DBCustomers 
WHERE Country = 'USA'; -- it will also work as LEFTMOST PREFIX RULE

CREATE INDEX idx_DBCustomers_CountryScore
ON Sales.DBCustomers (Country, Score); -- same order of column as select where statement



--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
---------------------------  storage (Rowstore index Columnstore index)  ------------------------------
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

-- columnstore index:
-- syntex: 
-- CREATE [CLUSTERED | NONCLUSTERED] [COLUMNSTORE] INDEX idnex_name ON table_name (column1, column2, ..........)
-- note : default is rowstore, and for clustered columnstore index there is no column name specification is allowed 

CREATE CLUSTERED COLUMNSTORE INDEX idx_DBCustomers_CS
ON Sales.DBCustomers;


CREATE NONCLUSTERED COLUMNSTORE INDEX idx_DBCustomers_CS_FirstName
ON Sales.DBCustomers (FirstName);


DROP INDEX idx_DBCustomers_CS ON Sales.DBCustomers;
DROP INDEX idx_DBCustomers_CS_FirstName ON Sales.DBCustomers;




--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
---------------------------  functions (unique index and filtered index)  ------------------------------
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

-- unique index syntex:
-- CREATE [UNIQUE] [CLUSTERED | NONCLUSTERED] [COLUMNSTORE] INDEX idex_name 
-- ON table_name (column1, column2, .....)
-- note: in unique index no duplicates is allowed

SELECT * FROM Sales.Products p ;

CREATE UNIQUE NONCLUSTERED INDEX idx_products_product
ON Sales.Products (product );


-- filtered index syntex:
-- CREATE [UNIQUE] [CLUSTERED | NONCLUSTERED] [COLUMNSTORE] INDEX idex_name 
-- ON table_name (column1, column2, .....)
-- WHERE [condition]

SELECT * FROM Sales.Customers c 
WHERE c.Country = 'USA';

CREATE NONCLUSTERED INDEX idx_customers_country
ON Sales.Customers (Country)
WHERE Country = 'USA';
