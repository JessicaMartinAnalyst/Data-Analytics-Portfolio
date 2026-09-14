# Data Dictionary — Risk Score Degradation Gap

Governance artifact documenting field definitions and calculation logic, since risk adjustment submissions are subject to CMS audit and this logic needs to be reproducible and defensible by someone other than the original author.

## Core Fields

| Field | Definition |
|---|---|
| `member_id` | Unique identifier for a health plan member |
| `hcc_code` | CMS Hierarchical Condition Category code, derived from the ICD-10 → HCC crosswalk (updated per CMS risk model version, e.g., v24 → v28) |
| `service_date` | Date of service on the underlying claim line |
| `active_membership_months` | Calculated field — see below |

## Calculated Logic

### `active_membership_months`
Defined as the count of calendar months in the measurement year during which the member had **active enrollment status** with the plan. This calculation exists specifically to avoid penalizing a clinician's recertification rate for a member who had already left the plan — without it, a provider could appear to have a low code-recapture rate simply because their patient disenrolled, not because of any gap in care.

### Prior-Year HCC Billing
A member is considered to have a "prior-year HCC" if a claim in the measurement year immediately preceding the current one contains a diagnosis code that maps to the HCC cluster in question, per the active CMS risk model version's ICD-10 → HCC crosswalk.

### Current-Year Gap
A member has an **open gap** for a given HCC cluster if there is no claim in the current calendar year containing a diagnosis code mapping to that same HCC cluster, while the member remains in active enrollment status.

## Compliance Verification

Because Risk Adjustment submissions are heavily audited by CMS, the underlying query logic explicitly excludes:
- Reversed claims
- Denied claims

This ensures the audit trail reflects only valid, adjudicated claims data — not claims that were submitted but never paid or later reversed.
