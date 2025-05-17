-- Assessment_Q3.sql
-- Identifies inactive accounts with no transactions in the last year
/*
Identifies active accounts (savings or investments) with no successful transactions
in the past 365 days, including days since last transaction.
*/
SELECT p.id AS plan_id,
    p.owner_id,
    CASE 
        WHEN p.is_regular_savings = 1 THEN 'Savings'
        WHEN p.is_a_fund = 1 THEN 'Investment'
        ELSE 'Other'
    END AS type,
    MAX(s.transaction_date) AS last_transaction_date,
    DATEDIFF(CURRENT_DATE, MAX(s.transaction_date)) AS inactivity_days
FROM plans_plan AS p
LEFT JOIN savings_savingsaccount AS s ON p.id = s.plan_id AND s.transaction_status = 'success'
WHERE p.is_deleted = 0
    AND p.status_id = 1
GROUP BY p.id, p.owner_id, p.is_regular_savings, p.is_a_fund
-- Either no transactions at all (NULL) or inactive > 365 days
HAVING last_transaction_date IS NULL 
    OR DATEDIFF(CURRENT_DATE, last_transaction_date) > 365
ORDER BY inactivity_days DESC;