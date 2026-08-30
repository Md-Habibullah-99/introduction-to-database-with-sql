USE SalesDB;


-- partition function
CREATE PARTITION FUNCTION PartitionByYear (DATE)
AS RANGE LEFT FOR VALUES ('2023-12-31', '2024-12-31', '2025-12-31');


-- Query lists all existing Partition Function
SELECT 
  pf.name, 
  pf.function_id ,
  pf.[type] ,
  pf.type_desc ,
  pf.boundary_value_on_right 
FROM sys.partition_functions pf ;


-- creating file groups
ALTER DATABASE SalesDB ADD FILEGROUP FG_2023;
ALTER DATABASE SalesDB ADD FILEGROUP FG_2024;
ALTER DATABASE SalesDB ADD FILEGROUP FG_2025;
ALTER DATABASE SalesDB ADD FILEGROUP FG_2026;

-- remove file group 
ALTER DATABASE SalesDB REMOVE FILEGROUP FG_2026;



-- Query lists all existing Filegroups
SELECT *
FROM sys.filegroups f 
WHERE f.[type] = 'FG';


-- Add .ndf files to each filegroup
ALTER DATABASE SalesDB ADD FILE
(
  NAME = P_2023, -- logical name
  FILENAME = '/var/opt/mssql/P_2023.ndf'
) TO FILEGROUP FG_2023;

ALTER DATABASE SalesDB ADD FILE
(
  NAME = P_2024, -- logical name
  FILENAME = '/var/opt/mssql/P_2024.ndf'
) TO FILEGROUP FG_2024;

ALTER DATABASE SalesDB ADD FILE
(
  NAME = P_2025, -- logical name
  FILENAME = '/var/opt/mssql/P_2025.ndf'
) TO FILEGROUP FG_2025;

ALTER DATABASE SalesDB ADD FILE
(
  NAME = P_2026, -- logical name
  FILENAME = '/var/opt/mssql/P_2026.ndf'
) TO FILEGROUP FG_2026;


-- file group name and their physicalFilePath
SELECT 
  fg.name AS FileGroupName ,
  mf.name AS LogicalFileName ,
  mf.physical_name AS PhysicalFilePath ,
  mf.size / 128 AS SizeInMB
FROM sys.filegroups fg
JOIN sys.master_files mf ON fg.data_space_id = mf.data_space_id 
WHERE mf.database_id = DB_ID('SalesDB');


-- create partition scheme
CREATE PARTITION SCHEME SchemePartitionByYear
AS PARTITION PartitionByYear
TO (FG_2023, FG_2024, FG_2025, FG_2026);


-- Query lists all partition scheme
SELECT 
  ps.name AS PartitionSchemeName ,
  pf.name AS PartitionFunctionName ,
  ds.destination_id AS PartitionNumber ,
  fg.name AS FileGroupName
FROM sys.partition_schemes ps 
JOIN sys.partition_functions pf ON ps.function_id = pf.function_id 
JOIN sys.destination_data_spaces ds ON ps.data_space_id = ds.partition_scheme_id 
JOIN sys.filegroups fg ON ds.data_space_id = fg.data_space_id; 



-- Create partitioned table
CREATE TABLE Sales.Orders_Partitioned
(
  OrderID INT,
  OrderDate DATE,
  Sales INT
) ON SchemePartitionByYear (OrderDate);

-- Insert data into partitioned table
INSERT INTO Sales.Orders_Partitioned 
VALUES 
  (3, '2026-05-15', 180),
  (1, '2023-05-15', 100);

SELECT * FROM Sales.Orders_Partitioned ;


SELECT 
  p.partition_number AS PartitionNumber ,
  f.name AS PartitionFileGroup ,
  p.[rows] AS NumberOfRows
FROM sys.partitions p 
JOIN sys.destination_data_spaces dds ON p.partition_number = dds.destination_id 
JOIN sys.filegroups f ON dds.data_space_id = f.data_space_id 
WHERE OBJECT_NAME(p.object_id ) = 'Orders_Partitioned';






