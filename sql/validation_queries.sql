/*
=========================================================
FinBank360 Data Platform
Validation Queries
=========================================================

Purpose:
- Validate source and target data
- Check record counts
- Detect duplicate records
- Identify invalid financial values
- Identify orphan records
- Support reconciliation and data-quality testing

Target:
- Azure SQL Database
=========================================================
*/


/*
=========================================================
1. Record Count Validation
=========================================================
*/

-- Total customers
SELECT COUNT(*) AS CustomerCount
FROM dbo.Customers;


-- Total accounts
SELECT COUNT(*) AS AccountCount
FROM dbo.Accounts;


-- Total transactions
SELECT COUNT(*) AS TransactionCount
FROM dbo.Transactions;


-- Total merchants
SELECT COUNT(*) AS MerchantCount
FROM dbo.Merchants;


/*
=========================================================
2. Duplicate Record Checks
=========================================================
*/

-- Duplicate customer IDs
SELECT
    customer_id,
    COUNT(*) AS DuplicateCount
FROM dbo.Customers
GROUP BY customer_id
HAVING COUNT(*) > 1;


-- Duplicate account IDs
SELECT
    account_id,
    COUNT(*) AS DuplicateCount
FROM dbo.Accounts
GROUP BY account_id
HAVING COUNT(*) > 1;


-- Duplicate transaction IDs
SELECT
    transaction_id,
    COUNT(*) AS DuplicateCount
FROM dbo.Transactions
GROUP BY transaction_id
HAVING COUNT(*) > 1;


-- Duplicate merchant IDs
SELECT
    merchant_id,
    COUNT(*) AS DuplicateCount
FROM dbo.Merchants
GROUP BY merchant_id
HAVING COUNT(*) > 1;


/*
=========================================================
3. Null / Missing Key Validation
=========================================================
*/

-- Customers without customer ID
SELECT *
FROM dbo.Customers
WHERE customer_id IS NULL;


-- Accounts without account ID
SELECT *
FROM dbo.Accounts
WHERE account_id IS NULL;


-- Transactions without transaction ID
SELECT *
FROM dbo.Transactions
WHERE transaction_id IS NULL;


-- Transactions without customer ID
SELECT *
FROM dbo.Transactions
WHERE customer_id IS NULL;


-- Transactions without account ID
SELECT *
FROM dbo.Transactions
WHERE account_id IS NULL;


/*
=========================================================
4. Financial Amount Validation
=========================================================
*/

-- Transactions with invalid amount
SELECT *
FROM dbo.Transactions
WHERE amount <= 0;


-- Transactions with null amount
SELECT *
FROM dbo.Transactions
WHERE amount IS NULL;


/*
=========================================================
5. Referential Integrity Validation
=========================================================
*/

-- Transactions without matching customers
SELECT t.*
FROM dbo.Transactions t
LEFT JOIN dbo.Customers c
    ON t.customer_id = c.customer_id
WHERE c.customer_id IS NULL;


-- Transactions without matching accounts
SELECT t.*
FROM dbo.Transactions t
LEFT JOIN dbo.Accounts a
    ON t.account_id = a.account_id
WHERE a.account_id IS NULL;


-- Accounts without matching customers
SELECT a.*
FROM dbo.Accounts a
LEFT JOIN dbo.Customers c
    ON a.customer_id = c.customer_id
WHERE c.customer_id IS NULL;


-- Transactions without matching merchants
SELECT t.*
FROM dbo.Transactions t
LEFT JOIN dbo.Merchants m
    ON t.merchant_id = m.merchant_id
WHERE t.merchant_id IS NOT NULL
  AND m.merchant_id IS NULL;


/*
=========================================================
6. Transaction Status Validation
=========================================================
*/

-- Review transaction status distribution
SELECT
    transaction_status,
    COUNT(*) AS TransactionCount
FROM dbo.Transactions
GROUP BY transaction_status
ORDER BY TransactionCount DESC;


-- Identify transactions with missing status
SELECT *
FROM dbo.Transactions
WHERE transaction_status IS NULL;


