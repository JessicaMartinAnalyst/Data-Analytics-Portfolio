/* 03_field_level_comparison.sql
   Purpose: Compare key fields between source and target to validate mapping and business logic.
   Assumes a common business key exists in both tables (e.g., claim_id or encounter_id).
*/

WITH joined AS (
  SELECT
    s.business_key,
    s.member_id     AS src_member_id,
    t.member_id     AS tgt_member_id,
    s.cpt_code      AS src_cpt_code,
    t.cpt_code      AS tgt_cpt_code,
    s.icd_code      AS src_icd_code,
    t.icd_code      AS tgt_icd_code,
    s.allowed_amt   AS src_allowed_amt,
    t.allowed_amt   AS tgt_allowed_amt
  FROM source_table s
  INNER JOIN target_table t
    ON s.business_key = t.business_key
)
SELECT *
FROM joined
WHERE
  (src_member_id <> tgt_member_id OR (src_member_id IS NULL) <> (tgt_member_id IS NULL))
  OR (src_cpt_code <> tgt_cpt_code OR (src_cpt_code IS NULL) <> (tgt_cpt_code IS NULL))
  OR (src_icd_code <> tgt_icd_code OR (src_icd_code IS NULL) <> (tgt_icd_code IS NULL))
  OR (src_allowed_amt <> tgt_allowed_amt OR (src_allowed_amt IS NULL) <> (tgt_allowed_amt IS NULL))
LIMIT 200;
