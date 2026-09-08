/*
====================================================================
Project : FinBank360
File    : 02_create_source_tables.sql
Purpose : Create Azure SQL source tables
Database: sqldb-finbank360
Schema  : src
Data    : Synthetic portfolio data only

Important:
- This file contains table definitions only.
- No INSERT / UPDATE / data-generation logic belongs here.
- Secondary indexes belong in 04_create_indexes.sql.
====================================================================
*/


-- ==================================================================
-- 1. CUSTOMERS
-- ==================================================================

CREATE TABLE src.Customers
(
    customer_id       VARCHAR(20)  NOT NULL,
    first_name        VARCHAR(100) NOT NULL,
    last_name         VARCHAR(100) NOT NULL,
    email             VARCHAR(255) NULL,
    phone             VARCHAR(30)  NULL,
    date_of_birth     DATE         NULL,
    city              VARCHAR(100) NULL,
    state             VARCHAR(10)  NULL,
    postcode          VARCHAR(10)  NULL,
    customer_segment  VARCHAR(50)  NULL,
    risk_rating       VARCHAR(20)  NULL,
    created_date      DATETIME2    NOT NULL,
    updated_date      DATETIME2    NOT NULL,

    CONSTRAINT PK_Customers
        PRIMARY KEY (customer_id)
);
GO


-- ==================================================================
-- 2. BRANCHES
-- ==================================================================

CREATE TABLE src.Branches
(
    branch_id      VARCHAR(20)  NOT NULL,
    branch_name    VARCHAR(150) NOT NULL,
    city           VARCHAR(100) NULL,
    state          VARCHAR(10)  NULL,
    postcode       VARCHAR(10)  NULL,
    region         VARCHAR(50)  NULL,
    opening_date   DATE         NULL,
    branch_status  VARCHAR(30)  NULL,

    CONSTRAINT PK_Branches
        PRIMARY KEY (branch_id)
);
GO


-- ==================================================================
-- 3. ACCOUNTS
-- ==================================================================

CREATE TABLE src.Accounts
(
    account_id      VARCHAR(20)  NOT NULL,
    customer_id     VARCHAR(20)  NOT NULL,
    account_type    VARCHAR(50)  NOT NULL,
    opening_date    DATE         NOT NULL,
    balance         DECIMAL(18,2) NOT NULL,
    currency        CHAR(3)      NOT NULL,
    account_status  VARCHAR(30)  NOT NULL,
    interest_rate   DECIMAL(6,4) NULL,
    branch_id       VARCHAR(20)  NULL,
    updated_date    DATETIME2    NOT NULL,

    CONSTRAINT PK_Accounts
        PRIMARY KEY (account_id),

    CONSTRAINT FK_Accounts_Customers
        FOREIGN KEY (customer_id)
        REFERENCES src.Customers(customer_id),

    CONSTRAINT FK_Accounts_Branches
        FOREIGN KEY (branch_id)
        REFERENCES src.Branches(branch_id)
);
GO


-- ==================================================================
-- 4. LOANS
-- ==================================================================

CREATE TABLE src.Loans
(
    loan_id             VARCHAR(20)   NOT NULL,
    customer_id         VARCHAR(20)   NOT NULL,
    branch_id           VARCHAR(20)   NULL,
    loan_type           VARCHAR(50)   NOT NULL,
    principal_amount    DECIMAL(18,2) NOT NULL,
    interest_rate       DECIMAL(6,4)  NULL,
    term_months         INT           NULL,
    loan_status         VARCHAR(30)   NULL,
    outstanding_amount  DECIMAL(18,2) NULL,
    start_date          DATE          NULL,
    maturity_date       DATE          NULL,
    updated_date        DATETIME2     NULL,

    CONSTRAINT PK_Loans
        PRIMARY KEY (loan_id),

    CONSTRAINT FK_Loans_Customers
        FOREIGN KEY (customer_id)
        REFERENCES src.Customers(customer_id),

    CONSTRAINT FK_Loans_Branches
        FOREIGN KEY (branch_id)
        REFERENCES src.Branches(branch_id)
);
GO