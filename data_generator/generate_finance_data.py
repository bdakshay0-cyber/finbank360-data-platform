import pandas as pd
import numpy as np
import random
from faker import Faker
from datetime import datetime, timedelta
from pathlib import Path

fake = Faker("en_AU")

Faker.seed(42)
np.random.seed(42)
random.seed(42)

BASE_DIR = Path(__file__).resolve().parent.parent
DATA_DIR = BASE_DIR / "data"
DATA_DIR.mkdir(parents=True, exist_ok=True)

NUM_CUSTOMERS = 10_000
NUM_ACCOUNTS = 15_000
NUM_MERCHANTS = 2_000
NUM_LOANS = 5_000
NUM_TRANSACTIONS = 500_000
NUM_FRAUD_ALERTS = 10_000

print("Finance data generator started...")

# ============================================================
# CUSTOMER DATA GENERATION - 10000 customers
# ============================================================

def generate_customers():

    print("Generating customers...")

    customers = []

    cities = [
        ("Melbourne", "VIC", "3000"),
        ("Sydney", "NSW", "2000"),
        ("Brisbane", "QLD", "4000"),
        ("Perth", "WA", "6000"),
        ("Adelaide", "SA", "5000"),
        ("Hobart", "TAS", "7000"),
        ("Darwin", "NT", "0800"),
        ("Canberra", "ACT", "2600")
    ]

    segments = ["Standard", "Premium", "Private"]
    risk_ratings = ["Low", "Medium", "High"]
    kyc_statuses = ["Verified", "Pending", "Rejected"]

    for i in range(1, NUM_CUSTOMERS + 1):

        customer_id = f"C{i:06d}"

        first_name = fake.first_name()
        last_name = fake.last_name()

        city, state, postcode = random.choice(cities)

        customers.append({
            "customer_id": customer_id,
            "first_name": first_name,
            "last_name": last_name,
            "date_of_birth": fake.date_of_birth(
                minimum_age=18,
                maximum_age=85
            ),
            "gender": random.choice(["Male", "Female"]),
            "email": f"{first_name.lower()}.{last_name.lower()}{i}@example.com",
            "phone": fake.phone_number(),
            "city": city,
            "state": state,
            "postcode": postcode,
            "country": "Australia",
            "customer_segment": random.choices(
                segments,
                weights=[70, 25, 5]
            )[0],
            "risk_rating": random.choices(
                risk_ratings,
                weights=[75, 20, 5]
            )[0],
            "join_date": fake.date_between(
                start_date="-10y",
                end_date="today"
            ),
            "kyc_status": random.choices(
                kyc_statuses,
                weights=[95, 4, 1]
            )[0]
        })

    df = pd.DataFrame(customers)

    output = DATA_DIR / "customers" / "customers.csv"

    output.parent.mkdir(parents=True, exist_ok=True)

    df.to_csv(output, index=False)

    print(f"Customers generated: {len(df):,}")

    return df



# ============================================================
# ACCOUNT DATA GENERATION - 15,000 Accounts
# ============================================================

