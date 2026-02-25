
SELECT AVG("book_rating") FROM "rating" WHERE "book_rating" > 4.5 AND "book_rating" < 4.9;


-- GROUP BY
-- currently is not in that form
SELECT "book_id", AVG("rating") AS "avarage rating"
FROM "ratings"
GROUP BY "book_id";


SELECT "book_id", ROUND(AVG("rating"), 2) AS "avarage rating"
FROM "ratings"
GROUP BY "book_id"
--WHERE "avarage rating" > 4.0; --its not possible in group
HAVING "avarage rating" > 4.0;
