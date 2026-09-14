"""
Runs the actual risk_gap_identification.sql query against the synthetic
sample data in this folder, using DuckDB. No modifications are made to
the SQL file -- this demonstrates it runs as-is.

Usage:
    pip install duckdb pandas
    python sample_data/run_demo.py
(run from the scenario-1-risk-score-gap/ directory)
"""
import os
import duckdb

BASE = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

con = duckdb.connect()
con.execute(f"CREATE TABLE medical_claims AS SELECT * FROM read_csv_auto('{BASE}/sample_data/medical_claims.csv')")
con.execute(f"CREATE TABLE eligibility AS SELECT * FROM read_csv_auto('{BASE}/sample_data/eligibility.csv')")

with open(f"{BASE}/sql/risk_gap_identification.sql") as f:
    sql = f.read()

result = con.execute(sql).fetchdf()

print(f"Open care gaps identified: {len(result)}\n")
print(result.to_string(index=False))
