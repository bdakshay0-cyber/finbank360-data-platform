"""
FinBank360 Data Platform
01 - Bronze Layer Ingestion

Purpose:
- Read raw banking data from Azure Data Lake Storage Gen2
- Preserve the original source data
- Add ingestion metadata
- Write datasets to Bronze Delta tables

Expected source datasets:
- customers
- accounts
- transactions
- merchants

Target:
- Bronze Delta tables

Future Databricks implementation:
- Configure ADLS access
- Read CSV/JSON/Parquet source files
- Apply explicit schemas
- Add ingestion timestamps
- Add source file metadata
- Write data in Delta format
"""

from pyspark.sql import functions as F
from pyspark.sql.types import *


# ---------------------------------------------------------
# Configuration
# ---------------------------------------------------------

# TODO: Replace these placeholders during Databricks setup.

RAW_BASE_PATH = "<ADLS_RAW_PATH>"
BRONZE_BASE_PATH = "<ADLS_BRONZE_PATH>"


# ---------------------------------------------------------
# Bronze ingestion
# ---------------------------------------------------------

def add_ingestion_metadata(df, source_name):
    """
    Add technical metadata columns to Bronze records.
    """

    return (
        df
        .withColumn("ingestion_timestamp", F.current_timestamp())
        .withColumn("source_system", F.lit(source_name))
    )


def ingest_customers():
    """
    Read raw customer data and write Bronze customer table.
    """

    # TODO: Implement during Databricks step.
    pass


def ingest_accounts():
    """
    Read raw account data and write Bronze account table.
    """

    # TODO: Implement during Databricks step.
    pass


def ingest_transactions():
    """
    Read raw transaction data and write Bronze transaction table.
    """

    # TODO: Implement during Databricks step.
    pass


def ingest_merchants():
    """
    Read raw merchant data and write Bronze merchant table.
    """

    # TODO: Implement during Databricks step.
    pass


if __name__ == "__main__":

    # TODO:
    # ingest_customers()
    # ingest_accounts()
    # ingest_transactions()
    # ingest_merchants()

    pass