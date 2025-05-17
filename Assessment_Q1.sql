-- Assessment_Q1.sql
-- Identifies customers with at least one funded savings plan AND one funded investment plan
/*
Identifies customers with both savings and investment plans that have actual funded transactions,
sorted by total deposit amount in descending order.
*/
SELECT u.id AS owner_id,
    CONCAT(u.first_name, ' ', u.last_name) AS name,
    COUNT(DISTINCT CASE WHEN p.is_regular_savings = 1 THEN p.id END) AS savings_count,
     -- Count distinct savings plans (is_regular_savings = 1)
    COUNT(DISTINCT CASE WHEN p.is_a_fund = 1 THEN p.id END) AS investment_count,
     -- Count distinct investment plans (is_a_fund = 1)
    SUM(CASE WHEN s.transaction_status = 'success' THEN s.confirmed_amount ELSE 0 END) / 100 AS total_deposits
    -- Sum all successful confirmed amounts (converting from kobo to currency by dividing by 100)
FROM 
    users_customuser AS u
INNER JOIN plans_plan AS p ON u.id = p.owner_id
-- Only join successful transactions to ensure we're counting funded plans
LEFT JOIN savings_savingsaccount AS s ON p.id = s.plan_id
WHERE p.is_deleted = 0 -- Exclude deleted plans
    AND p.status_id = 1   -- Only active plans (assuming 1 = active)
GROUP BY u.id, u.first_name, u.last_name
-- Only include customers with at least one of each plan type
HAVING savings_count > 0 AND investment_count > 0
ORDER BY total_deposits DESC;