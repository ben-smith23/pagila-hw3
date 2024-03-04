/*
 * Management also wants to create a "best sellers" list for each category.
 *
 * Write a SQL query that:
 * For each category, reports the five films that have been rented the most for each category.
 *
 * Note that in the last query, we were ranking films by the total amount of payments made,
 * but in this query, you are ranking by the total number of times the movie has been rented (and ignoring the price).
 */

SELECT c.name, sub.title, COALESCE(sub.total_rentals, 0) AS "total rentals"
FROM category c
LEFT JOIN (
    SELECT fc.category_id, f.title, COUNT(r.rental_id) AS total_rentals
    FROM film f
    LEFT JOIN inventory i ON f.film_id = i.film_id
    LEFT JOIN rental r ON i.inventory_id = r.inventory_id
    JOIN film_category fc ON f.film_id = fc.film_id
    GROUP BY fc.category_id, f.title
) AS sub ON c.category_id = sub.category_id
JOIN (
    SELECT category_id, title,
           ROW_NUMBER() OVER(PARTITION BY category_id ORDER BY total_rentals DESC, title DESC) as rn
    FROM (
        SELECT fc.category_id, f.title, COUNT(r.rental_id) AS total_rentals
        FROM film f
        LEFT JOIN inventory i ON f.film_id = i.film_id
        LEFT JOIN rental r ON i.inventory_id = r.inventory_id
        JOIN film_category fc ON f.film_id = fc.film_id
        GROUP BY fc.category_id, f.title
    ) AS ranking
) AS ranked_movies ON ranked_movies.category_id = c.category_id AND ranked_movies.title = sub.title
WHERE ranked_movies.rn <= 5
ORDER BY c.name, "total rentals" DESC, sub.title;

