/* 
 * Finding movies with similar categories still gives you too many options.
 *
 * Write a SQL query that lists all movies that share 2 categories with AMERICAN CIRCUS and 1 actor.
 *
 * HINT:
 * It's possible to complete this problem both with and without set operations,
 * but I find the version using set operations much more intuitive.
 */
WITH CategoryMatches AS (
    SELECT f2.film_id
    FROM film f1
    JOIN film_category fc1 ON f1.film_id = fc1.film_id
    JOIN film_category fc2 ON fc1.category_id = fc2.category_id
    JOIN film f2 ON f2.film_id = fc2.film_id
    WHERE f1.title = 'AMERICAN CIRCUS'
    GROUP BY f2.film_id
    HAVING COUNT(DISTINCT fc2.category_id) >= 2
),
ActorMatches AS (
    SELECT f2.film_id
    FROM film f1
    JOIN film_actor fa1 ON f1.film_id = fa1.film_id
    JOIN film_actor fa2 ON fa1.actor_id = fa2.actor_id
    JOIN film f2 ON f2.film_id = fa2.film_id
    WHERE f1.title = 'AMERICAN CIRCUS'
    GROUP BY f2.film_id
    HAVING COUNT(DISTINCT fa2.actor_id) >= 1
),
CombinedMatches AS (
    SELECT film_id FROM CategoryMatches
    INTERSECT
    SELECT film_id FROM ActorMatches
)
SELECT f.title
FROM film f
JOIN CombinedMatches cm ON f.film_id = cm.film_id
ORDER BY f.title ASC;

