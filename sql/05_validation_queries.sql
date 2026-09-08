/*
====================================================================
Project : FinBank360
File    : 05_validation_queries.sql
Purpose : Validate Azure SQL source tables
Database: sqldb-finbank360
Schema  : src

Validations included:
1. Table existence
2. Row counts
3. Primary key uniqueness
4. Foreign key integrity
5. NULL checks
6. updated_date checks
7. Basic domain-value checks
8. Date consistency checks
9. Index validation
10. Incremental-load validation
====================================================================
*/

SET NOCOUNT ON;
GO


/* ================================================================
   1. VERIFY SOURCE TABLES EXIST
   ================================================================ */

SELECT
    TABLE_SCHEMA,
    TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'src'
  AND TABLE_NAME IN
  (
      'Customers',
      'Accounts',
      'Loans',
      'Branches'
  )
ORDER BY TABLE_NAME;
GO


/* ================================================================
   2. VERIFY ROW COUNTS
   ================================================================ */

SELECT 'Customers' AS table_name, COUNT(*) AS row_count
FROM src.Customers

UNION ALL

SELECT 'Accounts', COUNT(*)
FROM src.Accounts

UNION ALL

SELECT 'Loans', COUNT(*)
FROM src.Loans

UNION ALL

SELECT 'Branches', COUNT(*)
FROM src.Branches;
GO

/*
Expected approximately:

Customers : 10000
Accounts  : 15000
Loans     : 8000
Branches  : 200
*/


/* ================================================================
   3. PRIMARY KEY DUPLICATE CHECKS
   ================================================================ */

-- Customers
SELECT
    customer_id,
    COUNT(*) AS duplicate_count
FROM src.Customers
GROUP BY customer_id
HAVING COUNT(*) > 1;
GO


-- Accounts
SELECT
    account_id,
    COUNT(*) AS duplicate_count
FROM src.Accounts
GROUP BY account_id
HAVING COUNT(*) > 1;
GO


-- Loans
SELECT
    loan_id,
    COUNT(*) AS duplicate_count
FROM src.Loans
GROUP BY loan_id
HAVING COUNT(*) > 1;
GO


-- Branches
SELECT
    branch_id,
    COUNT(*) AS duplicate_count
FROM src.Branches
GROUP BY branch_id
HAVING COUNT(*) > 1;
GO

/*
Expected result for all four queries:

0 rows
*/


/* ================================================================
   4. FOREIGN KEY VALIDATION
   ================================================================ */

-- Accounts without matching customer
SELECT
    COUNT(*) AS orphan_accounts_customer
FROM src.Accounts a
LEFT JOIN src.Customers c
    ON a.customer_id = c.customer_id
WHERE c.customer_id IS NULL;
GO


-- Accounts with branch_id but no matching branch
SELECT
    COUNT(*) AS orphan_accounts_branch
FROM src.Accounts a
LEFT JOIN src.Branches b
    ON a.branch_id = b.branch_id
WHERE a.branch_id IS NOT NULL
  AND b.branch_id IS NULL;
GO


-- Loans without matching customer
SELECT
    COUNT(*) AS orphan_loans_customer
FROM src.Loans l
LEFT JOIN src.Customers c
    ON l.customer_id = c.customer_id
WHERE c.customer_id IS NULL;
GO


-- Loans with branch_id but no matching branch
SELECT
    COUNT(*) AS orphan_loans_branch
FROM src.Loans l
LEFT JOIN src.Branches b
    ON l.branch_id = b.branch_id
WHERE l.branch_id IS NOT NULL
  AND b.branch_id IS NULL;
GO

/*
Expected result:

All counts = 0
*/


/* ================================================================
   5. REQUIRED COLUMN NULL CHECKS
   ================================================================ */

SELECT
    SUM(CASE WHEN customer_id IS NULL THEN 1 ELSE 0 END) AS null_customer_id,
    SUM(CASE WHEN first_name IS NULL THEN 1 ELSE 0 END) AS null_first_name,
    SUM(CASE WHEN last_name IS NULL THEN 1 ELSE 0 END) AS null_last_name,
    SUM(CASE WHEN created_date IS NULL THEN 1 ELSE 0 END) AS null_created_date,
    SUM(CASE WHEN updated_date IS NULL THEN 1 ELSE 0 END) AS null_updated_date
FROM src.Customers;
GO


SELECT
    SUM(CASE WHEN account_id IS NULL THEN 1 ELSE 0 END) AS null_account_id,
    SUM(CASE WHEN customer_id IS NULL THEN 1 ELSE 0 END) AS null_customer_id,
    SUM(CASE WHEN account_type IS NULL THEN 1 ELSE 0 END) AS null_account_type,
    SUM(CASE WHEN opening_date IS NULL THEN 1 ELSE 0 END) AS null_opening_date,
    SUM(CASE WHEN balance IS NULL THEN 1 ELSE 0 END) AS null_balance,
    SUM(CASE WHEN currency IS NULL THEN 1 ELSE 0 END) AS null_currency,
    SUM(CASE WHEN account_status IS NULL THEN 1 ELSE 0 END) AS null_account_status,
    SUM(CASE WHEN updated_date IS NULL THEN 1 ELSE 0 END) AS null_updated_date
