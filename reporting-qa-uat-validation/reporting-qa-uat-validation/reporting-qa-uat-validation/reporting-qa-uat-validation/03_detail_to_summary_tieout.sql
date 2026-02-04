/* 03_detail_to_summary_tieout.sql
   Purpose: Validate that row-level detail rolls up to the summary KPI shown on the report/dashboard.
*/

WITH detail_rollup AS (
  SELECT
    DATE_TRUNC('month', service_date) AS month,
    SUM(allowed_amt) AS detail_total
  FROM updated_detail_table
  GROUP BY 1
),
summary AS (
  SELECT
    month,
    kpi_total AS summary_total
  FROM updated_summary_table
)
SELECT
  COALESCE(d.month, s.month) AS month,
  d.detail_total,
  s.summary_total,
  (d.detail_total - s.summary_total) AS variance
FROM detail_rollup d
FULL OUTER JOIN summary s
  ON d.month = s.month
ORDER BY 1;
