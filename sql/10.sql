/*
 * Management wants to rank customers by how much money they have spent in order to send coupons to the top 10%.
 *
 * Write a query that computes the total amount that each customer has spent.
 * Include a "percentile" column that contains the customer's percentile spending,
 * and include only customers in at least the 90th percentile.
 * Order the results alphabetically.
 *
 * HINT:
 * I used the `ntile` window function to compute the percentile.
 */

WITH TotalPayments AS (
  SELECT
    payment.customer_id,
    SUM(payment.amount) AS "total_payment"
  FROM payment
  GROUP BY payment.customer_id
),
PercentileRanks AS (
  SELECT
    customer_id,
    "total_payment",
    NTILE(100) OVER (ORDER BY total_payment ASC) AS percentile
    FROM TotalPayments
)
SELECT
  c.customer_id,
  (c.first_name || ' ' || c.last_name) AS "name",
  p.total_payment,
  p.percentile
FROM customer c
JOIN PercentileRanks p ON c.customer_id = p.customer_id
WHERE p.percentile > 89
ORDER BY "name" ASC;
