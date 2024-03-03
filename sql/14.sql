/*
 * Management also wants to create a "best sellers" list for each category.
 *
 * Write a SQL query that:
 * For each category, reports the five films that have been rented the most for each category.
 *
 * Note that in the last query, we were ranking films by the total amount of payments made,
 * but in this query, you are ranking by the total number of times the movie has been rented (and ignoring the price).
 */

WITH FilmRentals AS (
  SELECT
    c.name AS category_name,
    f.title,
    f.film_id,
    COUNT(r.rental_id) AS "total rentals"
  FROM
    rental r
    JOIN inventory i ON r.inventory_id = i.inventory_id
    JOIN film f ON i.film_id = f.film_id
    JOIN film_category fc ON f.film_id = fc.film_id
    JOIN category c ON fc.category_id = c.category_id
  GROUP BY
    c.name, f.title, f.film_id
),
RankedFilms AS (
  SELECT
    category_name,
    title,
    "total rentals",
    film_id,
   ROW_NUMBER() OVER (PARTITION BY category_name ORDER BY "total rentals" DESC) AS rank
    FROM
    FilmRentals
)
SELECT
  category_name AS "name",
  title,
  "total rentals"
FROM
  RankedFilms
WHERE
  rank <= 5
ORDER BY
  category_name, "total rentals" DESC, title ASC;

