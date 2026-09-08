/*
====================================================================
Project : FinBank360
File    : 03_generate_source_data.sql
Purpose : Generate synthetic source data for Azure SQL source tables
Database: sqldb-finbank360
Schema  : src

Target volumes:
- Branches   : 200
- Customers  : 10,000
- Accounts   : 15,000
- Loans      : 8,000

Important:
- Synthetic data only.
- No real customer information.
- Run after 01_create_source_schema.sql
  and 02_create_source_tables.sql.
====================================================================
*/

SET NOCOUNT ON;
GO


/* ================================================================
   1. GENERATE BRANCHES
   ================================================================ */

;WITH Numbers AS
(
    SELECT TOP (200)
        ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM sys.all_objects a
    CROSS JOIN sys.all_objects b
)
INSERT INTO src.Branches
(
    branch_id,
    branch_name,
    city,
    state,
    postcode,
    region,
    opening_date,
    branch_status
)
SELECT
    'B' + RIGHT('0000' + CAST(n AS VARCHAR(4)), 4),

    'FinBank Branch ' + CAST(n AS VARCHAR(10)),

    CASE n % 8
        WHEN 0 THEN 'Melbourne'
        WHEN 1 THEN 'Sydney'
        WHEN 2 THEN 'Brisbane'
        WHEN 3 THEN 'Perth'
        WHEN 4 THEN 'Adelaide'
        WHEN 5 THEN 'Canberra'
        WHEN 6 THEN 'Hobart'
        ELSE 'Darwin'
    END,

    CASE n % 8
        WHEN 0 THEN 'VIC'
        WHEN 1 THEN 'NSW'
        WHEN 2 THEN 'QLD'
        WHEN 3 THEN 'WA'
        WHEN 4 THEN 'SA'
        WHEN 5 THEN 'ACT'
        WHEN 6 THEN 'TAS'
        ELSE 'NT'
    END,

    RIGHT(
        '0000' +
        CAST(
            2000 + (ABS(CHECKSUM(NEWID())) % 7000)
            AS VARCHAR(4)
        ),
        4
    ),

    CASE n % 5
        WHEN 0 THEN 'Metro'
        WHEN 1 THEN 'North'
        WHEN 2 THEN 'South'
        WHEN 3 THEN 'East'
        ELSE 'West'
    END,

    DATEADD(
        DAY,
        -(ABS(CHECKSUM(NEWID())) % 7000),
        CAST(GETDATE() AS DATE)
    ),

    CASE
        WHEN n % 20 = 0 THEN 'Closed'
        WHEN n % 15 = 0 THEN 'Under Renovation'
        ELSE 'Active'
    END

FROM Numbers;
GO



/* ================================================================
   2. GENERATE CUSTOMERS
   ================================================================ */

