-- in sea_linos.db

SELECT * FROM "sea_lions"
JOIN "migrations" ON "migrations"."id" = "sea_lions"."id";

-- left join
SELECT * FROM "sea_lions"
LEFT JOIN "migrations" ON "migrations"."id" = "sea_lions"."id";

-- right join
SELECT * FROM "sea_lions"
RIGHT JOIN "migrations" ON "migrations"."id" = "sea_lions"."id";

-- full join
SELECT * FROM "sea_lions"
FULL JOIN "migrations" ON "migrations"."id" = "sea_lions"."id";

-- natural join
SELECT * FROM "sea_lions"
NATURAL JOIN "migrations";