# Sample Data (Synthetic)

This folder contains fully synthetic data generated to make the SQL in [`../sql/fwa_outlier_detection.sql`](../sql/fwa_outlier_detection.sql) runnable end-to-end. No real provider, patient, or claims data is used or represented.

## Files

| File | Rows | Description |
|---|---|---|
| `medicare_claims.csv` | ~1,100 | Synthetic billing claims across 48 providers in 4 specialties, with 3 injected statistical outliers and a handful of `reversed`/`adjustment` claims |
| `pharmacy_claims.csv` | ~72 | Synthetic opioid fill records across 30 patients, with 2 patients constructed to match the "doctor shopping" pattern |

## How the data was constructed

**Billing outlier detection:**
- 48 providers across 4 specialties (family medicine, cardiology, orthopedics, pain management), each with a normally-distributed billing pattern around a specialty-typical baseline
- 3 providers are deliberately injected with billing 4.5–6.5x their specialty peer average — these are the "planted" fraud signal the query should catch
- 8 additional claims are injected at 8-10x baseline but marked `reversed`/`adjustment`, specifically to confirm the query's exclusion logic works — if these leaked into the outlier calculation, the peer averages would be skewed and legitimate providers could get falsely flagged

**Doctor shopping detection:**
- 30 patients with normal opioid fill patterns (1-3 fills, single prescriber/pharmacy)
- 2 patients ("P0031", "P0032") are deliberately constructed with fills across 4+ distinct prescribers and 4+ distinct pharmacies within a 90-day window — these should be exactly what the query flags

## How to run it

```python
import duckdb

con = duckdb.connect()
con.execute("CREATE TABLE medicare_claims AS SELECT * FROM read_csv_auto('sample_data/medicare_claims.csv')")
con.execute("CREATE TABLE pharmacy_claims AS SELECT * FROM read_csv_auto('sample_data/pharmacy_claims.csv')")

# the SQL file contains two separate queries (outlier detection, then doctor shopping)
# run_demo.py in this folder runs both and prints results
```

Or just run `run_demo.py` directly, which executes both queries in the SQL file exactly as written and prints the results.

**Expected result:** the 3 injected outlier NPIs are flagged in billing outlier detection (and only those, since the reversed/adjustment claims are correctly excluded), and patients P0031 / P0032 are flagged in doctor shopping detection.
