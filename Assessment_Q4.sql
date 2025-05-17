-- Assessment_Q4.sql
-- Estimates Customer Lifetime Value based on transaction history
/*
Estimates Customer Lifetime Value based on:
- Account tenure (months since joining)
- Total successful transactions
- 0.1% profit assumption per transaction
*/
SELECT 
    u.id AS customer_id,
    CONCAT(u.first_name, ' ', u.last_name) AS name,
        -- Calculate account age in months 
    TIMESTAMPDIFF(MONTH, u.date_joined, CURRENT_DATE) AS tenure_months,
    COUNT(s.id) AS total_transactions,
    ROUND(
        (COUNT(s.id) / GREATEST(TIMESTAMPDIFF(MONTH, u.date_joined, CURRENT_DATE), 1)) * 12 * 
        (SUM(s.confirmed_amount) / 100 * 0.001), 2 -- CLV calculation with safeguards against division by zero
    ) AS estimated_clv
FROM users_customuser AS u
 -- Only count successful transactions with positive amounts
LEFT JOIN savings_savingsaccount AS s ON u.id = s.owner_id AND s.transaction_status = 'success'
WHERE u.is_active = 1
    AND u.is_account_deleted = 0
GROUP BY u.id, u.first_name, u.last_name, u.date_joined
HAVING tenure_months > 0
    AND total_transactions > 0
ORDER BY estimated_clv DESC;