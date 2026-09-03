/*
=========================================================
FinBank360 Data Platform
Control Tables
=========================================================

Purpose:
- Support Azure Data Factory orchestration
- Track pipeline executions
- Support incremental ingestion using watermarks
- Log data-quality results
- Support failed-data reprocessing

Target:
- Azure SQL Database

Note:
- This script defines control and audit tables.
- No passwords, access keys, or secrets should be stored here.
=========================================================
*/


/*
=========================================================
1. Pipeline Audit Table
=========================================================

Purpose:
Tracks every ADF pipeline execution including:
- Pipeline name
- Pipeline run ID
- Source information
- Number of rows processed
- Start/end time
- Success/failure status
- Error details
=========================================================
*/

CREATE TABLE dbo.PipelineAudit
(
    AuditId BIGINT IDENTITY(1,1) PRIMARY KEY,

    PipelineName VARCHAR(200) NOT NULL,
    PipelineRunId VARCHAR(100) NULL,

    SourceSystem VARCHAR(100) NULL,
    SourceFile VARCHAR(500) NULL,

    RowsRead BIGINT NULL,
    RowsWritten BIGINT NULL,

    PipelineStatus VARCHAR(50) NOT NULL,

    StartTime DATETIME2 NULL,
    EndTime DATETIME2 NULL,

    ErrorMessage VARCHAR(MAX) NULL,

    CreatedDate DATETIME2 NOT NULL
        DEFAULT SYSUTCDATETIME()
);
GO


/*
=========================================================
2. Watermark Control Table
=========================================================

Purpose:
Stores the latest successfully processed watermark for
incremental data ingestion.

Example:
SourceObject     WatermarkColumn       WatermarkValue
transactions     updated_timestamp     2026-09-03 10:00:00
customers        modified_date         2026-09-03 09:30:00
=========================================================
*/

CREATE TABLE dbo.WatermarkControl
(
    WatermarkId INT IDENTITY(1,1) PRIMARY KEY,

    SourceSystem VARCHAR(100) NOT NULL,
    SourceObject VARCHAR(200) NOT NULL,

    WatermarkColumn VARCHAR(100) NOT NULL,
    WatermarkValue VARCHAR(200) NULL,

    LastSuccessfulRun DATETIME2 NULL,

    IsActive BIT NOT NULL
        DEFAULT 1,

    CreatedDate DATETIME2 NOT NULL
        DEFAULT SYSUTCDATETIME(),

    ModifiedDate DATETIME2 NULL
);
GO


/*
=========================================================
3. Data Quality Audit Table
=========================================================

Purpose:
Stores results from data-quality validations performed
against customer, account and transaction datasets.

Potential checks:
- Null customer ID
- Null account ID
- Duplicate transaction ID
- Invalid transaction amount
- Missing transaction timestamp
=========================================================
*/

CREATE TABLE dbo.DataQualityAudit
(
    DataQualityAuditId BIGINT IDENTITY(1,1) PRIMARY KEY,

    PipelineRunId VARCHAR(100) NULL,

    DatasetName VARCHAR(200) NOT NULL,
    CheckName VARCHAR(200) NOT NULL,

    CheckDescription VARCHAR(500) NULL,

    RecordsChecked BIGINT NULL,
    FailedRecords BIGINT NULL,

    CheckStatus VARCHAR(50) NOT NULL,

    CheckTimestamp DATETIME2 NOT NULL
        DEFAULT SYSUTCDATETIME(),

    ErrorDetails VARCHAR(MAX) NULL
);
GO


/*
=========================================================
4. Reprocessing Control Table
=========================================================

Purpose:
Tracks failed files or pipeline executions that need
to be processed again.

Typical statuses:
- PENDING
- IN_PROGRESS
- COMPLETED
- FAILED
=========================================================
*/

CREATE TABLE dbo.ReprocessingControl
(
    ReprocessingId BIGINT IDENTITY(1,1) PRIMARY KEY,

    PipelineName VARCHAR(200) NOT NULL,
    PipelineRunId VARCHAR(100) NULL,

    SourceFile VARCHAR(500) NULL,

    ReprocessReason VARCHAR(1000) NULL,

    ReprocessStatus VARCHAR(50) NOT NULL
        DEFAULT 'PENDING',

    RequestedDate DATETIME2 NOT NULL
        DEFAULT SYSUTCDATETIME(),

    ProcessedDate DATETIME2 NULL
);
GO


/*
=========================================================
Future Enhancements
=========================================================

Planned additions:

1. Pipeline start logging stored procedure
2. Pipeline success logging stored procedure
3. Pipeline failure logging stored procedure
4. Watermark update stored procedure
5. Batch control table
6. Source configuration metadata
7. SLA monitoring
8. Source-to-target reconciliation
9. Automated reprocessing
10. Data retention and archival logic

=========================================================
*/