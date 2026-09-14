# Sample Data (Synthetic)

This folder contains fully synthetic data generated to make the SQL in [`../sql/risk_gap_identification.sql`](../sql/risk_gap_identification.sql) runnable end-to-end. No real patient, member, or claims data is used or represented.

## Files

| File | Rows | Description |
|---|---|---|
| `medical_claims.csv` | ~90 | Synthetic claim lines across 40 members, 2025–2026, including a few `reversed`/`denied` claims to demonstrate the query's exclusion logic |
| `eligibility.csv` | 40 | Synthetic enrollment status per member |

## How the data was constructed

- Each member has 1–2 chronic conditions (HCC codes) established with a claim in the prior year (2025)
- ~55% of those conditions get "re-coded" with a matching claim in the current year (2026) — these should **not** be flagged as gaps
- The remaining ~45% have no current-year claim — these **should** be flagged as open gaps
- A handful of `reversed`/`denied` claims are injected specifically to confirm the query correctly excludes them
- ~10% of members are marked `inactive` in eligibility, to confirm the query correctly excludes disenrolled members

## How to run it

Using [DuckDB](https://duckdb.org/) (no install required beyond `pip install duckdb`):

```python
import duckdb

con = duckdb.connect()
con.execute("CREATE TABLE medical_claims AS SELECT * FROM read_csv_auto('sample_data/medical_claims.csv')")
con.execute("CREATE TABLE eligibility AS SELECT * FROM read_csv_auto('sample_data/eligibility.csv')")

sql = open('sql/risk_gap_identification.sql').read()
result = con.execute(sql).fetchdf()
print(result)
```

Or use `run_demo.py` in this folder, which does exactly this and prints the flagged gap list.

**Expected result:** roughly 20 open care gaps flagged, matching the ~45% "no current-year re-code" rate the synthetic data was built with.
