/* 
 * A new James Bond movie will be released soon, and management wants to send promotional material to "action fanatics".
 * They've decided that an action fanatic is any customer where at least 4 of their 5 most recently rented movies are action movies.
 *
 * Write a SQL query that finds all action fanatics.
 */

SELECT c.customer_id, c.first_name, c.last_name
FROM customer c
LEFT JOIN LATERAL (
    SELECT COUNT(*) AS action_count
    FROM (
        SELECT f.film_id
        FROM rental r
        JOIN inventory i ON r.inventory_id = i.inventory_id
        JOIN film f ON i.film_id = f.film_id
        JOIN film_category fc ON f.film_id = fc.film_id
        JOIN category cat ON fc.category_id = cat.category_id
        WHERE r.customer_id = c.customer_id AND cat.name = 'Action'
        ORDER BY r.rental_date DESC
        LIMIT 5
    ) AS recent_rentals
) AS action_movies ON TRUE
WHERE action_movies.action_count >= 4;
