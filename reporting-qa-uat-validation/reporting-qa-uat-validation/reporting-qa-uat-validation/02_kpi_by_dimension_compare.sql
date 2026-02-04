/* 02_kpi_by_dimension_compare.sql
   Purpose: Compare KPIs by a key dimension (plan/region/provider) to ensure business logic consistency.
*/

WITH baseline AS (
  SELECT
    plan_id,
    DATE_TRUNC('month', service_date) AS month,
    COUNT(*) AS claim_cnt,
    SUM(allowed_amt) AS allowed_total
  FROM baseline_fact_table
  GROUP BY 1,2
),
updated AS (
  SELECT
    plan_id,
    DATE_TRUNC('month', service_date) AS month,
    COUNT(*) AS claim_cnt,
    SUM(allowed_amt) AS allowed_total
  FROM updated_fact_table
  GROUP BY 1,2
)
SELECT
  COALESCE(b.plan_id, u.plan_id) AS plan_id,
  COALESCE(b.month, u.month) AS month,
  b.claim_cnt AS baseline_claim_cnt,
  u.claim_cnt AS updated_claim_cnt,
  (u.claim_cnt - b.claim_cnt) AS claim_cnt_variance,
  b.allowed_total AS baseline_allowed_total,
  u.allowed_total AS updated_allowed_total,
  (u.allowed_total - b.allowed_total) AS allowed_variance
FROM baseline b
FULL OUTER JOIN updated u
  ON b.plan_id = u.plan_id AND b.month = u.month
ORDER BY plan_id, month;

