# FinBank360 Data Dictionary

This document describes the main datasets, columns, data types, and business meanings used in the FinBank360 Data Platform.

The data model supports customer, account, transaction, merchant, dimensional, and financial KPI analytics.

---

## Customers

| Column | Data Type | Description |
|---|---|---|
| customer_id | STRING | Unique identifier for the customer |
| first_name | STRING | Customer first name |
| last_name | STRING | Customer last name |
| date_of_birth | DATE | Customer date of birth |
| email | STRING | Customer email address |
| phone | STRING | Customer contact number |
| address | STRING | Customer street address |
| city | STRING | Customer city |
| state | STRING | Customer state or region |
| country | STRING | Customer country |
| postal_code | STRING | Customer postal or ZIP code |
| customer_segment | STRING | Customer business segment |
| customer_status | STRING | Current customer status |
| created_timestamp | TIMESTAMP | Timestamp when the customer record was created |
| updated_timestamp | TIMESTAMP | Timestamp when the customer record was last updated |

---

## Accounts

| Column | Data Type | Description |
|---|---|---|
| account_id | STRING | Unique account identifier |
| customer_id | STRING | Customer who owns the account |
| account_type | STRING | Type of account such as savings, current, or credit |
| account_status | STRING | Current account status |
| currency | STRING | ISO currency code used by the account |
| balance | DECIMAL(18,2) | Current account balance |
| open_date | DATE | Date the account was opened |
| close_date | DATE | Date the account was closed, if applicable |
| branch_code | STRING | Bank branch associated with the account |
| created_timestamp | TIMESTAMP | Timestamp when the account record was created |
| updated_timestamp | TIMESTAMP | Timestamp when the account record was last updated |

---

## Transactions

| Column | Data Type | Description |
|---|---|---|
| transaction_id | STRING | Unique transaction identifier |
| account_id | STRING | Account associated with the transaction |
| customer_id | STRING | Customer associated with the transaction |
| transaction_timestamp | TIMESTAMP | Transaction date and time |
| transaction_type | STRING | Debit, credit, transfer, withdrawal, payment, etc. |
| amount | DECIMAL(18,2) | Monetary value of the transaction |
| currency | STRING | ISO currency code |
| merchant_id | STRING | Merchant associated with the transaction |
| merchant_category | STRING | Merchant business category |
| country | STRING | Country in which the transaction occurred |
| channel | STRING | ATM, card, mobile, web, branch, etc. |
| transaction_status | STRING | Processing status of the transaction |
| reference_number | STRING | External or internal transaction reference |
| created_timestamp | TIMESTAMP | Timestamp when the transaction record was created |

---

## Merchants

| Column | Data Type | Description |
|---|---|---|
| merchant_id | STRING | Unique merchant identifier |
| merchant_name | STRING | Merchant trading or business name |
| merchant_category | STRING | Merchant industry/category |
| city | STRING | Merchant city |
| state | STRING | Merchant state or region |
| country | STRING | Merchant country |
| postal_code | STRING | Merchant postal code |
| merchant_status | STRING | Current merchant status |
| created_timestamp | TIMESTAMP | Timestamp when merchant record was created |
| updated_timestamp | TIMESTAMP | Timestamp when merchant record was last updated |

---

## Fraud Alerts

| Column | Data Type | Description |
|---|---|---|
| alert_id | STRING | Unique fraud alert identifier |
| transaction_id | STRING | Transaction associated with the alert |
| customer_id | STRING | Customer associated with the alert |
| account_id | STRING | Account associated with the alert |
| alert_timestamp | TIMESTAMP | Date and time the alert was generated |
| alert_type | STRING | Type of fraud or risk alert |
| risk_score | DECIMAL(5,2) | Fraud or risk score |
| alert_status | STRING | Current fraud alert status |
| investigation_status | STRING | Fraud investigation status |
| resolution | STRING | Resolution or outcome of the fraud investigation |

---

## Loans

| Column | Data Type | Description |
|---|---|---|
| loan_id | STRING | Unique loan identifier |
| customer_id | STRING | Customer associated with the loan |
| account_id | STRING | Related banking account |
| loan_type | STRING | Personal, home, vehicle, business, etc. |
| principal_amount | DECIMAL(18,2) | Original loan amount |
| outstanding_balance | DECIMAL(18,2) | Remaining loan balance |
| interest_rate | DECIMAL(9,4) | Loan interest rate |
| loan_status | STRING | Current status of the loan |
| start_date | DATE | Loan start date |
| maturity_date | DATE | Expected loan maturity date |

---

# Gold Layer

The Gold layer contains dimensional and fact tables optimized for reporting and analytics.

---

## FactTransactions

