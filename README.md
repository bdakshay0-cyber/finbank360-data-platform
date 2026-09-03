# FinBank360 — Azure Finance Data Engineering Platform

FinBank360 is an end-to-end finance data engineering portfolio project designed to demonstrate a production-style Azure analytics architecture.

The platform processes synthetic customer, account, merchant, loan, fraud-alert, and financial transaction data using Azure Data Factory, Azure Data Lake Storage Gen2, Azure Databricks, PySpark, Delta Lake, Azure SQL Database, Microsoft Fabric, and Power BI.

The project demonstrates the complete data engineering lifecycle from ingestion and transformation through data quality, dimensional modelling, analytics serving, and business intelligence.

---

## Architecture

The target FinBank360 architecture follows this flow:

```text
Financial Source Data
        |
        v
Azure Data Factory
        |
        v
ADLS Gen2 Raw Layer
        |
        v
Azure Databricks + PySpark
        |
        v
+-----------------------------+
|   Bronze -> Silver -> Gold  |
+-----------------------------+
        |
        v
Microsoft Fabric
        |
        +-------------------+
        |                   |
        v                   v
 Fabric Lakehouse     SQL Analytics Endpoint
        |                   |
        +---------+---------+
                  |
                  v
            Semantic Model
                  |
                  v
               Power BI
```

Azure SQL Database supports the platform with audit, watermark, data-quality, and reprocessing control tables.

---

## Technology Stack

| Technology | Purpose |
|---|---|
| Azure Data Factory | Data ingestion and orchestration |
| Azure Data Lake Storage Gen2 | Cloud data lake storage |
| Azure Databricks | Distributed data processing |
| Apache Spark | Large-scale processing engine |
| PySpark | Data transformation and validation |
| Delta Lake | Reliable Medallion storage |
| Azure SQL Database | Metadata, audit, and control framework |
| Microsoft Fabric | Analytics and serving layer |
| OneLake | Unified Fabric storage |
| Fabric Lakehouse | Analytical data serving |
| SQL Analytics Endpoint | SQL-based analytical access |
| Power BI | Reporting and visualization |
| GitHub | Source control and CI/CD foundation |
| VS Code | Development environment |

---

## Key Data Engineering Features

FinBank360 is designed to demonstrate:

- End-to-end Azure data engineering
- Metadata-driven ingestion
- Parameterized ADF pipelines
- Incremental data loading
- Watermark-based ingestion
- Partitioned transaction processing
- Medallion Architecture
- Bronze, Silver, and Gold data layers
- PySpark transformations
- Delta Lake
- Schema enforcement
- Data cleansing and standardization
- Duplicate detection
- Data-quality validation
- Referential-integrity checks
- Pipeline audit logging
- Error handling
- Reprocessing controls
- Dimensional modelling
- Star-schema design
- Financial KPI calculation
- Microsoft Fabric analytics
- Power BI reporting
- Git-based source control
- CI/CD-ready repository structure

---

## Source Data

The project uses synthetically generated financial datasets.

Primary entities include:

```text
Customers
Accounts
Transactions
Merchants
Loans
Fraud Alerts
```

These datasets simulate typical financial-domain relationships.

Example:

```text
Customer
   |
   +---------- Account
   |              |
   |              +---------- Transaction
   |                              |
   |                              +---------- Merchant
   |
   +---------- Loan
   |
   +---------- Fraud Alert
```

---

## Medallion Architecture

FinBank360 follows the Bronze, Silver, and Gold Medallion pattern.

### Bronze Layer

The Bronze layer contains raw source data with minimal transformation.

Responsibilities include:

- preserving source data
- capturing ingestion timestamps
- recording source system
- recording source file
- storing pipeline metadata
- writing Delta tables

Example:

```text
ADLS Raw
   |
   v
Bronze Customers
Bronze Accounts
Bronze Transactions
Bronze Merchants
```

### Silver Layer

The Silver layer contains cleaned, standardized, validated, and deduplicated data.

Typical transformations include:

- handling null values
- removing duplicate records
- standardizing customer attributes
- validating transaction amounts
- normalizing timestamps
- validating account relationships
- enriching financial transactions
- applying data-quality rules

### Gold Layer

The Gold layer contains business-ready datasets optimized for analytics.

The planned Gold model includes:

```text
                   DimCustomer
                        |
                        |
DimAccount ------ FactTransactions ------ DimMerchant
                        |
                        |
                     DimDate
```

Gold datasets are designed to support Microsoft Fabric and Power BI.

---

## Data Model

The analytical model is designed around a transaction fact table.

### Fact Table

`FactTransactions`

Contains transactional measures and dimension keys.

Typical attributes include:

- transaction ID
- customer key
- account key
- merchant key
- date key
- transaction amount
- transaction fee
- transaction type
- transaction status
- channel
- currency

### Dimensions

The Gold layer includes:

- `DimCustomer`
- `DimAccount`
- `DimMerchant`
- `DimDate`

This provides a star-schema structure suitable for analytical workloads.

---

## Financial KPIs

Planned financial KPIs include:

- Total Transaction Value
- Total Transaction Count
- Average Transaction Value
- Debit Transaction Value
- Credit Transaction Value
- Successful Transaction Count
- Failed Transaction Count
- Failed Transaction Rate
- Active Customers
- Active Accounts
- Transaction Volume by Channel
- Merchant Category Spend
- Daily Transaction Value
- Monthly Transaction Growth

These metrics will support executive, customer, transaction, and operational reporting.

