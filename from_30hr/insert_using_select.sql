
INSERT INTO persons (id,name,birth_date,phone)
SELECT 
id,
first_name,
NULL,
'Unknown'
FROM customers c;

-- or 

INSERT INTO persons
SELECT 
id,
first_name,
NULL,
'Unknown'
FROM customers c;


SELECT * FROM persons p ;

