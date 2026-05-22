-- for hsc_results.db

SELECT "id","gpa" FROM "students" WHERE "gpa">=4.5 AND "gpa"<4.6 ORDER BY "gpa" DESC, "id" ASC LIMIT 10;

SELECT "id","gpa" FROM "students" ORDER BY "gpa" DESC LIMIT 10;

SELECT "id","gpa" FROM "students" ORDER BY "gpa" DESC, "id" DESC LIMIT 10;

SELECT "id","gpa" FROM "students" ORDER BY "id" DESC,"gpa" DESC LIMIT 10;