---

## Data Quality Framework

Data quality is treated as a dedicated engineering capability rather than only an ETL activity.

Planned checks include:

- null customer IDs
- null account IDs
- null transaction IDs
- duplicate customer IDs
- duplicate account IDs
- duplicate transaction IDs
- invalid transaction amounts
- future-dated transactions
- orphan accounts
- transactions without valid customers
- transactions without valid accounts
- invalid merchant relationships

The repository includes:

```text
databricks/04_data_quality.py
sql/validation_queries.sql
```

Data-quality results can be recorded in:

```text
dbo.DataQualityAudit
```

---

## Incremental Data Loading

FinBank360 is designed to support incremental ingestion rather than repeatedly processing complete datasets.

The control framework uses:

```text
dbo.WatermarkControl
```

Conceptually:

```text
Previous Watermark
       |
       v
ADF Lookup
       |
       v
Read New / Changed Data
       |
       v
Process Data
       |
       v
Successful Load
       |
       v
Update Watermark
```

This pattern improves scalability and reduces unnecessary processing.

---

## Audit and Monitoring

Azure SQL Database provides the metadata and operational control framework.

Control tables include:

```text
dbo.PipelineAudit
dbo.WatermarkControl
dbo.DataQualityAudit
dbo.ReprocessingControl
```

These tables are designed to support:

- pipeline execution history
- source-file tracking
- rows-read/rows-written reconciliation
- error logging
- incremental ingestion
- data-quality monitoring
- failed-data reprocessing

---

## Microsoft Fabric

Microsoft Fabric is used as the downstream analytics and serving layer.

Planned components include:

- Fabric Lakehouse
- OneLake
- Delta tables
- SQL Analytics Endpoint
- Semantic Model
- Power BI

More information is available in:

```text
fabric/README.md
```

---

## Power BI

Power BI provides the reporting and visualization layer.

Planned dashboard areas include:

### Executive Overview

- transaction value
- transaction volume
- active customers
- active accounts
- failed transaction rate

### Transaction Analysis

- transaction trends
- transaction type
- channel distribution
- merchant-category analysis

### Customer Analysis

- customer segmentation
- customer geography
- customer transaction activity

### Risk and Fraud Analysis

- fraud-alert trends
- suspicious transactions
- high-value transactions
- failed transaction analysis

---

## Repository Structure

```text
finance-data-engineering/
│
├── adf/
│   ├── datasets/
│   ├── linked-services/
│   └── pipelines/
│
├── architecture/
│
├── data/
│   ├── accounts/
│   ├── customers/
│   ├── fraud_alerts/
│   ├── loans/
│   ├── merchants/
│   └── transactions/
│
├── data_generator/
│
├── databricks/
│   ├── 01_bronze_ingestion.py
│   ├── 02_silver_customers.py
│   ├── 03_silver_transactions.py
│   ├── 04_data_quality.py
│   ├── 05_gold_fact_transactions.py
│   ├── 06_gold_dimensions.py
│   └── 07_financial_kpis.py
│
├── docs/
│   ├── data_dictionary.md
│   └── project_documentation.md
│
├── fabric/
│   └── README.md
│
├── powerbi/
│
├── sql/
│   ├── control_tables.sql
│   └── validation_queries.sql
│
├── .gitignore
└── README.md
```

---

## Repository Documentation

Detailed technical documentation is maintained within the repository.

### Data Dictionary

See:

```text
docs/data_dictionary.md
```

for table, column, data-type, and business definitions.

### Project Documentation

See:

```text
docs/project_documentation.md
```

for the complete engineering lifecycle, architecture, implementation approach, security, monitoring, CI/CD, and optimization strategy.

### Microsoft Fabric

See:

```text
fabric/README.md
```

for the planned Fabric analytics architecture.

---

## Security

The project follows the principle that secrets should never be committed to source control.

Credentials such as the following should not be stored in the repository:

- Azure storage keys
- SQL passwords
- service-principal secrets
- Databricks access tokens
- connection passwords

Preferred approaches include:

- Managed Identity
- Microsoft Entra ID
- Azure Key Vault
- Service Principals
- role-based access control
- Databricks secret management

---

## CI/CD

GitHub provides source control for the project.

The target CI/CD lifecycle is:

```text
Development
     |
     v
Feature Branch
     |
     v
Pull Request
     |
     v
Code Review
     |
     v
Main Branch
     |
     v
Automated Deployment
```

Future implementation may use:

- GitHub Actions
- Azure DevOps
- ADF Git integration
- Databricks deployment automation
- Fabric deployment pipelines

---

## Project Status

FinBank360 is being developed incrementally.

The repository currently contains the foundational project structure, documentation, SQL control framework, and Databricks processing scaffolds.

Cloud resources, pipelines, transformations, Fabric artifacts, and reporting components are progressively implemented and validated during subsequent project phases.

This README will be updated as implementation progresses.

---

## Business Outcomes

The completed platform is designed to demonstrate:

- scalable financial-data ingestion
- trusted and standardized datasets
- improved data quality
- incremental processing
- pipeline observability
- auditability
- automated failure tracking
- dimensional modelling
- centralized analytics
- business-ready financial reporting

---

## Disclaimer

All customer, account, merchant, loan, fraud-alert, and transaction information used in this repository is **synthetically generated for educational, demonstration, and portfolio purposes**.

No real banking information, customer records, account information, transaction data, credentials, or personally identifiable customer data is included.

FinBank360 is a portfolio project and does not represent a production banking system.