FROM src.Accounts;
GO


SELECT
    SUM(CASE WHEN loan_id IS NULL THEN 1 ELSE 0 END) AS null_loan_id,
    SUM(CASE WHEN customer_id IS NULL THEN 1 ELSE 0 END) AS null_customer_id,
    SUM(CASE WHEN loan_type IS NULL THEN 1 ELSE 0 END) AS null_loan_type,
    SUM(CASE WHEN principal_amount IS NULL THEN 1 ELSE 0 END) AS null_principal_amount
FROM src.Loans;
GO


SELECT
    SUM(CASE WHEN branch_id IS NULL THEN 1 ELSE 0 END) AS null_branch_id,
    SUM(CASE WHEN branch_name IS NULL THEN 1 ELSE 0 END) AS null_branch_name
FROM src.Branches;
GO


/* ================================================================
   6. UPDATED_DATE VALIDATION
   ================================================================ */

SELECT
    'Customers' AS table_name,
    COUNT(*) AS total_rows,
    COUNT(updated_date) AS rows_with_updated_date,
    MIN(updated_date) AS earliest_updated_date,
    MAX(updated_date) AS latest_updated_date
FROM src.Customers

UNION ALL

SELECT
    'Accounts',
    COUNT(*),
    COUNT(updated_date),
    MIN(updated_date),
    MAX(updated_date)
FROM src.Accounts

UNION ALL

SELECT
    'Loans',
    COUNT(*),
    COUNT(updated_date),
    MIN(updated_date),
    MAX(updated_date)
FROM src.Loans;
GO


/* ================================================================
   7. CUSTOMER DATA QUALITY CHECKS
   ================================================================ */

-- Invalid customer IDs
SELECT customer_id
FROM src.Customers
WHERE customer_id NOT LIKE 'C%';
GO


-- Invalid risk ratings
SELECT DISTINCT risk_rating
FROM src.Customers
WHERE risk_rating IS NOT NULL
  AND risk_rating NOT IN
  (
      'Low',
      'Medium',
      'High'
  );
GO


-- Invalid customer segments
SELECT DISTINCT customer_segment
FROM src.Customers
WHERE customer_segment IS NOT NULL
  AND customer_segment NOT IN
  (
      'Retail',
      'Premium',
      'Business',
      'Private'
  );
GO


-- Basic email format check
SELECT
    customer_id,
    email
FROM src.Customers
WHERE email IS NOT NULL
  AND email NOT LIKE '%_@_%._%';
GO


/* ================================================================
   8. ACCOUNT DATA QUALITY CHECKS
   ================================================================ */

-- Invalid account types
SELECT DISTINCT account_type
FROM src.Accounts
WHERE account_type NOT IN
(
    'Savings',
    'Transaction',
    'Term Deposit',
    'Business',
    'Credit'
);
GO


-- Invalid account statuses
SELECT DISTINCT account_status
FROM src.Accounts
WHERE account_status NOT IN
(
    'Active',
    'Dormant',
    'Closed',
    'Frozen'
);
GO


-- Invalid currencies
SELECT DISTINCT currency
FROM src.Accounts
WHERE currency NOT IN
(
    'AUD',
    'USD',
    'NZD',
    'EUR',
    'GBP'
);
GO


-- Negative balances
SELECT
    account_id,
    balance
FROM src.Accounts
WHERE balance < 0;
GO


-- Invalid interest rates
SELECT
    account_id,
    interest_rate
FROM src.Accounts
WHERE interest_rate IS NOT NULL
  AND interest_rate < 0;
GO


/* ================================================================
   9. LOAN DATA QUALITY CHECKS
   ================================================================ */

-- Invalid loan types
SELECT DISTINCT loan_type
FROM src.Loans
WHERE loan_type NOT IN
(
    'Home Loan',
    'Personal Loan',
    'Car Loan',
    'Business Loan',
    'Line of Credit'
);
GO


-- Invalid loan statuses
SELECT DISTINCT loan_status
FROM src.Loans
WHERE loan_status IS NOT NULL
  AND loan_status NOT IN
  (
      'Active',
      'Paid',
      'Overdue',
      'Defaulted',
      'Closed'
  );
GO


-- Invalid principal values
SELECT
    loan_id,
    principal_amount
FROM src.Loans
WHERE principal_amount <= 0;
GO


-- Outstanding amount greater than principal
SELECT
    loan_id,
    principal_amount,
    outstanding_amount
FROM src.Loans
WHERE outstanding_amount IS NOT NULL
  AND outstanding_amount > principal_amount;
GO


-- Invalid loan terms
SELECT
    loan_id,
    term_months
