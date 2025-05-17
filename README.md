# DataAnalytics-Assessment

## Overview
This repository contains my solutions to the SQL assessment questions, ahowing my proficiency in data retrieval, aggregation, joins, and analysis across multiple tables using MySQL application.

## Question Explanations

### 1. High-Value Customers with Multiple Products

**Approach**:
- Identified customers with both savings (`is_regular_savings = 1`) and investment plans (`is_a_fund = 1`)
- Used conditional aggregation with `COUNT(DISTINCT CASE WHEN...)` to count each plan type separately
- Calculated total deposits by summing `confirmed_amount` (converted from kobo)
- Filtered for active, non-deleted plans with successful transactions
- Key insight: The `LEFT JOIN` with transaction status check ensures we only count funded plans

**Challenges**:
- Initially didn't use conditional aggregation 'CASE WHEN' to count each plan
- Initially miscounted plans by not using `DISTINCT`, counting transactions instead
- Resolved by properly counting distinct plan IDs for each type
- Had to ensure kobo-to-currency conversion was applied consistently

### 2. Transaction Frequency Analysis

**Approach**:
- Created a CTE to calculate transaction counts and active months per customer
- Limited analysis to the past 12 months for recency
- Categorized customers into bands based on monthly transaction averages
- Used `DATE_FORMAT` to group by month while preserving year
- Key insight: The `GREATEST(active_months, 1)` prevents division by zero for new customers

**Challenges**:
- Initially use Sub-query instead of CTE to calculate transaction counts and active months per customer
- Originally calculated frequency over entire history rather than recent activity
- Fixed by adding the 12-month filter and counting distinct active months
- Had to handle edge cases where customers had transactions in the same month

### 3. Account Inactivity Alert

**Approach**:
- Identified active plans (`status_id = 1`, `is_deleted = 0`) with no recent transactions
- Used `LEFT JOIN` with transaction status filter to find last activity date
- Calculated inactivity period with `DATEDIFF`
- Classified plan types using conditional logic
- Key insight: The `HAVING` clause catches both truly inactive accounts and those with no transactions

**Challenges**:
- Initially missed including plans with zero transactions (NULL dates)
- Solved by adding the `last_transaction_date IS NULL` condition
- Had to verify the business definition of "active" accounts

### 4. Customer Lifetime Value (CLV) Estimation

**Approach**:
- Calculated account tenure using `TIMESTAMPDIFF` in months
- Counted successful transactions with positive amounts
- Implemented the CLV formula: `(transactions/tenure) * 12 * (0.1% of total value)`
- Added safeguards against division by zero with `GREATEST`
- Key insight: The `COALESCE` ensures NULL transaction sums default to zero

**Challenges**:
- Initially had issues with MySQL date functions syntax
- Verified proper usage of `TIMESTAMPDIFF` through MySQL documentation
- Had to carefully handle the kobo-to-currency conversion in the profit calculation

## Technical Considerations

1. **Performance Optimizations**:
   - Added appropriate JOIN conditions LIKE INNER JOIN and LEFT JOIN in the ON clause rather than WHERE
   - Used indexing-friendly filtering (e.g., on `transaction_status`)
   - Limited date ranges where applicable

2. **Data Quality**:
   - Handled NULL values with `COALESCE`
   - Protected against division by zero
   - Verified business rules for active/inactive statuses

