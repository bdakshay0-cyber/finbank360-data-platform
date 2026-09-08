/*
====================================================================
Project : FinBank360 Data Platform
File    : platform_validation_queries.sql
Purpose : Platform operational, audit, control and reconciliation
          validation queries
Database: sqldb-finbank360

Important:
- Source-table validation for:
      src.Customers
      src.Accounts
      src.Loans
      src.Branches
  is maintained separately in:
      05_validation_queries.sql

- Transactions and Merchants are file-based sources in ADLS and
  therefore are NOT queried here as dbo.Transactions or dbo.Merchants.

- This file focuses on operational/control tables used by ADF and
  the wider FinBank360 data platform.

Synthetic portfolio project only.
====================================================================
*/

SET NOCOUNT ON;
GO


/* ================================================================
   1. PIPELINE AUDIT VALIDATION
   ================================================================

   Purpose:
   Validate ADF pipeline execution history.

   Expected table:
       dbo.PipelineAudit

   This becomes particularly useful after ADF pipelines are created.
   ================================================================ */


-- ---------------------------------------------------------------
-- 1.1 Recent pipeline runs
-- ---------------------------------------------------------------

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
GO


-- ---------------------------------------------------------------
-- 1.2 Failed pipeline runs
-- ---------------------------------------------------------------

SELECT
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
WHERE PipelineStatus = 'FAILED'
ORDER BY CreatedDate DESC;
GO


-- ---------------------------------------------------------------
-- 1.3 Row-count mismatches
-- ---------------------------------------------------------------

SELECT
    AuditId,
    PipelineName,
    PipelineRunId,
    SourceSystem,
    SourceFile,
    RowsRead,
    RowsWritten,
    PipelineStatus,
    CreatedDate
FROM dbo.PipelineAudit
WHERE RowsRead IS NOT NULL
  AND RowsWritten IS NOT NULL
  AND RowsRead <> RowsWritten
ORDER BY CreatedDate DESC;
GO


-- ---------------------------------------------------------------
-- 1.4 Pipeline status summary
-- ---------------------------------------------------------------

SELECT
    PipelineName,
    PipelineStatus,
    COUNT(*) AS RunCount
FROM dbo.PipelineAudit
GROUP BY
    PipelineName,
    PipelineStatus
ORDER BY
    PipelineName,
    PipelineStatus;
GO


-- ---------------------------------------------------------------
-- 1.5 Latest pipeline run
-- ---------------------------------------------------------------

SELECT TOP 1
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
GO



/* ================================================================
   2. DATA QUALITY AUDIT VALIDATION
   ================================================================

   Purpose:
   Review data-quality checks recorded by the platform.

   Expected table:
       dbo.DataQualityAudit
   ================================================================ */


-- ---------------------------------------------------------------
-- 2.1 Failed data-quality checks
-- ---------------------------------------------------------------

SELECT *
FROM dbo.DataQualityAudit
WHERE CheckStatus = 'FAIL'
ORDER BY CheckTimestamp DESC;
GO


-- ---------------------------------------------------------------
-- 2.2 Failed checks by dataset and check
-- ---------------------------------------------------------------

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
GO


-- ---------------------------------------------------------------
-- 2.3 Data-quality status summary
-- ---------------------------------------------------------------

SELECT
    DatasetName,
    CheckStatus,
    COUNT(*) AS CheckCount
FROM dbo.DataQualityAudit
GROUP BY
    DatasetName,
    CheckStatus
ORDER BY
    DatasetName,
    CheckStatus;
GO


-- ---------------------------------------------------------------
-- 2.4 Latest data-quality checks
-- ---------------------------------------------------------------

SELECT TOP 100 *
FROM dbo.DataQualityAudit
ORDER BY CheckTimestamp DESC;
GO



/* ================================================================
   3. WATERMARK VALIDATION
   ================================================================

   Purpose:
   Validate incremental-load watermark values.

   Expected table:
       dbo.WatermarkControl

   Current FinBank360 incremental SQL entities:
       Customers
       Accounts
       Loans

   Branches uses full-load ingestion.
   ================================================================ */


-- ---------------------------------------------------------------
-- 3.1 Current watermark values
-- ---------------------------------------------------------------

SELECT
    SourceSystem,
    SourceObject,
    WatermarkColumn,
    WatermarkValue,
    LastSuccessfulRun,
    IsActive
FROM dbo.WatermarkControl
ORDER BY
    SourceSystem,
    SourceObject;
GO


-- ---------------------------------------------------------------
-- 3.2 Active watermark configurations
-- ---------------------------------------------------------------

SELECT
    SourceSystem,
    SourceObject,
    WatermarkColumn,
    WatermarkValue,
    LastSuccessfulRun
FROM dbo.WatermarkControl
WHERE IsActive = 1
ORDER BY
    SourceSystem,
    SourceObject;
GO


-- ---------------------------------------------------------------
-- 3.3 Missing watermark values
-- ---------------------------------------------------------------

