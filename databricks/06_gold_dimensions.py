"""
FinBank360 Data Platform
06 - Gold Dimensions

Purpose:
- Create dimensional tables for the FinBank360 warehouse
- Support the Gold star schema
- Provide descriptive attributes for Power BI reporting

Dimensions:
- DimCustomer
- DimAccount
- DimMerchant
- DimDate
"""

from pyspark.sql import functions as F


def create_dim_customer():
    """
    Create customer dimension.
    """

    # Candidate columns:
    #
    # customer_key
    # customer_id
    # customer_name
    # customer_segment
    # city
    # state
    # country
    # customer_status

    pass


def create_dim_account():
    """
    Create account dimension.
    """

    # Candidate columns:
    #
    # account_key
    # account_id
    # customer_id
    # account_type
    # account_status
    # currency
    # open_date

    pass


def create_dim_merchant():
    """
    Create merchant dimension.
    """

    # Candidate columns:
    #
    # merchant_key
    # merchant_id
    # merchant_name
    # merchant_category
    # city
    # country

    pass


def create_dim_date():
    """
    Create reusable calendar/date dimension.
    """

    # Candidate columns:
    #
    # date_key
    # full_date
    # day
    # month
    # month_name
    # quarter
    # year
    # day_of_week
    # weekend_indicator

    pass


if __name__ == "__main__":

    create_dim_customer()
    create_dim_account()
    create_dim_merchant()
    create_dim_date()