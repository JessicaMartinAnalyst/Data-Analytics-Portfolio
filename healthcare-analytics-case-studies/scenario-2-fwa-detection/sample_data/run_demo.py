"""
Runs the actual fwa_outlier_detection.sql queries against the synthetic
sample data in this folder, using DuckDB. No modifications are made to
the SQL file -- this demonstrates it runs as-is.

The SQL file contains two separate queries (billing outlier detection,
then doctor shopping detection), split on the "Doctor Shopping Detection"
section comment.

Usage:
    pip install duckdb pandas
    python sample_data/run_demo.py
(run from the scenario-2-fwa-detection/ directory)
"""
import os
import duckdb

BASE = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

con = duckdb.connect()
con.execute(f"CREATE TABLE medicare_claims AS SELECT * FROM read_csv_auto('{BASE}/sample_data/medicare_claims.csv')")
con.execute(f"CREATE TABLE pharmacy_claims AS SELECT * FROM read_csv_auto('{BASE}/sample_data/pharmacy_claims.csv')")

with open(f"{BASE}/sql/fwa_outlier_detection.sql") as f:
    full_sql = f.read()

marker = "Doctor Shopping Detection"
outlier_sql = full_sql.split(marker)[0]
shopping_sql = full_sql[full_sql.index("WITH", full_sql.index(marker)):]

print("=== Billing Outlier Detection ===")
outlier_result = con.execute(outlier_sql).fetchdf()
print(f"Providers flagged: {outlier_result['npi'].nunique()} (unique NPIs)\n")
print(outlier_result.head(10).to_string(index=False))

print("\n=== Doctor Shopping Detection ===")
shopping_result = con.execute(shopping_sql).fetchdf()
print(f"Patients flagged: {shopping_result['patient_id'].nunique()}\n")
print(shopping_result.to_string(index=False))
