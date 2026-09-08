from pathlib import Path
from datetime import datetime, timedelta
import csv
import random


# ============================================================
# CONFIGURATION
# ============================================================

ROWS_PER_DAY = 50_000
NUMBER_OF_DAYS = 7

START_DATE = datetime(2026, 9, 1)

NUMBER_OF_ACCOUNTS = 15_000
NUMBER_OF_CUSTOMERS = 10_000
NUMBER_OF_MERCHANTS = 5_000

# Reproducible results
random.seed(360)


# ============================================================
# PATHS
# ============================================================

PROJECT_ROOT = Path(__file__).resolve().parent.parent

OUTPUT_DIR = (
    PROJECT_ROOT
    / "data"
    / "transaction_daily_feed"
)

OUTPUT_DIR.mkdir(
    parents=True,
    exist_ok=True
)


# ============================================================
# REFERENCE DATA
# ============================================================

CITIES = [
    "Melbourne",
    "Sydney",
    "Brisbane",
    "Perth",
    "Adelaide"
]

TRANSACTION_TYPES = [
    "Purchase",
    "Transfer",
    "Withdrawal",
    "Deposit",
    "Bill Payment"
]

CURRENCIES = [
    "AUD",
    "USD",
    "NZD",
    "EUR",
    "GBP"
]

STATUSES = [
    "Success",
    "Success",
    "Success",
    "Success",
    "Failed"
]

PAYMENT_CHANNELS = [
    "Mobile",
    "Internet Banking",
    "ATM",
    "POS",
    "Branch"
]


# ============================================================
# DEVICE LOGIC
# ============================================================

def get_device_type(payment_channel):

    if payment_channel == "Mobile":
        return random.choice([
            "iPhone",
            "Android"
        ])

    if payment_channel == "Internet Banking":
        return random.choice([
            "Windows",
            "Mac"
        ])

    if payment_channel == "ATM":
        return "ATM"

    if payment_channel == "POS":
        return "POS"

    return "Branch Terminal"


# ============================================================
# IP ADDRESS
# ============================================================

def generate_ip_address():

    return (
        f"{random.randint(1, 223)}."
        f"{random.randint(0, 255)}."
        f"{random.randint(0, 255)}."
        f"{random.randint(1, 254)}"
    )


# ============================================================
# MAIN GENERATOR
# ============================================================

def generate_daily_feeds():

    transaction_counter = 1

    total_rows = 0

    print("=" * 70)
    print("FinBank360 - September Daily Transaction Feed Generator")
    print("=" * 70)

    print()
    print("Output directory:")
    print(OUTPUT_DIR)
    print()

    for day_offset in range(NUMBER_OF_DAYS):

        current_date = (
            START_DATE
            + timedelta(days=day_offset)
        )

        file_name = (
            f"transactions_"
            f"{current_date.strftime('%Y%m%d')}.csv"
        )

        output_file = (
            OUTPUT_DIR
            / file_name
        )

        with open(
            output_file,
            "w",
            newline="",
            encoding="utf-8"
        ) as file:

            writer = csv.writer(file)

            # Required Step 7.20 schema
            writer.writerow([
                "transaction_id",
                "account_id",
                "customer_id",
                "merchant_id",
                "transaction_timestamp",
                "transaction_type",
                "transaction_amount",
                "currency",
                "transaction_status",
                "payment_channel",
                "country",
                "city",
                "device_type",
                "ip_address"
            ])

            for _ in range(ROWS_PER_DAY):

                account_number = random.randint(
                    1,
                    NUMBER_OF_ACCOUNTS
                )

                # Consistent account → customer relationship
                customer_number = (
                    ((account_number - 1)
                     % NUMBER_OF_CUSTOMERS)
                    + 1
                )

                merchant_number = random.randint(
                    1,
                    NUMBER_OF_MERCHANTS
                )

                seconds = random.randint(
                    0,
                    86_399
                )

                timestamp = (
                    current_date
                    + timedelta(seconds=seconds)
                )

                payment_channel = random.choice(
                    PAYMENT_CHANNELS
                )

                device_type = get_device_type(
                    payment_channel
                )

                transaction_amount = round(
                    random.uniform(
                        1,
                        15_000
                    ),
                    2
                )

                writer.writerow([
                    f"T{transaction_counter:09d}",
                    f"A{account_number:06d}",
                    f"C{customer_number:06d}",
                    f"M{merchant_number:06d}",
                    timestamp.strftime(
                        "%Y-%m-%d %H:%M:%S"
                    ),
                    random.choice(
                        TRANSACTION_TYPES
                    ),
                    transaction_amount,
                    random.choice(
                        CURRENCIES
                    ),
                    random.choice(
                        STATUSES
                    ),
                    payment_channel,
                    "Australia",
                    random.choice(
                        CITIES
                    ),
                    device_type,
                    generate_ip_address()
                ])

                transaction_counter += 1

        total_rows += ROWS_PER_DAY

        print(
            f"Created {file_name}: "
            f"{ROWS_PER_DAY:,} transactions"
        )

    print()
    print("=" * 70)
    print("GENERATION COMPLETE")
    print(f"Files created: {NUMBER_OF_DAYS}")
    print(f"Total rows: {total_rows:,}")
    print("=" * 70)


if __name__ == "__main__":
    generate_daily_feeds()