| Column | Data Type | Description |
|---|---|---|
| transaction_id | STRING | Unique transaction identifier |
| customer_key | BIGINT | Surrogate key referencing DimCustomer |
| account_key | BIGINT | Surrogate key referencing DimAccount |
| merchant_key | BIGINT | Surrogate key referencing DimMerchant |
| date_key | INT | Surrogate key referencing DimDate |
| transaction_timestamp | TIMESTAMP | Transaction date and time |
| transaction_type | STRING | Transaction business type |
| transaction_status | STRING | Transaction processing status |
| transaction_amount | DECIMAL(18,2) | Transaction monetary value |
| transaction_fee | DECIMAL(18,2) | Fee associated with the transaction |
| currency | STRING | ISO currency code |
| channel | STRING | Transaction channel |
| country | STRING | Country where transaction occurred |

---

## DimCustomer

| Column | Data Type | Description |
|---|---|---|
| customer_key | BIGINT | Surrogate customer key |
| customer_id | STRING | Original customer business identifier |
| customer_name | STRING | Customer full name |
| customer_segment | STRING | Customer segment |
| city | STRING | Customer city |
| state | STRING | Customer state or region |
| country | STRING | Customer country |
| customer_status | STRING | Current customer status |
| effective_from | TIMESTAMP | Dimension record effective start timestamp |
| effective_to | TIMESTAMP | Dimension record effective end timestamp |
| is_current | BOOLEAN | Indicates whether the dimension record is current |

---

## DimAccount

| Column | Data Type | Description |
|---|---|---|
| account_key | BIGINT | Surrogate account key |
| account_id | STRING | Original account identifier |
| customer_id | STRING | Related customer identifier |
| account_type | STRING | Type of account |
| account_status | STRING | Current account status |
| currency | STRING | Account currency |
| open_date | DATE | Date account was opened |
| branch_code | STRING | Related bank branch code |

---

## DimMerchant

| Column | Data Type | Description |
|---|---|---|
| merchant_key | BIGINT | Surrogate merchant key |
| merchant_id | STRING | Original merchant identifier |
| merchant_name | STRING | Merchant name |
| merchant_category | STRING | Merchant category |
| city | STRING | Merchant city |
| state | STRING | Merchant state or region |
| country | STRING | Merchant country |
| merchant_status | STRING | Current merchant status |

---

## DimDate

| Column | Data Type | Description |
|---|---|---|
| date_key | INT | Surrogate date key, typically YYYYMMDD |
| full_date | DATE | Calendar date |
| day | INT | Day of month |
| day_name | STRING | Name of the day |
| day_of_week | INT | Numeric day of week |
| week_of_year | INT | Week number |
| month | INT | Month number |
| month_name | STRING | Month name |
| quarter | INT | Calendar quarter |
| year | INT | Calendar year |
| is_weekend | BOOLEAN | Indicates whether the date is a weekend |

---

## FinancialKPIs

| Column | Data Type | Description |
|---|---|---|
| kpi_date | DATE | Date associated with the KPI |
| total_transaction_count | BIGINT | Total number of transactions |
| total_transaction_value | DECIMAL(18,2) | Total transaction monetary value |
| average_transaction_value | DECIMAL(18,2) | Average monetary value per transaction |
| successful_transaction_count | BIGINT | Number of successful transactions |
| failed_transaction_count | BIGINT | Number of failed transactions |
| failed_transaction_rate | DECIMAL(9,4) | Percentage/rate of failed transactions |
| debit_transaction_value | DECIMAL(18,2) | Total debit transaction value |
| credit_transaction_value | DECIMAL(18,2) | Total credit transaction value |
| active_customer_count | BIGINT | Number of customers with qualifying activity |
| active_account_count | BIGINT | Number of accounts with qualifying activity |

---

# Technical Metadata Columns

The Medallion pipeline may introduce additional metadata columns.

| Column | Data Type | Description |
|---|---|---|
| ingestion_timestamp | TIMESTAMP | Timestamp when data entered the platform |
| source_system | STRING | Source application or system |
| source_file | STRING | Name/path of the source file |
| pipeline_run_id | STRING | ADF or orchestration pipeline run identifier |
| record_created_timestamp | TIMESTAMP | Timestamp when platform record was created |
| record_updated_timestamp | TIMESTAMP | Timestamp when platform record was last updated |

---

# Data Type Standards

The FinBank360 platform follows these general data-type conventions:

| Business Data | Recommended Type |
|---|---|
| Business identifiers | STRING |
| Surrogate keys | BIGINT |
| Date keys | INT |
| Currency amounts | DECIMAL(18,2) |
| Interest/risk rates | DECIMAL with appropriate precision |
| Dates | DATE |
| Event timestamps | TIMESTAMP |
| Status fields | STRING |
| Boolean flags | BOOLEAN |
| Record counts | BIGINT |

---

# Key Relationships

The core transactional relationships are:

```text
Customers
    |
    | customer_id
    v
Accounts
    |
    | account_id
    v
Transactions
    |
    +----------> Merchants