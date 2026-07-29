USE SalesDB;


-- update statistics
-- the statistics:
SELECT 
	SCHEMA_NAME(t.schema_id ) AS SchemaName ,
	t.name AS TableName ,
	s.name AS StatisticName ,
	sp.last_updated AS LastUpdate ,
	DATEDIFF(day, sp.last_updated, GETDATE()) AS LastUpdateDay ,
	sp.rows AS 'ROWS' ,
	sp.modification_counter AS ModificationsSinceLastUpdate
FROM sys.stats s 
JOIN sys.tables t
	ON s.object_id = t.object_id 
CROSS APPLY sys.dm_db_stats_properties(s.object_id, s.stats_id) AS sp
ORDER BY 
sp.modification_counter DESC;

-- update operation
UPDATE STATISTICS Sales.DBCustomers _WA_Sys_00000001_05D8E0BE; -- update specific statistic
UPDATE STATISTICS Sales.DBCustomers; -- update all statistics of the table

EXEC sp_updatestats; -- update statistics of whole database 