def generate_accounts(customers_df):

    print("Generating accounts...")

    accounts = []

    customer_ids = customers_df["customer_id"].tolist()

    account_types = [
        "Savings",
        "Transaction",
        "Credit Card"
    ]

    branches = [
        "MEL001",
        "SYD001",
        "BNE001",
        "PER001",
        "ADL001",
        "HBA001",
        "DRW001",
        "CBR001"
    ]

    for i in range(1, NUM_ACCOUNTS + 1):

        account_type = random.choice(account_types)

        if account_type == "Savings":
            balance = round(random.uniform(100, 100000), 2)
            interest = round(random.uniform(3.5, 5.5), 2)

        elif account_type == "Transaction":
            balance = round(random.uniform(50, 50000), 2)
            interest = 0.00

        else:
            balance = round(random.uniform(-10000, 0), 2)
            interest = round(random.uniform(15, 24), 2)

        accounts.append({
            "account_id": f"A{i:06d}",
            "customer_id": random.choice(customer_ids),
            "account_type": account_type,
            "account_status": random.choices(
                ["Active", "Inactive", "Closed"],
                weights=[90, 7, 3]
            )[0],
            "currency": "AUD",
            "opening_date": fake.date_between(
                start_date="-10y",
                end_date="today"
            ),
            "current_balance": balance,
            "available_balance": round(
                max(balance - random.uniform(0, 500), 0),
                2
            ),
            "interest_rate": interest,
            "branch_code": random.choice(branches),
            "last_updated": fake.date_time_between(
                start_date="-30d",
                end_date="now"
            )
        })

    df = pd.DataFrame(accounts)

    (DATA_DIR / "accounts").mkdir(
        parents=True,
        exist_ok=True
    )

    df.to_csv(
        DATA_DIR / "accounts" / "accounts.csv",
        index=False
    )

    print(f"Accounts generated: {len(df):,}")

    return df



# ============================================================
# MERCHANT DATA GENERATION
# ============================================================

def generate_merchants():

    print("Generating merchants...")

    merchants = []

    categories = [
        "Groceries",
        "Dining",
        "Electronics",
        "Travel",
        "Fuel",
        "Entertainment",
        "Healthcare",
        "Retail",
        "Utilities",
        "Financial Services"
    ]

    locations = [
        ("Melbourne", "VIC", "Australia"),
        ("Sydney", "NSW", "Australia"),
        ("Brisbane", "QLD", "Australia"),
        ("Perth", "WA", "Australia"),
        ("Adelaide", "SA", "Australia"),
        ("Singapore", "NA", "Singapore"),
        ("London", "NA", "United Kingdom"),
        ("New York", "NY", "USA")
    ]

    for i in range(1, NUM_MERCHANTS + 1):

        city, state, country = random.choice(locations)

        merchants.append({
            "merchant_id": f"M{i:05d}",
            "merchant_name": f"{fake.company()} {i}",
            "merchant_category": random.choice(categories),
            "merchant_city": city,
            "merchant_state": state,
            "merchant_country": country,
            "merchant_risk_level": random.choices(
                ["Low", "Medium", "High"],
                weights=[80, 15, 5]
            )[0],
            "active_flag": random.choices(
                ["Y", "N"],
                weights=[97, 3]
            )[0]
        })

    df = pd.DataFrame(merchants)

    (DATA_DIR / "merchants").mkdir(
        parents=True,
        exist_ok=True
    )

    df.to_csv(
        DATA_DIR / "merchants" / "merchants.csv",
        index=False
    )

    print(f"Merchants generated: {len(df):,}")

    return df




# ============================================================
# LOAN DATA GENERATION - 5,000 Loans
# ============================================================

