/*
 * Find every documentary film that is rated G.
 * Report the title and the actors.
 *
 * HINT:
 * Getting the formatting right on this query can be tricky.
 * You are welcome to try to manually get the correct formatting.
 * But there is also a view in the database that contains the correct formatting,
 * and you can SELECT from that VIEW instead of constructing the entire query manually.
 */

SELECT title, STRING_AGG(INITCAP(SPLIT_PART(actors, ' ', 1)) || INITCAP(SPLIT_PART(actors, ' ', 2)), ', ') AS actors
FROM (
    SELECT title, UNNEST(STRING_TO_ARRAY(actors, ', ')) AS actors
    FROM film_list
    WHERE rating = 'G' AND category = 'Documentary'
) t
GROUP BY title
ORDER BY title;

