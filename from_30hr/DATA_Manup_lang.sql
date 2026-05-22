
DROP TABLE persons ;

CREATE TABLE persons
	(
	id INT NOT NULL,
	name VARCHAR(50) NOT NULL,
	occupation VARCHAR(30) NOT NULL,
	salary INT,
	CONSTRAINT pk_primary PRIMARY KEY (id)
	);


INSERT INTO persons (id,name,occupation,salary) --(col1, col2, col3, ...) this is optional
VALUES 
	(1,'Liam','Teacher',25000),
	(2,'Olivia','Student',0),
	(3,'Noah','lambarjack',15000),
	(4,'Charlotte','Student',10000),
	(5,'Oliver','Web dev',30000),
	(6,'Emma','Software Eng',40000),
	(7,'Theodore','Data Eng',50000),
	(8,'Amelia','Web dev',29770),
	(9,'Henry','Software Eng',30770),
	(10,'Sophia','Teacher',21000),
	(11,'James','Web dev',55090),
	(12,'Isabella','Web dev',35500),
	(13,'Elijah','Teacher',12000),
	(14,'Evelyn','Software dev',38700),
	(15,'Mateo','Software dev',59900),
	(16,'Sofia','Student',5000),
	(17,'William','Web dev',100000),
	(18,'Lucas','Web dev',10000),
	(19,'Eliana','Full stack dev',30500),
	(20,'Isa','Full stack dev',30500),
	(21,'Mohammad','Data Eng',200000)
	

INSERT INTO persons
VALUES 
	(22,'Mary','Teacher',25000),
	(23,'Maria','Student',0),
	(24,'Michael','lambarjack',15000),
	(25,'John','Student',10000),
	(26,'James','Web dev',30000),
	(27,'David','Software Eng',40000),
	(28,'Robert','Data Eng',50000),
	(29,'Christopher','Web dev',29770),
	(30,'Matthew','Software Eng',30770),
	(31,'Joshua','Teacher',21000),
	(32,'Daniel','Web dev',55090),
	(33,'David','Web dev',35500),
	(34,'James','Teacher',12000),
	(35,'Andrew','Software dev',38700),
	(36,'Joseph','Software dev',59900),
	(37,'Mark','Student',5000),
	(38,'Kimberly','Web dev',100000),
	(39,'Donna','Web dev',10000),
	(40,'Kevin','Full stack dev',30500),
	(41,'Ishak','Full stack dev',30500),
	(42,'Usuf','Data Eng',200000)


SELECT * FROM persons p ;

SELECT 
	p.occupation,
	MAX(p.salary ) AS max_salary
FROM persons p 
GROUP BY p.occupation 
ORDER BY  max_salary
DESC;

DELETE FROM persons ;
--or
TRUNCATE TABLE persons;

SELECT * FROM persons;


--with coustomers table

UPDATE customers
SET score=0
WHERE id=6;

INSERT INTO customers (id,first_name,country,score)
VALUES 
	(8,'Yo',NULL,500),
	(9,'Bro','China',NULL)

INSERT INTO customers
VALUES 
	(10,'Sara',NULL,NULL)
	
UPDATE customers
SET score=0
WHERE score IS NULL;

UPDATE customers
SET country = 'UK',
	score=0
WHERE id=10;

SELECT * 
FROM customers
WHERE id=10;

DELETE FROM customers 
WHERE id>5;

SELECT * FROM customers WHERE id>5;

SELECT * FROM customers c ;