def generate_loans(customers_df):

    print("Generating loans...")

    loans = []

    customer_ids = customers_df["customer_id"].tolist()

    loan_types = [
        "Home Loan",
        "Personal Loan",
        "Car Loan"
    ]

    for i in range(1, NUM_LOANS + 1):

        loan_type = random.choice(loan_types)

        if loan_type == "Home Loan":
            amount = random.uniform(200000, 1500000)
            rate = random.uniform(5.5, 7.5)
            term = 360

        elif loan_type == "Car Loan":
            amount = random.uniform(15000, 100000)
            rate = random.uniform(6.0, 10.0)
            term = random.choice([48, 60, 72])

        else:
            amount = random.uniform(5000, 50000)
            rate = random.uniform(8.0, 15.0)
            term = random.choice([24, 36, 48, 60])

        amount = round(amount, 2)

        outstanding = round(
            amount * random.uniform(0.10, 0.95),
            2
        )

        start_date = fake.date_between(
            start_date="-8y",
            end_date="-30d"
        )

        maturity_date = start_date + timedelta(
            days=int(term * 30.44)
        )

        days_past_due = random.choices(
            [0, 5, 15, 30, 60, 90],
            weights=[80, 5, 5, 4, 3, 3]
        )[0]

        loans.append({
            "loan_id": f"L{i:06d}",
            "customer_id": random.choice(customer_ids),
            "loan_type": loan_type,
            "loan_amount": amount,
            "outstanding_balance": outstanding,
            "interest_rate": round(rate, 2),
            "loan_term_months": term,
            "start_date": start_date,
            "maturity_date": maturity_date,
            "repayment_amount": round(
                amount / term +
                (amount * rate / 100 / 12),
                2
            ),
            "repayment_frequency": "Monthly",
            "loan_status":
                "Delinquent"
                if days_past_due >= 30
                else "Active",
            "credit_score": random.randint(450, 850),
            "days_past_due": days_past_due
        })

    df = pd.DataFrame(loans)

    (DATA_DIR / "loans").mkdir(
        parents=True,
        exist_ok=True
    )

    df.to_csv(
        DATA_DIR / "loans" / "loans.csv",
        index=False
    )

    print(f"Loans generated: {len(df):,}")

    return df



# ============================================================
# TRANSACTION DATA GENERATION - 500,000 Transactions
# ============================================================

def generate_transactions(accounts_df, merchants_df):

    print("Generating 500,000 transactions...")

    merchant_ids = merchants_df["merchant_id"].tolist()

    account_records = accounts_df[
        ["account_id", "customer_id"]
    ].to_dict("records")

    transaction_types = [
        "Card Purchase",
        "Online Purchase",
        "Transfer",
        "ATM Withdrawal",
        "Direct Debit"
    ]

    categories = [
        "Groceries",
        "Dining",
        "Electronics",
        "Travel",
        "Fuel",
        "Entertainment",
        "Healthcare",
        "Retail",
        "Utilities",
        "Transfer"
    ]

    channels = [
        "POS",
        "Online",
        "Mobile",
        "ATM"
    ]

    payment_methods = [
        "Visa",
        "Mastercard",
        "Bank Transfer",
        "Direct Debit"
    ]

    cities = [
        ("Melbourne", "Australia"),
        ("Sydney", "Australia"),
        ("Brisbane", "Australia"),
        ("Perth", "Australia"),
        ("Adelaide", "Australia"),
        ("Singapore", "Singapore"),
        ("London", "United Kingdom"),
        ("New York", "USA")
    ]

    transactions = []

    start_date = datetime(2026, 1, 1)
    end_date = datetime(2026, 8, 31, 23, 59, 59)

    seconds_range = int(
        (end_date - start_date).total_seconds()
    )

    for i in range(1, NUM_TRANSACTIONS + 1):

        account = random.choice(account_records)

        city, country = random.choices(
            cities,
            weights=[30, 25, 15, 10, 8, 5, 4, 3]
        )[0]

        transaction_time = (
            start_date +
            timedelta(
                seconds=random.randint(
                    0,
                    seconds_range
                )
            )
        )

        amount = round(
            np.random.lognormal(
                mean=4.5,
                sigma=1.2
            ),
            2
        )

        transactions.append({
            "transaction_id": f"TXN{i:09d}",
            "account_id": account["account_id"],
            "customer_id": account["customer_id"],
            "merchant_id": random.choice(merchant_ids),
            "transaction_timestamp": transaction_time,
            "transaction_type": random.choice(transaction_types),
            "transaction_category": random.choice(categories),
            "amount": amount,
            "currency": "AUD",
            "debit_credit": random.choices(
                ["Debit", "Credit"],
                weights=[85, 15]
            )[0],
            "transaction_status": random.choices(
                ["Completed", "Declined", "Pending"],
                weights=[94, 4, 2]
            )[0],
            "payment_method": random.choice(payment_methods),
            "channel": random.choice(channels),
            "city": city,
            "country": country,
            "device_id": f"DEV{random.randint(1,50000):06d}",
            "ip_address": fake.ipv4(),
            "is_international":
                0 if country == "Australia" else 1
        })

        if i % 100000 == 0:
            print(f"  Generated {i:,} transactions")

    df = pd.DataFrame(transactions)

    (DATA_DIR / "transactions").mkdir(
        parents=True,
        exist_ok=True
    )

    df.to_csv(
        DATA_DIR / "transactions" / "transactions.csv",
        index=False
    )

    print(f"Transactions generated: {len(df):,}")

    return df