SELECT
    SourceSystem,
    SourceObject,
    WatermarkColumn,
    WatermarkValue,
    LastSuccessfulRun,
    IsActive
FROM dbo.WatermarkControl
WHERE IsActive = 1
  AND WatermarkValue IS NULL;
GO


-- ---------------------------------------------------------------
-- 3.4 Watermark configurations without a column
-- ---------------------------------------------------------------

SELECT
    SourceSystem,
    SourceObject,
    WatermarkColumn,
    WatermarkValue,
    IsActive
FROM dbo.WatermarkControl
WHERE IsActive = 1
  AND
  (
      WatermarkColumn IS NULL
      OR LTRIM(RTRIM(WatermarkColumn)) = ''
  );
GO



/* ================================================================
   4. REPROCESSING VALIDATION
   ================================================================

   Purpose:
   Review datasets/files that have been marked for reprocessing.

   Expected table:
       dbo.ReprocessingControl
   ================================================================ */


-- ---------------------------------------------------------------
-- 4.1 Items pending reprocessing
-- ---------------------------------------------------------------

SELECT *
FROM dbo.ReprocessingControl
WHERE ReprocessStatus = 'PENDING'
ORDER BY RequestedDate;
GO


-- ---------------------------------------------------------------
-- 4.2 Reprocessing status summary
-- ---------------------------------------------------------------

SELECT
    ReprocessStatus,
    COUNT(*) AS ItemCount
FROM dbo.ReprocessingControl
GROUP BY ReprocessStatus
ORDER BY ReprocessStatus;
GO


-- ---------------------------------------------------------------
-- 4.3 Recent reprocessing requests
-- ---------------------------------------------------------------

SELECT TOP 100 *
FROM dbo.ReprocessingControl
ORDER BY RequestedDate DESC;
GO



/* ================================================================
   5. CONTROL TABLE EXISTENCE VALIDATION
   ================================================================

   Verify that the platform control tables have been created.
   ================================================================ */

SELECT
    TABLE_SCHEMA,
    TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'dbo'
  AND TABLE_NAME IN
  (
      'PipelineAudit',
      'DataQualityAudit',
      'WatermarkControl',
      'ReprocessingControl'
  )
ORDER BY TABLE_NAME;
GO



/* ================================================================
   6. CONTROL TABLE ROW COUNTS
   ================================================================ */

SELECT
    'PipelineAudit' AS table_name,
    COUNT(*) AS row_count
FROM dbo.PipelineAudit

UNION ALL

SELECT
    'DataQualityAudit',
    COUNT(*)
FROM dbo.DataQualityAudit

UNION ALL

SELECT
    'WatermarkControl',
    COUNT(*)
FROM dbo.WatermarkControl

UNION ALL

SELECT
    'ReprocessingControl',
    COUNT(*)
FROM dbo.ReprocessingControl;
GO



/* ================================================================
   7. PIPELINE ERROR ANALYSIS
   ================================================================ */


-- ---------------------------------------------------------------
-- 7.1 Recent pipeline errors
-- ---------------------------------------------------------------

SELECT TOP 100
    PipelineName,
    PipelineRunId,
    SourceSystem,
    SourceFile,
    ErrorMessage,
    StartTime,
    EndTime,
    CreatedDate
FROM dbo.PipelineAudit
WHERE PipelineStatus = 'FAILED'
ORDER BY CreatedDate DESC;
GO


-- ---------------------------------------------------------------
-- 7.2 Failure count by pipeline
-- ---------------------------------------------------------------

SELECT
    PipelineName,
    COUNT(*) AS FailureCount
FROM dbo.PipelineAudit
WHERE PipelineStatus = 'FAILED'
GROUP BY PipelineName
ORDER BY FailureCount DESC;
GO


-- ---------------------------------------------------------------
-- 7.3 Failure count by source system
-- ---------------------------------------------------------------

SELECT
    SourceSystem,
    COUNT(*) AS FailureCount
FROM dbo.PipelineAudit
WHERE PipelineStatus = 'FAILED'
GROUP BY SourceSystem
ORDER BY FailureCount DESC;
GO



/* ================================================================
   8. PIPELINE ROW-COUNT RECONCILIATION
   ================================================================ */


-- ---------------------------------------------------------------
-- 8.1 Successful pipelines with row-count mismatch
-- ---------------------------------------------------------------

SELECT
    AuditId,
    PipelineName,
    PipelineRunId,
    SourceSystem,
    SourceFile,
    RowsRead,
    RowsWritten,
    RowsRead - RowsWritten AS RowDifference,
    PipelineStatus,
    CreatedDate
FROM dbo.PipelineAudit
WHERE PipelineStatus = 'SUCCESS'
  AND RowsRead IS NOT NULL
  AND RowsWritten IS NOT NULL
  AND RowsRead <> RowsWritten
ORDER BY CreatedDate DESC;
GO


-- ---------------------------------------------------------------
-- 8.2 Successful pipelines with zero rows written
-- ---------------------------------------------------------------

