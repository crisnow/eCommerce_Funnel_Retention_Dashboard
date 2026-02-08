CREATE OR REPLACE TABLE `analysis.fact_events` AS
SELECT
    user_id,
    event_time,
    event_type,
    country,
    device_type
FROM `tracking.events`
WHERE event_type IN ('user_signup','page_view', 'add_to_cart', 'purchase');

-- get the KPI ----
#1. Daily Active Users (DAU)

SELECT event_date, count(DISTINCT user_id) as No_users
FROM analysis.fact_events
GROUP BY event_date;


# Funnel Conversion

SELECT
  DATE(event_time) AS event_date,
  COUNT(DISTINCT CASE WHEN event_type = 'user_signup' THEN user_id END) AS signups,
  COUNT(DISTINCT CASE WHEN event_type = 'add_to_cart' THEN user_id END) AS adds_to_cart,
  COUNT(DISTINCT CASE WHEN event_type = 'purchase' THEN user_id END) AS purchases
FROM
  `analysis.fact_events`
GROUP BY
  event_date
ORDER BY
  event_date;


SELECT
  event_date,
  signups,
  adds_to_cart,
  purchases,
  SAFE_DIVIDE(adds_to_cart, signups) AS signup_to_cart_rate,
  SAFE_DIVIDE(purchases, adds_to_cart) AS cart_to_purchase_rate
FROM
  (
   SELECT
  DATE(event_time) AS event_date,
  COUNT(DISTINCT CASE WHEN event_type = 'user_signup' THEN user_id END) AS signups,
  COUNT(DISTINCT CASE WHEN event_type = 'add_to_cart' THEN user_id END) AS adds_to_cart,
  COUNT(DISTINCT CASE WHEN event_type = 'purchase' THEN user_id END) AS purchases
FROM
  `analysis.fact_events`
GROUP BY
  event_date
ORDER BY
  event_date
  )
ORDER BY
  event_date;


  # Retention (7-day, 30-day) How many customers return after signup

  # step 1, for the same user, find out the signup time, after the signup time, check if there are other time within 7 days and 30 days.

WITH first_events AS (
  SELECT
    user_id,
    MIN(DATE(event_time)) AS first_event_date
  FROM
    `analysis.fact_events`
  GROUP BY user_id
),
daily_events AS (
  SELECT
    user_id,
    DATE(event_time) AS event_date
  FROM
    `analysis.fact_events`
)

SELECT
  f.first_event_date,
  
  -- Count of users active within 7 days after their first event
  (SELECT COUNT(DISTINCT d.user_id)
   FROM daily_events d
   WHERE d.user_id = f.user_id
     AND d.event_date > f.first_event_date
     AND d.event_date <= DATE_ADD(f.first_event_date, INTERVAL 7 DAY)
  ) AS day_7_retained

FROM
  first_events f
ORDER BY
  first_event_date;


# percentage calculation:
WITH first_events AS (
  SELECT
    user_id,
    MIN(DATE(event_time)) AS cohort_date
  FROM `analysis.fact_events`
  GROUP BY user_id
),
retained_users AS (
  SELECT DISTINCT
    f.user_id,
    f.cohort_date
  FROM first_events f
  JOIN `analysis.fact_events` e
    ON f.user_id = e.user_id
  WHERE DATE(e.event_time) > f.cohort_date
    AND DATE(e.event_time) <= DATE_ADD(f.cohort_date, INTERVAL 7 DAY)
)

SELECT
  f.cohort_date,
  COUNT(DISTINCT f.user_id) AS cohort_size,
  COUNT(DISTINCT r.user_id) AS retained_7d_users,
  ROUND(
    COUNT(DISTINCT r.user_id) / COUNT(DISTINCT f.user_id),
    3
  ) AS retention_7d_rate
FROM first_events f
LEFT JOIN retained_users r
  ON f.user_id = r.user_id
 AND f.cohort_date = r.cohort_date
GROUP BY f.cohort_date
ORDER BY f.cohort_date;




