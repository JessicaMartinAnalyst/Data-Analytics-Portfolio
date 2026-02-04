/* 02_completeness_and_duplicates.sql
   Purpose: Validate completeness (nulls/blanks) and detect duplicates on key fields.
*/

-- Completeness checks (update required fields)
SELECT
  SUM(CASE WHEN member_id IS NULL THEN 1 ELSE 0 END) AS null_member_id,
  SUM(CASE WHEN provider_id IS NULL THEN 1 ELSE 0 END) AS null_provider_id,
  SUM(CASE WHEN service_date IS NULL THEN 1 ELSE 0 END) AS null_service_date
FROM target_table;

-- Duplicate check (example unique key)
SELECT
  member_id,
  provider_id,
  service_date,
  COUNT(*) AS dup_count
FROM target_table
GROUP BY member_id, provider_id, service_date
HAVING COUNT(*) > 1
ORDER BY dup_count DESC;
