import pandas as pd
from pathlib import Path

BASE_DIR = Path(__file__).resolve().parent.parent

INPUT_FILE = (
    BASE_DIR
    / "data"
    / "transactions"
    / "transactions.csv"
)

OUTPUT_DIR = (
    BASE_DIR
    / "data"
    / "transactions_partitioned"
)

print("=" * 60)
print("PARTITIONING TRANSACTION DATA")
print("=" * 60)

print("Reading transactions.csv...")

df = pd.read_csv(
    INPUT_FILE,
    parse_dates=["transaction_timestamp"]
)

print(f"Transactions loaded: {len(df):,}")

df["transaction_date"] = (
    df["transaction_timestamp"].dt.date
)

grouped = df.groupby("transaction_date")

file_count = 0
row_count = 0

for transaction_date, group in grouped:

    year = transaction_date.strftime("%Y")
    month = transaction_date.strftime("%m")
    date_string = transaction_date.strftime("%Y-%m-%d")

    folder = (
        OUTPUT_DIR
        / year
        / month
    )

    folder.mkdir(
        parents=True,
        exist_ok=True
    )

    output_file = (
        folder
        / f"transactions_{date_string}.csv"
    )

    group = group.drop(
        columns=["transaction_date"]
    )

    group.to_csv(
        output_file,
        index=False
    )

    file_count += 1
    row_count += len(group)

    print(
        f"{date_string}: "
        f"{len(group):,} transactions"
    )

print("\n" + "=" * 60)
print("PARTITIONING COMPLETED")
print("=" * 60)

print(f"Files created: {file_count:,}")
print(f"Rows written:  {row_count:,}")