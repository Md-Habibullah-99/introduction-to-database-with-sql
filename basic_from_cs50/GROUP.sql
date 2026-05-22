
-- SELECT AVG("gpa") FROM "students" WHERE "gpa" > 4.5 AND "gpa" < 4.9;


-- GROUP BY
-- currently is not in that form
SELECT  group_name AS "Group", AVG(gpa) AS "Avarage gpa of each group"
FROM students
GROUP BY group_name;

SELECT  group_name AS "Group", ROUND(AVG(gpa),2) AS "Avarage gpa of each group"
FROM students
GROUP BY group_name;

SELECT group_name AS "Group", 
 (
  SELECT COUNT(*) 
  FROM students st
  WHERE st.group_name=students.group_name
  AND st.status='Passed'
) AS "Passed",
COUNT(*) AS "Group Total"
FROM students
GROUP BY group_name;


-- SELECT "id","roll", ROUND(AVG("rating"), 2) AS "avarage rating"
-- FROM "ratings"
-- GROUP BY "book_id"
--WHERE "avarage rating" > 4.0; --its not possible in group
-- HAVING "avarage rating" > 4.0;
