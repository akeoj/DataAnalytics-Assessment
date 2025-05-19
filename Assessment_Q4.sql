SELECT
  u.id AS customer_id,
  CONCAT(u.last_name, ' ', u.first_name) AS name,
  TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE()) AS tenure_months,
  COUNT(s.id) AS total_transactions,
  ROUND(
    (COUNT(s.id) / NULLIF(TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE()), 0))
    * 12
    * (0.001 * AVG(s.confirmed_amount) / 100), 2
  ) AS estimated_clv
FROM adashi_staging.users_customuser u
JOIN adashi_staging.savings_savingsaccount s ON u.id = s.owner_id
JOIN adashi_staging.plans_plan p ON s.plan_id = p.id
WHERE p.is_regular_savings = 1
  AND s.confirmed_amount > 0
GROUP BY u.id, name, tenure_months
ORDER BY estimated_clv DESC;
