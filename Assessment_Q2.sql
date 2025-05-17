-- Assessment_Q2.sql
-- Categorizes customers by their transaction frequency
/*
Categorizes customers into frequency bands based on their average monthly transactions
over the past 12 months, with statistics for each frequency category.
*/
-- Using CTE to calculate transaction counts and active months per customer
WITH customer_monthly_stats AS (
    SELECT 
        s.owner_id,
        COUNT(s.id) AS transaction_count,
        COUNT(DISTINCT DATE_FORMAT(s.transaction_date, '%Y-%m')) AS active_months
    FROM savings_savingsaccount AS s
    WHERE s.transaction_status = 'success'
        AND s.transaction_date >= DATE_SUB(CURRENT_DATE, INTERVAL 12 MONTH) -- Only consider last 12 months of data
    GROUP BY s.owner_id
    HAVING active_months > 0
)
-- Main query to categorize and aggregate results
SELECT 
    CASE 
        WHEN transaction_count/active_months >= 10 THEN 'High Frequency'
        WHEN transaction_count/active_months >= 3 THEN 'Medium Frequency'
        ELSE 'Low Frequency'
    END AS frequency_category,
    COUNT(owner_id) AS customer_count,
    -- Average transactions per month for each category (rounded to 1 decimal)
    ROUND(AVG(transaction_count/active_months), 1) AS avg_transactions_per_month
FROM customer_monthly_stats -- gotten from temporary table customer_monthly_stats
GROUP BY frequency_category
ORDER BY CASE frequency_category
        WHEN 'High Frequency' THEN 1
        WHEN 'Medium Frequency' THEN 2
        ELSE 3
    END;
    