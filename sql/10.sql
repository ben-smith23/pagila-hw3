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
    (customer.first_name || ' ' || customer.last_name) AS "name",
    SUM(payment.amount) AS "total_payment"
  FROM payment
  JOIN customer ON payment.customer_id = customer.customer_id
  GROUP BY payment.customer_id, customer.first_name, customer.last_name
),
PercentileRanks AS (
  SELECT
    customer_id,
    "name",
    "total_payment",
    PERCENT_RANK() OVER (ORDER BY "total_payment" DESC) * 100 AS percentile_rank
  FROM TotalPayments
)
SELECT
  customer_id,
  "name",
  "total_payment",
  CAST(ROUND(percentile_rank) AS INTEGER) AS "percentile" -- Explicitly rounding and casting to INTEGER
FROM PercentileRanks
WHERE percentile_rank >= 90
ORDER BY "name";

