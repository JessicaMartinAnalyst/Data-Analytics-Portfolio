/* 01_reconciliation_counts.sql
   Purpose: Source-to-target record count reconciliation overall and by month.
   Replace table/field names with your own schema.
*/

-- Overall record counts
SELECT 'SOURCE' AS dataset, COUNT(*) AS record_count
FROM source_table
UNION ALL
SELECT 'TARGET' AS dataset, COUNT(*) AS record_count
FROM target_table;

-- Record counts by month (example)
WITH src AS (
  SELECT DATE_TRUNC('month', service_date) AS svc_month, COUNT(*) AS src_cnt
  FROM source_table
  GROUP BY 1
),
tgt AS (
  SELECT DATE_TRUNC('month', service_date) AS svc_month, COUNT(*) AS tgt_cnt
  FROM target_table
  GROUP BY 1
)
SELECT
  COALESCE(src.svc_month, tgt.svc_month) AS svc_month,
  src.src_cnt,
  tgt.tgt_cnt,
  (src.src_cnt - tgt.tgt_cnt) AS variance
FROM src
FULL OUTER JOIN tgt
  ON src.svc_month = tgt.svc_month
ORDER BY 1;