SELECT
    AuditId,
    PipelineName,
    PipelineRunId,
    SourceSystem,
    SourceFile,
    RowsRead,
    RowsWritten,
    CreatedDate
FROM dbo.PipelineAudit
WHERE PipelineStatus = 'SUCCESS'
  AND RowsRead > 0
  AND RowsWritten = 0
ORDER BY CreatedDate DESC;
GO



/* ================================================================
   9. PIPELINE DURATION ANALYSIS
   ================================================================ */


SELECT TOP 100
    PipelineName,
    PipelineRunId,
    StartTime,
    EndTime,

    DATEDIFF(
        SECOND,
        StartTime,
        EndTime
    ) AS DurationSeconds,

    PipelineStatus
FROM dbo.PipelineAudit
WHERE StartTime IS NOT NULL
  AND EndTime IS NOT NULL
ORDER BY CreatedDate DESC;
GO



/* ================================================================
   10. FINBANK360 SOURCE INGESTION DESIGN REFERENCE
   ================================================================

   This section is documentation only.

   Current source architecture:

   --------------------------------------------------------------
   Dataset        Source          Load Method
   --------------------------------------------------------------
   Customers      Azure SQL       Incremental
   Accounts       Azure SQL       Incremental
   Loans          Azure SQL       Incremental
   Branches       Azure SQL       Full
   Transactions   CSV             Incremental by file/date
   Merchants      CSV             Full initially
   FX Rates       REST API        Daily
   --------------------------------------------------------------

   Azure SQL source tables:

       src.Customers
       src.Accounts
       src.Loans
       src.Branches

   File/API sources are NOT represented as:

       dbo.Transactions
       dbo.Merchants

   Transactions:
       Daily CSV
           ->
       ADLS landing/transactions/

   Merchants:
       merchants.csv
           ->
       ADLS landing/merchants/

   FX Rates:
       Frankfurter REST API
           ->
       ADLS landing/fx_rates/

   Detailed Azure SQL source validation is maintained in:

       05_validation_queries.sql

   ================================================================ */



/* ================================================================
   11. FUTURE SOURCE-TO-TARGET RECONCILIATION
   ================================================================

   Add these validations after ADF + Bronze/Silver/Gold pipelines
   have been implemented.

   Planned checks:

   1. Azure SQL -> Landing row-count reconciliation

      src.Customers
          ->
      landing/customers/

      src.Accounts
          ->
      landing/accounts/

      src.Loans
          ->
      landing/loans/

      src.Branches
          ->
      landing/branches/


   2. CSV -> Landing reconciliation

      transaction_daily_feed/
          ->
      landing/transactions/

      merchants.csv
          ->
      landing/merchants/


   3. REST -> Landing reconciliation

      Frankfurter REST API
          ->
      landing/fx_rates/


   4. Landing -> Bronze reconciliation


   5. Bronze -> Silver reconciliation


   6. Silver -> Gold reconciliation

   ================================================================ */



/* ================================================================
   12. FUTURE TRANSACTION DATA-QUALITY CHECKS
   ================================================================

   These checks should be implemented against the Bronze/Silver
   transaction tables after they are created.

   Planned checks:

   - Duplicate transaction_id
   - Missing transaction_id
   - Missing account_id
   - Missing customer_id
   - Missing merchant_id
   - transaction_amount <= 0
   - Missing transaction_timestamp
   - Future transaction_timestamp
   - Invalid currency
   - Invalid transaction_status
   - Invalid transaction_type
   - Invalid payment_channel
   - Customer/account relationship validation
   - Merchant relationship validation

   Do NOT query dbo.Transactions because Transactions are currently
   a CSV/ADLS source.

   ================================================================ */



/* ================================================================
   13. FUTURE MERCHANT DATA-QUALITY CHECKS
   ================================================================

   Implement after the Merchant Bronze/Silver tables are created.

   Planned checks:

   - Duplicate merchant_id
   - Missing merchant_id
   - Missing merchant_name
   - Invalid merchant_category
   - Invalid country
   - Invalid risk_category

   Do NOT query dbo.Merchants because Merchants are currently
   a CSV/ADLS source.

   ================================================================ */



/* ================================================================
   14. FUTURE FX-RATE VALIDATION
   ================================================================

   Implement after the FX Rates Bronze/Silver tables are created.

   Planned checks:

   - Missing rate date
   - Missing base currency
   - Missing target currency
   - Missing exchange rate
   - Exchange rate <= 0
   - Duplicate currency/date combinations
   - Expected AUD base currency
   - Daily FX file/API reconciliation

   Expected normalized fields:

       rate_date
       base_currency
       target_currency
       exchange_rate
       ingestion_timestamp

   ================================================================ */



/* ================================================================
   15. FUTURE PLATFORM VALIDATION ENHANCEMENTS
   ================================================================

   Planned additions:

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
   11. Bronze-to-Silver reconciliation
   12. Silver-to-Gold reconciliation
   13. Incremental watermark reconciliation
   14. Late-arriving-data validation
   15. Pipeline performance monitoring

   ================================================================ */