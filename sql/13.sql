/*
 * Management wants to create a "best sellers" list for each actor.
 *
 * Write a SQL query that:
 * For each actor, reports the three films that the actor starred in that have brought in the most revenue for the company.
 * (The revenue is the sum of all payments associated with that film.)
 *
 * HINT:
 * For correct output, you will have to rank the films for each actor.
 * My solution uses the `rank` window function.
 */

WITH FilmRevenue AS (
  SELECT
    fa.actor_id,
    f.film_id,
    SUM(p.amount) AS revenue
  FROM
    film f
    JOIN inventory i ON f.film_id = i.film_id
    JOIN rental r ON i.inventory_id = r.inventory_id
    JOIN payment p ON r.rental_id = p.rental_id
    JOIN film_actor fa ON f.film_id = fa.film_id
  GROUP BY
    fa.actor_id, f.film_id
),
RankedFilms AS (
  SELECT
    fr.actor_id,
    fr.film_id,
    fr.revenue,
    ROW_NUMBER() OVER (PARTITION BY fr.actor_id ORDER BY fr.revenue DESC) AS rank
  FROM
    FilmRevenue fr
)
SELECT
  a.actor_id,
  a.first_name,
  a.last_name,
  rf.film_id,
  f.title,
  rf.rank,
  rf.revenue
FROM
  RankedFilms rf
  JOIN actor a ON rf.actor_id = a.actor_id
  JOIN film f ON rf.film_id = f.film_id
WHERE
  rf.rank <= 3
ORDER BY
  a.actor_id, rf.rank;

