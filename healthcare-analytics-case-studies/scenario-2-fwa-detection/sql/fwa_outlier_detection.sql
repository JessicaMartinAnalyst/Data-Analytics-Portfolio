-- ============================================================================
-- Healthcare Fraud, Waste & Abuse — Billing Outlier Detection
-- ============================================================================
-- Purpose: Flag providers whose billing significantly exceeds their
--          specialty peer group, using a Z-score-style statistical
--          threshold rather than a raw absolute-dollar cutoff.
--
-- Approach: Window functions compute peer-group mean and standard
--           deviation per specialty without collapsing row-level detail.
--           A provider is flagged only if their billed amount exceeds
--           3 standard deviations above their specialty peer average --
--           a threshold chosen to minimize false positives given the
--           legal context of this analysis.
-- ============================================================================

WITH CleanClaims AS (
    SELECT *
    FROM medicare_claims
    WHERE billing_date >= '2025-01-01'
      AND claim_status NOT IN ('reversed', 'adjustment')   -- exclude per methodology log
),

ProviderMetrics AS (
    SELECT
        npi,
        specialty,
        billing_date,
        total_claimed_amount,
        AVG(total_claimed_amount)
            OVER (PARTITION BY specialty) AS peer_avg,
        STDDEV(total_claimed_amount)
            OVER (PARTITION BY specialty) AS peer_stddev
    FROM CleanClaims
)

SELECT
    npi,
    billing_date,
    total_claimed_amount,
    peer_avg,
    peer_stddev,
    (total_claimed_amount - peer_avg) / NULLIF(peer_stddev, 0) AS z_score
FROM ProviderMetrics
WHERE total_claimed_amount > (peer_avg + (3 * peer_stddev))
ORDER BY z_score DESC;


-- ============================================================================
-- Doctor Shopping Detection
-- ============================================================================
-- Flags patients filling opioid prescriptions from 3+ distinct, unrelated
-- providers across 3+ distinct pharmacies within a rolling 90-day window.
-- ============================================================================

WITH OpioidFills AS (
    SELECT
        patient_id,
        prescriber_npi,
        pharmacy_id,
        fill_date
    FROM pharmacy_claims
    WHERE drug_class = 'opioid'
),

RollingWindowCounts AS (
    SELECT
        a.patient_id,
        a.fill_date AS window_start,
        COUNT(DISTINCT b.prescriber_npi) AS distinct_prescribers,
        COUNT(DISTINCT b.pharmacy_id)    AS distinct_pharmacies
    FROM OpioidFills a
    JOIN OpioidFills b
        ON a.patient_id = b.patient_id
       AND b.fill_date BETWEEN a.fill_date AND a.fill_date + INTERVAL '90 days'
    GROUP BY a.patient_id, a.fill_date
)

SELECT patient_id, window_start, distinct_prescribers, distinct_pharmacies
FROM RollingWindowCounts
WHERE distinct_prescribers >= 3
  AND distinct_pharmacies  >= 3;