FROM src.Loans
WHERE term_months IS NOT NULL
  AND term_months <= 0;
GO


/* ================================================================
   10. DATE CONSISTENCY CHECKS
   ================================================================ */

-- Customer updated_date earlier than created_date
SELECT
    customer_id,
    created_date,
    updated_date
FROM src.Customers
WHERE updated_date < created_date;
GO


-- Future account opening dates
SELECT
    account_id,
    opening_date
FROM src.Accounts
WHERE opening_date > CAST(GETDATE() AS DATE);
GO


-- Loan maturity before start date
SELECT
    loan_id,
    start_date,
    maturity_date
FROM src.Loans
WHERE start_date IS NOT NULL
  AND maturity_date IS NOT NULL
  AND maturity_date < start_date;
GO


/* ================================================================
   11. BRANCH DATA QUALITY CHECKS
   ================================================================ */

-- Invalid branch IDs
SELECT
    branch_id
FROM src.Branches
WHERE branch_id NOT LIKE 'B%';
GO


-- Invalid branch statuses
SELECT DISTINCT branch_status
FROM src.Branches
WHERE branch_status IS NOT NULL
  AND branch_status NOT IN
  (
      'Active',
      'Closed',
      'Under Renovation'
  );
GO


/* ================================================================
   12. VERIFY PRIMARY AND SECONDARY INDEXES
   ================================================================ */

SELECT
    s.name AS schema_name,
    t.name AS table_name,
    i.name AS index_name,
    i.type_desc AS index_type,
    i.is_unique,
    i.is_primary_key
FROM sys.indexes i
JOIN sys.tables t
    ON i.object_id = t.object_id
JOIN sys.schemas s
    ON t.schema_id = s.schema_id
WHERE s.name = 'src'
  AND t.name IN
  (
      'Customers',
      'Accounts',
      'Loans',
      'Branches'
  )
  AND i.name IS NOT NULL
ORDER BY
    t.name,
    i.name;
GO


/* ================================================================
   13. VERIFY FOREIGN KEY CONSTRAINTS
   ================================================================ */

SELECT
    fk.name AS foreign_key_name,
    OBJECT_SCHEMA_NAME(fk.parent_object_id) AS child_schema,
    OBJECT_NAME(fk.parent_object_id) AS child_table,
    pc.name AS child_column,
    OBJECT_SCHEMA_NAME(fk.referenced_object_id) AS parent_schema,
    OBJECT_NAME(fk.referenced_object_id) AS parent_table,
    rc.name AS parent_column
FROM sys.foreign_keys fk
JOIN sys.foreign_key_columns fkc
    ON fk.object_id = fkc.constraint_object_id
JOIN sys.columns pc
    ON fkc.parent_object_id = pc.object_id
   AND fkc.parent_column_id = pc.column_id
JOIN sys.columns rc
    ON fkc.referenced_object_id = rc.object_id
   AND fkc.referenced_column_id = rc.column_id
WHERE OBJECT_SCHEMA_NAME(fk.parent_object_id) = 'src'
ORDER BY
    child_table,
    foreign_key_name;
GO


/* ================================================================
   14. TEST INCREMENTAL EXTRACTION LOGIC
   ================================================================ */

DECLARE @LastWatermark DATETIME2 =
    DATEADD(DAY, -30, SYSUTCDATETIME());

SELECT
    'Customers' AS table_name,
    COUNT(*) AS incremental_row_count,
    MIN(updated_date) AS earliest_updated_date,
    MAX(updated_date) AS latest_updated_date
FROM src.Customers
WHERE updated_date > @LastWatermark

UNION ALL

SELECT
    'Accounts',
    COUNT(*),
    MIN(updated_date),
    MAX(updated_date)
FROM src.Accounts
WHERE updated_date > @LastWatermark

UNION ALL

SELECT
    'Loans',
    COUNT(*),
    MIN(updated_date),
    MAX(updated_date)
FROM src.Loans
WHERE updated_date > @LastWatermark;
GO


/* ================================================================
   15. TEST BOUNDED WATERMARK LOGIC FOR FUTURE ADF PIPELINE
   ================================================================ */

DECLARE @OldWatermark DATETIME2 =
    DATEADD(DAY, -30, SYSUTCDATETIME());

DECLARE @NewWatermark DATETIME2 =
    SYSUTCDATETIME();

SELECT
    COUNT(*) AS AccountIncrementalRows
FROM src.Accounts
WHERE updated_date > @OldWatermark
  AND updated_date <= @NewWatermark;
GO


/* ================================================================
   16. FINAL SUMMARY
   ================================================================ */

SELECT
    'Customers' AS table_name,
    COUNT(*) AS row_count
FROM src.Customers

UNION ALL

SELECT
    'Accounts',
    COUNT(*)
FROM src.Accounts

UNION ALL

SELECT
    'Loans',
    COUNT(*)
FROM src.Loans

UNION ALL

SELECT
    'Branches',
    COUNT(*)
FROM src.Branches;
GO