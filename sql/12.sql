/* 
 * A new James Bond movie will be released soon, and management wants to send promotional material to "action fanatics".
 * They've decided that an action fanatic is any customer where at least 4 of their 5 most recently rented movies are action movies.
 *
 * Write a SQL query that finds all action fanatics.
 */

WITH RecentRentals AS (
  SELECT
    r.customer_id,
    r.inventory_id,
    r.rental_date,
    ROW_NUMBER() OVER (PARTITION BY r.customer_id ORDER BY r.rental_date DESC) AS rental_rank
  FROM rental r
),
CategorizedRentals AS (
  SELECT
    rr.customer_id,
    fc.category_id
  FROM RecentRentals rr
  JOIN inventory i ON rr.inventory_id = i.inventory_id
  JOIN film_category fc ON i.film_id = fc.film_id
  WHERE rr.rental_rank <= 5
),
ActionFanatics AS (
  SELECT
    cr.customer_id,
    COUNT(*) AS action_count
  FROM CategorizedRentals cr
  JOIN category c ON cr.category_id = c.category_id
  WHERE c.name = 'Action'
  GROUP BY cr.customer_id
  HAVING COUNT(*) >= 4
)
SELECT
  cu.customer_id,
  cu.first_name,
  cu.last_name
FROM customer cu
JOIN ActionFanatics af ON cu.customer_id = af.customer_id
ORDER BY cu.customer_id;
