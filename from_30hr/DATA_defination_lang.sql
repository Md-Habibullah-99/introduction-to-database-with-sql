
CREATE TABLE persons(
	id INT NOT NULL,
	name VARCHAR(50) NOT NULL,
	birth_date DATE,
	phone VARCHAR(15) NOT NULL,
	CONSTRAINT pk_persons PRIMARY KEY (id)
)

ALTER TABLE persons 
ADD email VARCHAR(20) NOT NULL;

ALTER TABLE persons 
DROP COLUMN phone;

SELECT * FROM
persons p ;

DROP TABLE persons ;