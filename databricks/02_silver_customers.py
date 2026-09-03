"""
FinBank360 Data Platform
02 - Silver Customer Transformation

Purpose:
- Read customer records from the Bronze layer
- Clean and standardize customer attributes
- Handle null values
- Standardize text and date fields
- Remove duplicate customer records
- Produce the trusted Silver customer dataset

Target:
- Silver customer Delta table
"""

from pyspark.sql import functions as F
from pyspark.sql.window import Window


# ---------------------------------------------------------
# Configuration
# ---------------------------------------------------------

BRONZE_CUSTOMERS_PATH = "<BRONZE_CUSTOMERS_PATH>"
SILVER_CUSTOMERS_PATH = "<SILVER_CUSTOMERS_PATH>"


# ---------------------------------------------------------
# Customer cleansing
# ---------------------------------------------------------

def standardize_customers(df):
    """
    Standardize customer attributes.
    """

    # Future transformations may include:
    #
    # - Trim customer names
    # - Convert email addresses to lowercase
    # - Standardize phone numbers
    # - Convert date_of_birth to DateType
    # - Standardize customer status
    # - Handle missing values

    return df


def deduplicate_customers(df):
    """
    Keep the latest record for each customer.
    """

    # TODO: Configure appropriate ordering column,
    # such as updated_timestamp.

    return df


def create_silver_customers():
    """
    Create the Silver customer dataset.
    """

    # TODO:
    # 1. Read Bronze customers
    # 2. Standardize columns
    # 3. Deduplicate customers
    # 4. Write Silver Delta table

    pass


if __name__ == "__main__":
    create_silver_customers()