import pandas as pd
from pathlib import Path

base = Path(__file__).resolve().parent.parent / "data"

files = {
    "Customers": base / "customers" / "customers.csv",
    "Accounts": base / "accounts" / "accounts.csv",
    "Merchants": base / "merchants" / "merchants.csv",
    "Loans": base / "loans" / "loans.csv",
    "Transactions": base / "transactions" / "transactions.csv",
    "Fraud Alerts": base / "fraud_alerts" / "fraud_alerts.csv"
}

for name, file in files.items():

    df = pd.read_csv(file)

    print(
        f"{name:<15} "
        f"Rows: {len(df):>10,} "
        f"Columns: {len(df.columns)}"
    )

#============================================================
#Validate Referential Integrity
#============================================================
customers = pd.read_csv(
    base / "customers" / "customers.csv"
)

accounts = pd.read_csv(
    base / "accounts" / "accounts.csv"
)

merchants = pd.read_csv(
    base / "merchants" / "merchants.csv"
)

loans = pd.read_csv(
    base / "loans" / "loans.csv"
)

transactions = pd.read_csv(
    base / "transactions" / "transactions.csv"
)

fraud = pd.read_csv(
    base / "fraud_alerts" / "fraud_alerts.csv"
)


# Account -> Customer
invalid_accounts = accounts[
    ~accounts["customer_id"].isin(
        customers["customer_id"]
    )
]

# Loan -> Customer
invalid_loans = loans[
    ~loans["customer_id"].isin(
        customers["customer_id"]
    )
]

# Transaction -> Account
invalid_tx_accounts = transactions[
    ~transactions["account_id"].isin(
        accounts["account_id"]
    )
]

# Transaction -> Merchant
invalid_tx_merchants = transactions[
    ~transactions["merchant_id"].isin(
        merchants["merchant_id"]
    )
]

# Fraud -> Transaction
invalid_fraud = fraud[
    ~fraud["transaction_id"].isin(
        transactions["transaction_id"]
    )
]


print("\nREFERENTIAL INTEGRITY CHECK")
print("-" * 50)

print(
    "Invalid Account Customers:",
    len(invalid_accounts)
)

print(
    "Invalid Loan Customers:",
    len(invalid_loans)
)

print(
    "Invalid Transaction Accounts:",
    len(invalid_tx_accounts)
)

print(
    "Invalid Transaction Merchants:",
    len(invalid_tx_merchants)
)

print(
    "Invalid Fraud Transactions:",
    len(invalid_fraud)
)