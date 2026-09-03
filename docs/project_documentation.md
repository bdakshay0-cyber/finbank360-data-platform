# FinBank360 Data Engineering Platform

## 1. Project Overview

FinBank360 is an end-to-end financial data engineering platform designed to demonstrate modern cloud data engineering practices using Azure Data Factory, Azure Data Lake Storage Gen2, Azure Databricks, PySpark, Azure SQL Database, Microsoft Fabric, and Power BI.

The platform processes financial datasets including:

- Customers
- Accounts
- Transactions
- Merchants
- Loans
- Fraud Alerts

The solution follows a Medallion Architecture using Bronze, Silver, and Gold data layers.

The project is designed as a portfolio-grade implementation demonstrating:

- data ingestion
- transformation
- data quality
- incremental processing
- metadata-driven orchestration
- audit logging
- dimensional modelling
- analytics serving
- monitoring
- security
- CI/CD

---

## 2. Business Problem

Financial organizations receive data from multiple operational systems.

Typical challenges include:

- inconsistent source schemas
- duplicate customer or transaction records
- missing data
- invalid transaction values
- delayed data availability
- poor pipeline traceability
- lack of centralized analytics
- inefficient full-data reloads
- difficulty identifying failed records
- limited auditability

FinBank360 addresses these challenges by building a governed, scalable, and auditable data platform.

The target solution provides trusted financial datasets that can support:

- transaction analytics
- customer analytics
- account analysis
- fraud monitoring
- financial KPI reporting
- executive dashboards

---

## 3. Architecture

The high-level architecture is:

```text
Financial Source Systems
        |
        v
Azure Data Factory
        |
        v
Azure Data Lake Storage Gen2
        |
        v
Azure Databricks
        |
        +-----------------------------+
        |                             |
        v                             v
     Bronze                         Audit
        |                             |
        v                             |
     Silver                           |
        |                             |
        v                             |
 Data Quality                         |
        |                             |
        v                             |
      Gold                            |
        |                             |
        +---------------+-------------+
                        |
                        v
                Microsoft Fabric
                        |
             +----------+----------+
             |          |          |
         Lakehouse     SQL      Semantic
                      Endpoint     Model
                                    |
                                    v
                                 Power BI