;WITH Numbers AS
(
    SELECT TOP (10000)
        ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM sys.all_objects a
    CROSS JOIN sys.all_objects b
)
INSERT INTO src.Customers
(
    customer_id,
    first_name,
    last_name,
    email,
    phone,
    date_of_birth,
    city,
    state,
    postcode,
    customer_segment,
    risk_rating,
    created_date,
    updated_date
)
SELECT
    'C' + RIGHT('000000' + CAST(n AS VARCHAR(6)), 6),

    CASE n % 20
        WHEN 0 THEN 'James'
        WHEN 1 THEN 'Olivia'
        WHEN 2 THEN 'Noah'
        WHEN 3 THEN 'Amelia'
        WHEN 4 THEN 'William'
        WHEN 5 THEN 'Charlotte'
        WHEN 6 THEN 'Jack'
        WHEN 7 THEN 'Mia'
        WHEN 8 THEN 'Henry'
        WHEN 9 THEN 'Isla'
        WHEN 10 THEN 'Thomas'
        WHEN 11 THEN 'Grace'
        WHEN 12 THEN 'Lucas'
        WHEN 13 THEN 'Sophie'
        WHEN 14 THEN 'Liam'
        WHEN 15 THEN 'Emily'
        WHEN 16 THEN 'Ethan'
        WHEN 17 THEN 'Ava'
        WHEN 18 THEN 'Alexander'
        ELSE 'Chloe'
    END,

    CASE n % 20
        WHEN 0 THEN 'Smith'
        WHEN 1 THEN 'Jones'
        WHEN 2 THEN 'Williams'
        WHEN 3 THEN 'Brown'
        WHEN 4 THEN 'Wilson'
        WHEN 5 THEN 'Taylor'
        WHEN 6 THEN 'Anderson'
        WHEN 7 THEN 'Thomas'
        WHEN 8 THEN 'Jackson'
        WHEN 9 THEN 'White'
        WHEN 10 THEN 'Harris'
        WHEN 11 THEN 'Martin'
        WHEN 12 THEN 'Thompson'
        WHEN 13 THEN 'Walker'
        WHEN 14 THEN 'Hall'
        WHEN 15 THEN 'Young'
        WHEN 16 THEN 'King'
        WHEN 17 THEN 'Wright'
        WHEN 18 THEN 'Scott'
        ELSE 'Green'
    END,

    'customer'
        + CAST(n AS VARCHAR(10))
        + '@finbank360.example',

    '04'
        + RIGHT(
            '00000000'
            + CAST(
                ABS(CHECKSUM(NEWID())) % 100000000
                AS VARCHAR(8)
            ),
            8
        ),

    DATEADD(
        DAY,
        -(6570 + ABS(CHECKSUM(NEWID())) % 22000),
        CAST(GETDATE() AS DATE)
    ),

    CASE n % 8
        WHEN 0 THEN 'Melbourne'
        WHEN 1 THEN 'Sydney'
        WHEN 2 THEN 'Brisbane'
        WHEN 3 THEN 'Perth'
        WHEN 4 THEN 'Adelaide'
        WHEN 5 THEN 'Canberra'
        WHEN 6 THEN 'Hobart'
        ELSE 'Darwin'
    END,

    CASE n % 8
        WHEN 0 THEN 'VIC'
        WHEN 1 THEN 'NSW'
        WHEN 2 THEN 'QLD'
        WHEN 3 THEN 'WA'
        WHEN 4 THEN 'SA'
        WHEN 5 THEN 'ACT'
        WHEN 6 THEN 'TAS'
        ELSE 'NT'
    END,

    RIGHT(
        '0000'
        + CAST(
            2000 + ABS(CHECKSUM(NEWID())) % 7000
            AS VARCHAR(4)
        ),
        4
    ),

    CASE n % 4
        WHEN 0 THEN 'Retail'
        WHEN 1 THEN 'Premium'
        WHEN 2 THEN 'Business'
        ELSE 'Private'
    END,

    CASE
        WHEN n % 20 = 0 THEN 'High'
        WHEN n % 5 = 0 THEN 'Medium'
        ELSE 'Low'
    END,

    DATEADD(
        DAY,
        -(ABS(CHECKSUM(NEWID())) % 1800),
        SYSUTCDATETIME()
    ),

    DATEADD(
        DAY,
        -(ABS(CHECKSUM(NEWID())) % 90),
        SYSUTCDATETIME()
    )

FROM Numbers;
GO



/* ================================================================
   3. GENERATE ACCOUNTS
   ================================================================ */

;WITH Numbers AS
(
    SELECT TOP (15000)
        ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM sys.all_objects a
    CROSS JOIN sys.all_objects b
)
INSERT INTO src.Accounts
(
    account_id,
    customer_id,
    account_type,
    opening_date,
    balance,
    currency,
    account_status,
    interest_rate,
    branch_id,
    updated_date
)
SELECT
    'A' + RIGHT('000000' + CAST(n AS VARCHAR(6)), 6),

    'C'
        + RIGHT(
            '000000'
            + CAST(
                ((n - 1) % 10000) + 1
                AS VARCHAR(6)
            ),
            6
        ),

    CASE n % 5
        WHEN 0 THEN 'Savings'
        WHEN 1 THEN 'Transaction'
        WHEN 2 THEN 'Term Deposit'
        WHEN 3 THEN 'Business'
        ELSE 'Credit'
    END,

    DATEADD(
        DAY,
        -(ABS(CHECKSUM(NEWID())) % 3000),
        CAST(GETDATE() AS DATE)
    ),

    CAST(
        (ABS(CHECKSUM(NEWID())) % 50000000) / 100.0
        AS DECIMAL(18,2)
    ),

    CASE n % 5
        WHEN 0 THEN 'AUD'
        WHEN 1 THEN 'USD'
        WHEN 2 THEN 'NZD'
        WHEN 3 THEN 'EUR'
        ELSE 'GBP'
    END,

    CASE
        WHEN n % 30 = 0 THEN 'Frozen'
        WHEN n % 20 = 0 THEN 'Closed'
        WHEN n % 10 = 0 THEN 'Dormant'
        ELSE 'Active'
    END,

    CAST(
        (ABS(CHECKSUM(NEWID())) % 700) / 10000.0
        AS DECIMAL(6,4)
    ),

    'B'
        + RIGHT(
            '0000'
            + CAST(
                ((n - 1) % 200) + 1
                AS VARCHAR(4)
            ),
            4
        ),

    DATEADD(
        DAY,
        -(ABS(CHECKSUM(NEWID())) % 90),
        SYSUTCDATETIME()
    )

