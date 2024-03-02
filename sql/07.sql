/*
 * List all actors with Bacall Number 2;
 * That is, list all actors that have appeared in a film with an actor that has appeared in a film with 'RUSSELL BACALL',
 * but do not include actors that have Bacall Number < 2.
 */

WITH RussellBacallFilms AS (
    SELECT fa.film_id
    FROM film_actor fa
    JOIN actor a ON fa.actor_id = a.actor_id
    WHERE a.last_name = 'BACALL'
),
BacallNumber1 AS (
    SELECT fa.actor_id
    FROM film_actor fa
    JOIN RussellBacallFilms RBF ON fa.film_id = RBF.film_id
    JOIN actor USING (actor_id)
    WHERE NOT actor.last_name = 'BACALL'
),
BacallNumber2 AS (
    SELECT DISTINCT fa.actor_id
    FROM film_actor fa
    JOIN BacallNumber1 BN1 ON fa.film_id IN (
        SELECT film_id FROM film_actor WHERE actor_id = BN1.actor_id
    )
    WHERE fa.actor_id NOT IN (SELECT actor_id FROM BacallNumber1)
    AND NOT fa.actor_id IN (
        SELECT actor_id FROM actor WHERE last_name = 'BACALL'
    )
)
SELECT a.first_name || ' ' || a.last_name AS "Actor Name"
FROM actor a
JOIN BacallNumber2 ON a.actor_id = BacallNumber2.actor_id
ORDER BY "Actor Name";

