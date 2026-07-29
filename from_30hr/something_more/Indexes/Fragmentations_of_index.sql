

--====================================================================
------------------------ monitoring fragmentation -------------------
--====================================================================

-- checking the health of our indexes
SELECT 
	tbl.name AS TableName ,
	i.name AS IndexName ,
	s.avg_fragmentation_in_percent ,
	s.page_count
FROM sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, 'LIMITED') AS s
INNER JOIN sys.tables tbl
	ON s.object_id = tbl.object_id 
INNER JOIN sys.indexes i 
	ON i.object_id = s.object_id 
	AND i.index_id = s.index_id
ORDER BY s.avg_fragmentation_in_percent DESC;


-- reorganizing a index
ALTER INDEX idx_customers_country ON Sales.Customers REORGANIZE;

-- rebuild
ALTER INDEX idx_customers_country ON Sales.Customers REBUILD;

