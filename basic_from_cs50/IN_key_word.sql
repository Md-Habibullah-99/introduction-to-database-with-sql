-- the table element or table is not available on any of the data base here
SELECT "title" FROM "books" WHERE "id" IN (
  SELECT "book_id" FROM "authored"
  WHERE "author_id" = (
    SELECT "id" FROM "authors" WHERE "name" = 'Fernanda Melchor'
  )
);