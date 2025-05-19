SELECT
  p.id AS plan_id,
  p.owner_id,
  CASE
    WHEN p.is_regular_savings = 1 THEN 'Savings'
    WHEN p.is_a_fund = 1 THEN 'Investment'
    ELSE 'Other'
  END AS type,
  MAX(s.transaction_date) AS last_transaction_date,
  DATEDIFF(CURDATE(), MAX(s.transaction_date)) AS inactivity_days
FROM adashi_staging.plans_plan p
JOIN adashi_staging.savings_savingsaccount s ON p.id = s.plan_id
WHERE (p.is_regular_savings = 1 OR p.is_a_fund = 1)
  AND s.confirmed_amount > 0
GROUP BY p.id, p.owner_id, type
HAVING MAX(s.transaction_date) < CURDATE() - INTERVAL 365 DAY;
