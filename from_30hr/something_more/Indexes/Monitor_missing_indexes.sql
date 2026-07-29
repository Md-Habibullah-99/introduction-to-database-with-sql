USE SalesDB;

-- List all indexes on a specific table
sp_helpindex 'Sales.DBCustomers';


-- Monitoring Index Usage
SELECT * FROM sys.indexes i ;
SELECT 
	t.name AS TableName,
	i.name AS IndexName,
	i.type_desc AS IndexType,
	i.is_primary_key ,
	i.is_unique ,
	i.is_disabled ,
	ddius.user_seeks ,
	ddius.user_scans ,
	ddius.user_lookups ,
	ddius.user_updates ,
	NULLIF (ddius.last_user_seek ,ddius.last_user_scan ) AS LastUpdate 
FROM sys.indexes i 
JOIN sys.tables t 
	ON i.object_id  = t.object_id
LEFT JOIN sys.dm_db_index_usage_stats ddius 
	ON ddius.object_id = i.object_id 
	AND ddius.index_id = i.index_id 
ORDER BY t.name, i.name;

SELECT * FROM sys.dm_db_index_usage_stats ddius ;


SELECT * FROM Sales.Products p 
WHERE p.Product = 'Caps'; -- then check the index usege to find for this query any index was used or not



-- get suggestion from the db:
USE AdventureWorksDW;

SELECT 
	fs.SalesOrderNumber ,
	dp.EnglishProductName ,
	dp.color
FROM FactInternetSales fs
INNER JOIN DimProduct dp
	ON fs.ProductKey = dp.ProductKey
WHERE dp.Color = 'Black'
AND fs.OrderDateKey BETWEEN 20101229 AND 20101231;

SELECT * FROM sys.dm_db_missing_index_details ddmid ;




-- monitor duplicate indexes
SELECT 
	tbl.name AS TableName ,
	col.name AS IndexColumn ,
	idx.name AS IndexName ,
	idx.type_desc AS IndexType ,
	COUNT(*) OVER (PARTITION BY tbl.name, col.name) ColumnCount
FROM sys.indexes idx
JOIN sys.tables tbl ON idx.object_id  = tbl.object_id
JOIN sys.index_columns ic ON idx.object_id  = ic.object_id  AND idx.index_id = ic.index_id 
JOIN sys.columns col ON ic.object_id = col.object_id AND ic.column_id = col.column_id 
ORDER BY ColumnCount DESC;