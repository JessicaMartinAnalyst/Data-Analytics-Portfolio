/* 01_kpi_baseline_compare.sql
   Purpose: Compare KPI totals between baseline (pre-change) and updated (post-change) datasets.
   Replace table names and KPI logic as needed.
*/

WITH baseline AS (
  SELECT
    DATE_TRUNC('month', service_date) AS month,
    SUM(allowed_amt) AS kpi_total
  FROM baseline_fact_table
  GROUP BY 1
),
updated AS (
  SELECT
    DATE_TRUNC('month', service_date) AS month,
    SUM(allowed_amt) AS kpi_total
  FROM updated_fact_table
  GROUP BY 1
)
SELECT
  COALESCE(b.month, u.month) AS month,
  b.kpi_total AS baseline_total,
  u.kpi_total AS updated_total,
  (u.kpi_total - b.kpi_total) AS variance,
  CASE
    WHEN b.kpi_total = 0 THEN NULL
    ELSE (u.kpi_total - b.kpi_total) / b.kpi_total
  END AS variance_pct
FROM baseline b
FULL OUTER JOIN updated u
  ON b.month = u.month
ORDER BY 1;