FROM Numbers;
GO



/* ================================================================
   4. GENERATE LOANS
   ================================================================ */

;WITH Numbers AS
(
    SELECT TOP (8000)
        ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM sys.all_objects a
    CROSS JOIN sys.all_objects b
),
LoanBase AS
(
    SELECT
        n,

        CAST(
            5000
            + (ABS(CHECKSUM(NEWID())) % 995000)
            AS DECIMAL(18,2)
        ) AS principal_amount,

        DATEADD(
            DAY,
            -(ABS(CHECKSUM(NEWID())) % 2500),
            CAST(GETDATE() AS DATE)
        ) AS generated_start_date

    FROM Numbers
)
INSERT INTO src.Loans
(
    loan_id,
    customer_id,
    branch_id,
    loan_type,
    principal_amount,
    interest_rate,
    term_months,
    loan_status,
    outstanding_amount,
    start_date,
    maturity_date,
    updated_date
)
SELECT
    'L' + RIGHT('000000' + CAST(n AS VARCHAR(6)), 6),

    'C'
        + RIGHT(
            '000000'
            + CAST(
                ((n - 1) % 10000) + 1
                AS VARCHAR(6)
            ),
            6
        ),

    'B'
        + RIGHT(
            '0000'
            + CAST(
                ((n - 1) % 200) + 1
                AS VARCHAR(4)
            ),
            4
        ),

    CASE n % 5
        WHEN 0 THEN 'Home Loan'
        WHEN 1 THEN 'Personal Loan'
        WHEN 2 THEN 'Car Loan'
        WHEN 3 THEN 'Business Loan'
        ELSE 'Line of Credit'
    END,

    principal_amount,

    CAST(
        0.0200
        + ((ABS(CHECKSUM(NEWID())) % 800) / 10000.0)
        AS DECIMAL(6,4)
    ),

    CASE n % 5
        WHEN 0 THEN 360
        WHEN 1 THEN 60
        WHEN 2 THEN 84
        WHEN 3 THEN 120
        ELSE 36
    END,

    CASE
        WHEN n % 40 = 0 THEN 'Defaulted'
        WHEN n % 20 = 0 THEN 'Overdue'
        WHEN n % 15 = 0 THEN 'Paid'
        WHEN n % 10 = 0 THEN 'Closed'
        ELSE 'Active'
    END,

    CAST(
        principal_amount *
        (
            0.20 +
            (ABS(CHECKSUM(NEWID())) % 80) / 100.0
        )
        AS DECIMAL(18,2)
    ),

    generated_start_date,

    DATEADD(
        MONTH,
        CASE n % 5
            WHEN 0 THEN 360
            WHEN 1 THEN 60
            WHEN 2 THEN 84
            WHEN 3 THEN 120
            ELSE 36
        END,
        generated_start_date
    ),

    DATEADD(
        DAY,
        -(ABS(CHECKSUM(NEWID())) % 90),
        SYSUTCDATETIME()
    )

FROM LoanBase;
GO



/* ================================================================
   5. QUICK ROW-COUNT CHECK
   ================================================================ */

SELECT 'Branches' AS table_name, COUNT(*) AS row_count
FROM src.Branches

UNION ALL

SELECT 'Customers', COUNT(*)
FROM src.Customers

UNION ALL

SELECT 'Accounts', COUNT(*)
FROM src.Accounts

UNION ALL

SELECT 'Loans', COUNT(*)
FROM src.Loans;
GO