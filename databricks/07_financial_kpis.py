"""
FinBank360 Data Platform
07 - Financial KPI Calculations

Purpose:
- Calculate finance and transaction KPIs
- Generate aggregated datasets for reporting
- Provide optimized Gold datasets for Power BI

Potential KPIs:
- Total Transaction Value
- Total Transaction Count
- Average Transaction Value
- Credit Transaction Value
- Debit Transaction Value
- Failed Transaction Count
- Failed Transaction Rate
- Active Customers
- Transactions by Channel
- Transactions by Merchant Category
- Monthly Transaction Growth
"""

from pyspark.sql import functions as F


GOLD_FACT_TRANSACTIONS_PATH = "<GOLD_FACT_TRANSACTIONS_PATH>"
GOLD_KPI_PATH = "<GOLD_KPI_PATH>"


def calculate_transaction_kpis(df):
    """
    Calculate high-level financial transaction KPIs.
    """

    # Example future calculations:
    #
    # total_transactions
    # total_transaction_value
    # average_transaction_value
    # failed_transactions
    # successful_transactions

    return df


def calculate_daily_kpis(df):
    """
    Aggregate banking KPIs by transaction date.
    """

    return df


def calculate_monthly_kpis(df):
    """
    Aggregate banking KPIs by month.
    """

    return df


def create_financial_kpis():
    """
    Generate Gold KPI datasets.
    """

    # TODO:
    # 1. Read FactTransactions
    # 2. Calculate overall KPIs
    # 3. Calculate daily KPIs
    # 4. Calculate monthly KPIs
    # 5. Write Gold KPI Delta tables

    pass


if __name__ == "__main__":
    create_financial_kpis()