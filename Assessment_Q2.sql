WITH user_tx_summary AS (
  SELECT
    s.owner_id,
    COUNT(s.id) AS total_tx,
    TIMESTAMPDIFF(MONTH, MIN(s.transaction_date), MAX(s.transaction_date)) + 1 AS active_months
  FROM adashi_staging.savings_savingsaccount s
  GROUP BY s.owner_id
),
frequency_segment AS (
  SELECT
    u.owner_id,
    ROUND(total_tx / NULLIF(active_months, 0), 1) AS avg_tx_per_month,
    CASE
      WHEN total_tx / NULLIF(active_months, 0) >= 10 THEN 'High Frequency'
      WHEN total_tx / NULLIF(active_months, 0) BETWEEN 3 AND 9 THEN 'Medium Frequency'
      ELSE 'Low Frequency'
    END AS frequency_category
  FROM user_tx_summary u
)
SELECT
  frequency_category,
  COUNT(*) AS customer_count,
  ROUND(AVG(avg_tx_per_month), 1) AS avg_transactions_per_month
FROM frequency_segment
GROUP BY frequency_category
ORDER BY
  FIELD(frequency_category, 'High Frequency', 'Medium Frequency', 'Low Frequency');