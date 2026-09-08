/*
====================================================================
Project : FinBank360
File    : 04_create_indexes.sql
Purpose : Create indexes for Azure SQL source tables
Database: sqldb-finbank360
Schema  : src

Indexes:
- Customers.updated_date
- Accounts.customer_id
- Accounts.updated_date
- Loans.customer_id
- Loans.updated_date

Important:
- Primary key indexes are created automatically by the PK constraints
  in 02_create_source_tables.sql.
- This file contains only additional nonclustered indexes.
====================================================================
*/

SET NOCOUNT ON;
GO


/* ================================================================
   1. CUSTOMERS INDEXES
   ================================================================ */

IF NOT EXISTS
(
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IX_Customers_UpdatedDate'
      AND object_id = OBJECT_ID('src.Customers')
)
BEGIN
    CREATE INDEX IX_Customers_UpdatedDate
    ON src.Customers(updated_date);
END;
GO


/* ================================================================
   2. ACCOUNTS INDEXES
   ================================================================ */

IF NOT EXISTS
(
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IX_Accounts_CustomerID'
      AND object_id = OBJECT_ID('src.Accounts')
)
BEGIN
    CREATE INDEX IX_Accounts_CustomerID
    ON src.Accounts(customer_id);
END;
GO


IF NOT EXISTS
(
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IX_Accounts_UpdatedDate'
      AND object_id = OBJECT_ID('src.Accounts')
)
BEGIN
    CREATE INDEX IX_Accounts_UpdatedDate
    ON src.Accounts(updated_date);
END;
GO


/* ================================================================
   3. LOANS INDEXES
   ================================================================ */

IF NOT EXISTS
(
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IX_Loans_CustomerID'
      AND object_id = OBJECT_ID('src.Loans')
)
BEGIN
    CREATE INDEX IX_Loans_CustomerID
    ON src.Loans(customer_id);
END;
GO


IF NOT EXISTS
(
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IX_Loans_UpdatedDate'
      AND object_id = OBJECT_ID('src.Loans')
)
BEGIN
    CREATE INDEX IX_Loans_UpdatedDate
    ON src.Loans(updated_date);
END;
GO


/* ================================================================
   4. VERIFY CREATED INDEXES
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