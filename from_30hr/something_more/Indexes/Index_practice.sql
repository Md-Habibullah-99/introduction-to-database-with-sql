USE AdventureWorksDW ;

-- Heap cluster (default)
SELECT 
	*
	INTO FactInternetSales_HP
FROM FactInternetSales fis;


-- row store clustered index
SELECT 
	*
	INTO FactInternetSales_RS
FROM FactInternetSales fis;


CREATE CLUSTERED INDEX idx_FactInternetSales_RS_PK
ON FactInternetSales_RS (SalesOrderNumber, SalesOrderLineNumber);


-- column store clustered index
SELECT 
	*
	INTO FactInternetSales_CS
FROM FactInternetSales fis;


CREATE CLUSTERED COLUMNSTORE INDEX idx_FactInternetSales_CS_PK
ON FactInternetSales_CS ;
