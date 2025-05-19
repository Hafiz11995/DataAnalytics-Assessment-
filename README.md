# DataAnalytics-Assessment

## Overview
This repository showcases my solutions to a series of SQL assessment questions. Each solution demonstrates my ability to analyze and transform data using MySQL, focusing on data aggregation, joins, filtering, and logic implementation across multiple tables. The tasks reflect real-world data analysis challenges, including customer segmentation, transaction behavior, account activity monitoring, and lifetime value estimation.

---

## Assessment Questions & Solutions

### 1. High-Value Customers with Multiple Products

**Challenge**:  
- Did not initially use conditional aggregation (`CASE WHEN`) correctly to count each plan type  
- Miscounted the number of plans by counting transactions instead of distinct plan IDs  
- Inconsistently applied kobo-to-currency conversion  

**Approach**:  
- Used `COUNT(DISTINCT CASE WHEN...)` for accurate savings and investment plan counts  
- Applied currency conversion consistently on `confirmed_amount`  
- Filtered for non-deleted, active plans and successful transactions  
- Used `LEFT JOIN` to ensure only funded plans were included in the count  

---

### 2. Transaction Frequency Analysis

**Challenge**:  
- Initially used subqueries instead of CTEs for transaction and activity month calculations  
- Analyzed customer activity over their entire history instead of focusing on recent 12 months  
- Overlooked edge cases where transactions occurred in the same month  

**Approach**:  
- Created a CTE to calculate transaction counts and distinct active months  
- Limited analysis to the past 12 months using date filtering  
- Used `GREATEST(active_months, 1)` to avoid division by zero  
- Grouped data using `DATE_FORMAT` for accurate monthly aggregation  
- Categorized customers by transaction frequency band  

---

### 3. Account Inactivity Alert

**Challenge**:  
- Initially missed plans with zero transactions (i.e., NULL last transaction dates)  
- Misunderstood business rules around active account criteria  

**Approach**:  
- Selected only plans marked as active (`status_id = 1`) and not deleted  
- Used `LEFT JOIN` to identify last transaction date per plan  
- Calculated inactivity period using `DATEDIFF`  
- Included logic to catch both dormant accounts and those with no activity using `HAVING`  
- Categorized plan types with conditional logic  

---

### 4. Customer Lifetime Value (CLV) Estimation

**Challenge**:  
- Faced syntax issues using MySQL date functions like `TIMESTAMPDIFF`  
- Initially forgot to convert amounts from kobo to currency in revenue calculations  
- Risked division-by-zero errors in tenure-based calculations  

**Approach**:  
- Used `TIMESTAMPDIFF` to compute customer tenure in months  
- Calculated CLV using the formula: `(transactions/tenure) * 12 * (0.1% of total value)`  
- Handled NULLs using `COALESCE`, and used `GREATEST` to safeguard against division by zero  
- Ensured all monetary values were converted from kobo to standard currency  

---

## Technical Considerations

- **Performance Optimization**: Used `INNER JOIN` and `LEFT JOIN` appropriately within `ON` clauses, applied date range filters, and ensured indexing compatibility by filtering on `transaction_status`  
- **Data Quality Assurance**: Used `COALESCE` to handle missing values, protected formulas from division-by-zero errors, and verified the definition of business terms like â€œactive accountâ€  

---

## Summary
This assessment demonstrates my practical skills in using SQL to solve complex business problems. I showed the ability to:

- Correctly analyze customer behaviors and plan usage
- Segment and categorize user activity over time
- Identify dormant accounts with precision
- Estimate customer value using tenure and revenue patterns

Throughout, I emphasized accurate logic, performance-conscious querying, and robustness in handling real-world data irregularities.
