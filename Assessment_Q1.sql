SELECT
  u.id AS customer_id,
  CONCAT(u.last_name, ' ', u.first_name) AS name,
  COUNT(DISTINCT CASE WHEN p.is_regular_savings = 1 THEN s.id END) AS savings_count,
  COUNT(DISTINCT CASE WHEN p.is_a_fund = 1 THEN s.id END) AS investment_count,
  ROUND(SUM(s.confirmed_amount) / 100, 2) AS total_deposits
FROM adashi_staging.users_customuser u
JOIN adashi_staging.savings_savingsaccount s ON u.id = s.owner_id
JOIN adashi_staging.plans_plan p ON s.plan_id = p.id
WHERE s.confirmed_amount > 0
GROUP BY u.id, name
HAVING savings_count > 0 AND investment_count > 0
ORDER BY total_deposits DESC;
