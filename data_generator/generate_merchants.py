"""
FinBank360 - Merchant Data Generator

Generates synthetic merchant data for the FinBank360
Azure Data Engineering portfolio project.

Output:
    data/merchants/merchants.csv

Records:
    5,000 merchants
"""

from pathlib import Path
import csv
import random


# ============================================================
# 1. CONFIGURATION
# ============================================================

# Fixed seed makes the generated dataset reproducible.
random.seed(360)

NUMBER_OF_MERCHANTS = 5000


# ============================================================
# 2. PROJECT PATHS
# ============================================================

# Current script:
# finance-data-engineering/data_generator/generate_merchants.py
#
# parent.parent gives:
# finance-data-engineering/

PROJECT_ROOT = Path(__file__).resolve().parent.parent

OUTPUT_DIR = PROJECT_ROOT / "data" / "merchants"

OUTPUT_FILE = OUTPUT_DIR / "merchants.csv"

# Create the directory if it does not already exist.
OUTPUT_DIR.mkdir(parents=True, exist_ok=True)


# ============================================================
# 3. MERCHANT CATEGORIES
# ============================================================

MERCHANT_CATEGORIES = [
    "Retail",
    "Groceries",
    "Restaurants",
    "Travel",
    "Hotels",
    "Fuel",
    "Utilities",
    "Entertainment",
    "Healthcare",
    "Education",
    "Electronics",
    "Ecommerce",
    "Insurance",
    "Telecommunications",
    "Transportation",
    "Gambling",
    "Cryptocurrency",
    "Money Transfer"
]


# ============================================================
# 4. COUNTRIES
# ============================================================

COUNTRIES = [
    "Australia",
    "New Zealand",
    "United States",
    "United Kingdom",
    "Singapore",
    "India",
    "Japan"
]

# Most merchants are Australian because FinBank360
# represents an Australian banking environment.

COUNTRY_WEIGHTS = [
    75,  # Australia
    5,   # New Zealand
    5,   # United States
    5,   # United Kingdom
    3,   # Singapore
    4,   # India
    3    # Japan
]


# ============================================================
# 5. MERCHANT RISK GROUPS
# ============================================================

LOW_RISK_CATEGORIES = {
    "Retail",
    "Groceries",
    "Restaurants",
    "Fuel",
    "Utilities",
    "Healthcare",
    "Education",
    "Telecommunications"
}

MEDIUM_RISK_CATEGORIES = {
    "Travel",
    "Hotels",
    "Entertainment",
    "Electronics",
    "Ecommerce",
    "Insurance",
    "Transportation"
}

HIGH_RISK_CATEGORIES = {
    "Gambling",
    "Cryptocurrency",
    "Money Transfer"
}


# ============================================================
# 6. DETERMINE MERCHANT RISK
# ============================================================

def determine_risk(category):
    """
    Assign a risk category based on merchant category.

    High-risk industries have a greater probability of
    receiving a High risk classification.

    Medium-risk industries mostly receive Medium or Low.

    Low-risk industries mostly receive Low.
    """

    if category in HIGH_RISK_CATEGORIES:

        return random.choices(
            ["Low", "Medium", "High"],
            weights=[10, 30, 60],
            k=1
        )[0]

    elif category in MEDIUM_RISK_CATEGORIES:

        return random.choices(
            ["Low", "Medium", "High"],
            weights=[45, 45, 10],
            k=1
        )[0]

    else:

        return random.choices(
            ["Low", "Medium", "High"],
            weights=[80, 17, 3],
            k=1
        )[0]


# ============================================================
# 7. GENERATE MERCHANT DATA
# ============================================================

def generate_merchants():
    """
    Generate merchants.csv containing 5,000 merchant records.
    """

    with open(
        OUTPUT_FILE,
        "w",
        newline="",
        encoding="utf-8"
    ) as file:

        writer = csv.writer(file)

        # ----------------------------------------------------
        # CSV HEADER
        # ----------------------------------------------------

        writer.writerow([
            "merchant_id",
            "merchant_name",
            "merchant_category",
            "country",
            "risk_category"
        ])

        # ----------------------------------------------------
        # GENERATE MERCHANT RECORDS
        # ----------------------------------------------------

        for i in range(1, NUMBER_OF_MERCHANTS + 1):

            # Example:
            # 1    -> M000001
            # 100  -> M000100
            # 5000 -> M005000

            merchant_id = f"M{i:06d}"

            merchant_name = f"Merchant {i}"

            merchant_category = random.choice(
                MERCHANT_CATEGORIES
            )

            country = random.choices(
                COUNTRIES,
                weights=COUNTRY_WEIGHTS,
                k=1
            )[0]

            risk_category = determine_risk(
                merchant_category
            )

            writer.writerow([
                merchant_id,
                merchant_name,
                merchant_category,
                country,
                risk_category
            ])


# ============================================================
# 8. MAIN
# ============================================================

if __name__ == "__main__":

    print("=" * 60)
    print("FinBank360 - Merchant Data Generator")
    print("=" * 60)

    generate_merchants()

    print()
    print(
        f"SUCCESS: merchants.csv created with "
        f"{NUMBER_OF_MERCHANTS:,} merchants."
    )

    print()
    print(f"Output file:")
    print(OUTPUT_FILE)

    print()
    print("=" * 60)