# ============================================================
# FRAUD ALERT DATA GENERATION - 10,000 Fraud Alerts
# ============================================================

def generate_fraud_alerts(transactions_df):

    print("Generating fraud alerts...")

    selected = transactions_df.sample(
        n=NUM_FRAUD_ALERTS,
        random_state=42
    ).reset_index(drop=True)

    alerts = []

    alert_types = [
        "High Value Transaction",
        "International Transaction",
        "Unusual Location",
        "Multiple Transactions",
        "New Device",
        "Suspicious Merchant"
    ]

    rules = [
        "HIGH_VALUE",
        "HIGH_VALUE_INTL",
        "GEO_ANOMALY",
        "VELOCITY_RULE",
        "NEW_DEVICE",
        "MERCHANT_RISK"
    ]

    for i, transaction in selected.iterrows():

        risk_score = random.randint(50, 100)

        if risk_score >= 90:
            risk_level = "Critical"
        elif risk_score >= 75:
            risk_level = "High"
        else:
            risk_level = "Medium"

        transaction_time = pd.to_datetime(
            transaction["transaction_timestamp"]
        )

        alerts.append({
            "alert_id": f"FA{i + 1:06d}",
            "transaction_id":
                transaction["transaction_id"],
            "customer_id":
                transaction["customer_id"],
            "alert_timestamp":
                transaction_time +
                timedelta(
                    seconds=random.randint(1, 300)
                ),
            "alert_type":
                random.choice(alert_types),
            "risk_score": risk_score,
            "risk_level": risk_level,
            "rule_triggered":
                random.choice(rules),
            "investigation_status":
                random.choice([
                    "Open",
                    "Investigating",
                    "Closed"
                ]),
            "fraud_confirmed":
                random.choices(
                    ["Yes", "No", "Pending"],
                    weights=[15, 55, 30]
                )[0]
        })

    df = pd.DataFrame(alerts)

    (DATA_DIR / "fraud_alerts").mkdir(
        parents=True,
        exist_ok=True
    )

    df.to_csv(
        DATA_DIR /
        "fraud_alerts" /
        "fraud_alerts.csv",
        index=False
    )

    print(f"Fraud alerts generated: {len(df):,}")

    return df

# ============================================================
# Main Execution Block
# ============================================================

if __name__ == "__main__":

    print("=" * 60)
    print("FINANCE DATA ENGINEERING - DATA GENERATOR")
    print("=" * 60)

    customers_df = generate_customers()

    accounts_df = generate_accounts(
        customers_df
    )

    merchants_df = generate_merchants()

    loans_df = generate_loans(
        customers_df
    )

    transactions_df = generate_transactions(
        accounts_df,
        merchants_df
    )

    fraud_df = generate_fraud_alerts(
        transactions_df
    )

    print("\n" + "=" * 60)
    print("DATA GENERATION COMPLETED")
    print("=" * 60)

    print(f"Customers:     {len(customers_df):,}")
    print(f"Accounts:      {len(accounts_df):,}")
    print(f"Merchants:     {len(merchants_df):,}")
    print(f"Loans:         {len(loans_df):,}")
    print(f"Transactions:  {len(transactions_df):,}")
    print(f"Fraud Alerts:  {len(fraud_df):,}")

