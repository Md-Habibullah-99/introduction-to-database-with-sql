USE MyDatabase;

----------------------   MANIPULATION    ------------------------
-- concat
SELECT
	CONCAT(c.first_name, 
	' ',
	c.country) AS name_and_country
FROM Customers c;


-- upper and lower
SELECT
	UPPER(c.first_name) AS upper_name
FROM Customers c;

SELECT
	LOWER(c.first_name) AS lower_name
FROM Customers c;


-- trim
-- find the customers whose first name contains leading or traling spaces
SELECT
	c.first_name,
	LEN(c.first_name) AS name_len,
	LEN(TRIM(c.first_name)) AS len_after_trim
FROM Customers c
WHERE c.first_name <> TRIM(c.first_name);


-- replace
SELECT 
	'123-456-789' phone,
	REPLACE('123-456-789','-','') phone_without_dash,
	REPLACE('123-456-789','-',' / ') phone_with_slash;
SELECT
	'report.txt' AS old_file_name,
	REPLACE('report.txt', '.txt', '.csv') AS new_file_name;


----------------------   CALCULATION    ------------------------

-- len
SELECT 
	c.first_name,
	LEN(c.first_name ) len_of_name
FROM customers c ;
SELECT 
	LEN('abcdef ghi') len_of_sentence;


----------------------   STRING EXTRACTION    ------------------------

-- left and right
SELECT 
	c.first_name,
	LEFT(TRIM(c.first_name), 2) left_two_character,
	RIGHT(TRIM(c.first_name), 3) right_three_character
FROM customers c ;

-- substring
SELECT 
	c.first_name,
	SUBSTRING(TRIM(c.first_name), 3, LEN(c.first_name)) AS sub_name
FROM customers c ;




----------------------   NUMBER FUNCTIONS    ------------------------
-- ROUND
SELECT 
	3.516 AS normal,
	ROUND(3.516 , 2) AS round_2,
	ROUND(3.516 , 1) AS round_1,
	ROUND(3.516 , 0) AS round_0;

-- ABS
SELECT
	ABS(1-5);

SELECT * FROM Customers c;
