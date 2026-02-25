
SELECT AVG("book_rating") FROM "rating" WHERE "book_rating" > 4.5 AND "book_rating" < 4.9;


-- GROUP BY
-- currently is not in that form
SELECT "book_id", AVG("rating") AS "avarage rating"
FROM "rating"
GROUP BY "book_id";