/*
 * List the first and last names of all actors who:
 * 1. have appeared in at least one movie in the "Children" category,
 * 2. but that have never appeared in any movie in the "Horror" category.
 */

SELECT DISTINCT first_name, last_name
FROM actor
JOIN film_actor USING (actor_id)
JOIN film USING (film_id)
JOIN film_category USING (film_id)
JOIN category USING (category_id)
WHERE category.name = 'Children'
AND actor.actor_id NOT IN (
    SELECT actor.actor_id
    FROM actor
    JOIN film_actor USING (actor_id)
    JOIN film USING (film_id)
    JOIN film_category USING (film_id)
    JOIN category USING (category_id)
    WHERE category.name = 'Horror'
)
ORDER BY last_name ASC;
