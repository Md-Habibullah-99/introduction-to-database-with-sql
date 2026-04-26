SELECT (
SELECT AVG("gpa")FROM "students" WHERE "group_name"='SCIENCE' AND "status"='Passed'
) AS "avg GPA of science" ,(
SELECT AVG("gpa")FROM "students" WHERE "group_name"='BUSINESS STUDIES' AND "status"='Passed'
) AS "avg GPA of business" ,(
SELECT AVG("gpa") FROM "students" WHERE "group_name"<>'BUSINESS STUDIES' AND "group_name"<>'SCIENCE' AND "status"='Passed'
) AS "avg GPA of arts";