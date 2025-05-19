# DataAnalytics-Assessment

Data Analysis Assessment - Step by Step Approach and Explanation

This is a breakdown of the SQL task. Each one solves a specific business question that came up from different teams, marketing, finance, operations. This is a quick summary to explain my approach to each, plus a section on challenges..


1. High-Value Customers with Multiple Products

Objective:
Find customers with at least one funded savings plan AND one funded investment plan, sorted by total deposits.

Approach:
- Joined `users_customuser`, `plans_plan`, and `savings_savingsaccount`.
- Used `is_regular_savings = 1` for savings and `is_a_fund = 1` for investment.
- Grouped by user, counted their plan types, and summed deposits.
- Built the users name as `last_name + first_name`.

Challenge:
The ‘name’ column is populated with null, so I had to concatenate the last_name and first_name to be able to output the name column in the query. 


2. Transaction Frequency Analysis

Objective:
Calculate the average number of transactions per customer per month and categorize them:
"High Frequency" (≥10 transactions/month)
"Medium Frequency" (3-9 transactions/month)
"Low Frequency" 

Approach:
- Pulled transaction counts from `savings_savingsaccount`.
- Extracted `YEAR` and `MONTH` to count transactions per customer per month.
- Aggregated averages per user, then used a `CASE` statement to label frequency.

Challenge:
None encountered.




3. Account Inactivity Alert

Objective:
Find all active accounts (savings or investments) with no transactions in the last 1 year (365 days) .
Tables:
plans_plan
savings_savingsaccount

Approach:
- Pulled from `plans_plan` and `savings_savingsaccount` separately.
- Filtered for active plans using `is_deleted = 0`, `is_archived = 0`, etc.
- Compared `last_transaction_date` to `NOW() - INTERVAL 365 DAY`.
- Combined the savings and investment results using `UNION ALL`.

Challenge:
The challenging part was defining “last transaction date” correctly since there isn’t one explicit defined. I used `MAX(transaction_date)` grouped by plan. Also had to cast the inactivity difference using `DATEDIFF()` to make the number of days clear.


4. Customer Lifetime Value (CLV) Estimation

Objective:
Estimate a simplified CLV per customer using account tenure and transaction volume.

Approach:
- Calculated account tenure from `users_customuser.date_joined` to `NOW()`, in months.
- Counted all savings transactions (`savings_savingsaccount`) per user.
- Used the formula:  
  **CLV = (total_txns / tenure_months) * 12 * avg_profit_per_txn**  
  where `avg_profit_per_txn = 0.001 * avg_txn_value`.

Challenge:
Had to convert kobo to naira (all amounts are stored in kobo). Also had to avoid division by zero in cases where a user’s tenure was less than a month.
