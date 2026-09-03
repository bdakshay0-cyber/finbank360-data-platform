"""
FinBank360 Data Platform
05 - Gold Fact Transactions

Purpose:
- Build the central transaction fact table
- Integrate transaction, customer, account and merchant data
- Prepare transactional data for analytics and Power BI

Target:
- FactTransactions
"""

from pyspark.sql import functions as F


SILVER_TRANSACTIONS_PATH = "<SILVER_TRANSACTIONS_PATH>"
GOLD_FACT_TRANSACTIONS_PATH = "<GOLD_FACT_TRANSACTIONS_PATH>"


def create_fact_transactions():
    """
    Create FactTransactions from trusted Silver data.
    """

    # Planned FactTransactions columns:
    #
    # transaction_id
    # customer_key
    # account_key
    # merchant_key
    # date_key
    # transaction_timestamp
    # transaction_type
    # transaction_status
    # transaction_amount
    # transaction_fee
    # currency
    # channel

    # TODO:
    # 1. Read Silver transactions
    # 2. Join dimension/business keys where required
    # 3. Create analytics-ready columns
    # 4. Write Gold Delta table

    pass


if __name__ == "__main__":
    create_fact_transactions()