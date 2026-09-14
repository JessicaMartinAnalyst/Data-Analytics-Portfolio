-- ============================================================================
-- Risk Score Degradation Gap — HCC Care Gap Identification
-- ============================================================================
-- Purpose: Identify members with an HCC code billed in the prior calendar
--          year but zero matching claims for that HCC cluster in the current
--          year, filtered to active enrollment only.
--
-- Approach: A CTE + window function replaces a self-join, which timed out
--           at this data volume. ROW_NUMBER() partitioned by member + HCC
--           code, ordered by service date descending, returns exactly one
--           row per member/condition combination — the most recent claim.
-- ============================================================================

WITH RankedClaims AS (
    SELECT
        member_id,
        hcc_code,
        service_date,
        ROW_NUMBER() OVER (
            PARTITION BY member_id, hcc_code
            ORDER BY service_date DESC
        ) AS rn
    FROM medical_claims
    WHERE service_date >= '2026-01-01'
      AND claim_status NOT IN ('reversed', 'denied')   -- compliance: exclude invalid claims
),

MostRecentClaimPerCondition AS (
    SELECT member_id, hcc_code, service_date
    FROM RankedClaims
    WHERE rn = 1
),

PriorYearHCCs AS (
    SELECT DISTINCT member_id, hcc_code
    FROM medical_claims
    WHERE service_date >= '2025-01-01'
      AND service_date <  '2026-01-01'
      AND claim_status NOT IN ('reversed', 'denied')
),

ActiveMembers AS (
    SELECT member_id
    FROM eligibility
    WHERE enrollment_status = 'active'
      AND measurement_year = 2026
)

-- Members with a prior-year HCC but no current-year claim for that same HCC,
-- restricted to members who are still actively enrolled.
SELECT
    p.member_id,
    p.hcc_code
FROM PriorYearHCCs p
JOIN ActiveMembers a
    ON p.member_id = a.member_id
LEFT JOIN MostRecentClaimPerCondition c
    ON p.member_id = c.member_id
   AND p.hcc_code  = c.hcc_code
WHERE c.member_id IS NULL;   -- no current-year claim exists = open gap
