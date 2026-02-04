-- Source-to-target reconciliation: record counts by month
WITH src AS (
  SELECT DATE_TRUNC('month', service_date) AS svc_month, COUNT(*) AS src_cnt
  FROM source_encounters
  GROUP BY 1
),
tgt AS (
  SELECT DATE_TRUNC('month', service_date) AS svc_month, COUNT(*) AS tgt_cnt
  FROM target_encounters
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