/*
=========================================================
7. Transaction Type Validation
=========================================================
*/

-- Review transaction type distribution
SELECT
    transaction_type,
    COUNT(*) AS TransactionCount
FROM dbo.Transactions
GROUP BY transaction_type
ORDER BY TransactionCount DESC;


-- Transactions without transaction type
SELECT *
FROM dbo.Transactions
WHERE transaction_type IS NULL;


/*
=========================================================
8. Date Validation
=========================================================
*/

-- Transactions without transaction timestamp
SELECT *
FROM dbo.Transactions
WHERE transaction_timestamp IS NULL;


-- Future-dated transactions
SELECT *
FROM dbo.Transactions
WHERE transaction_timestamp > SYSUTCDATETIME();


/*
=========================================================
9. Account Validation
=========================================================
*/

-- Review account status distribution
SELECT
    account_status,
    COUNT(*) AS AccountCount
FROM dbo.Accounts
GROUP BY account_status
ORDER BY AccountCount DESC;


-- Accounts without account type
SELECT *
FROM dbo.Accounts
WHERE account_type IS NULL;


/*
=========================================================
10. Customer Validation
=========================================================
*/

-- Customers without first name
SELECT *
FROM dbo.Customers
WHERE first_name IS NULL
   OR LTRIM(RTRIM(first_name)) = '';


-- Customers without last name
SELECT *
FROM dbo.Customers
WHERE last_name IS NULL
   OR LTRIM(RTRIM(last_name)) = '';


-- Customers without email
SELECT *
FROM dbo.Customers
WHERE email IS NULL
   OR LTRIM(RTRIM(email)) = '';


/*
=========================================================
11. Pipeline Audit Validation
=========================================================
*/

-- Recent pipeline runs
SELECT TOP 100
    AuditId,
    PipelineName,
    PipelineRunId,
    SourceSystem,
    SourceFile,
    RowsRead,
    RowsWritten,
    PipelineStatus,
    StartTime,
    EndTime,
    ErrorMessage,
    CreatedDate
FROM dbo.PipelineAudit
ORDER BY CreatedDate DESC;


-- Failed pipeline runs
SELECT *
FROM dbo.PipelineAudit
WHERE PipelineStatus = 'FAILED'
ORDER BY CreatedDate DESC;


-- Row-count mismatch between read and written records
SELECT *
FROM dbo.PipelineAudit
WHERE RowsRead IS NOT NULL
  AND RowsWritten IS NOT NULL
  AND RowsRead <> RowsWritten;


/*
=========================================================
12. Data Quality Audit Validation
=========================================================
*/

-- Failed data-quality checks
SELECT *
FROM dbo.DataQualityAudit
WHERE CheckStatus = 'FAIL'
ORDER BY CheckTimestamp DESC;


-- Summary of failed checks
SELECT
    DatasetName,
    CheckName,
    SUM(FailedRecords) AS TotalFailedRecords
FROM dbo.DataQualityAudit
WHERE CheckStatus = 'FAIL'
GROUP BY
    DatasetName,
    CheckName
ORDER BY TotalFailedRecords DESC;


/*
=========================================================
13. Watermark Validation
=========================================================
*/

-- Current watermark values
SELECT
    SourceSystem,
    SourceObject,
    WatermarkColumn,
    WatermarkValue,
    LastSuccessfulRun,
    IsActive
FROM dbo.WatermarkControl
ORDER BY SourceSystem, SourceObject;


/*
=========================================================
14. Reprocessing Validation
=========================================================
*/

-- Items pending reprocessing
SELECT *
FROM dbo.ReprocessingControl
WHERE ReprocessStatus = 'PENDING'
ORDER BY RequestedDate;


/*
=========================================================
Future Enhancements
=========================================================

Planned validation additions:

1. Source-to-target reconciliation
2. Daily transaction balance checks
3. Debit/credit reconciliation
4. Currency validation
5. Duplicate-file detection
6. SLA breach checks
7. Row-count tolerance checks
8. Threshold-based data-quality alerts
9. Fraud-data validation
10. Gold-layer reconciliation

=========================================================
*/