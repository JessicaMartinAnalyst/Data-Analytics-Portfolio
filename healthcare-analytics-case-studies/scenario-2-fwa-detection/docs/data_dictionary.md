# Data Dictionary & Methodology Log — FWA Detection

Because findings from this analysis were used to support federal investigative proceedings, this documentation had to be legally bulletproof — detailing every data exclusion rule and code definition so the logic could withstand intense legal and technical scrutiny, including reproduction by an independent analyst or opposing expert.

## Core Fields

| Field | Definition |
|---|---|
| `npi` | National Provider Identifier — unique identifier for a billing provider |
| `specialty` | Provider's billing specialty, used as the peer-comparison group for outlier detection |
| `billing_date` | Date associated with the billed claim line |
| `total_claimed_amount` | Total dollar amount claimed on a given billing date |
| `peer_avg` / `peer_stddev` | Mean and standard deviation of `total_claimed_amount` within the provider's specialty peer group |

## Code Ranges

| Category | Definition |
|---|---|
| **CPT codes (E&M levels)** | Exact Evaluation & Management code ranges used to establish the baseline billing-level distribution per specialty, for upcoding detection |
| **NDC codes (controlled substances)** | Exact National Drug Code ranges for controlled pain medications, used in the doctor-shopping detection logic |

## Exclusion Rules (Methodology Log)

To prevent false accusations, the following were explicitly excluded from outlier calculations:

- **Legitimate claim adjustments** — a provider correcting their own prior billing error should not be flagged as anomalous behavior
- **Reversals** — claims that were submitted and later reversed do not reflect actual billed/paid amounts and are excluded from both the peer baseline and the outlier calculation

Every exclusion rule is logged with its rationale, so that a reviewer — legal, technical, or investigative — can independently verify that the outlier list reflects genuine anomalies rather than an artifact of unfiltered data.

## "Doctor Shopping" Definition (Exact Parameters)

A patient meets the doctor-shopping criteria if all of the following hold within a rolling 90-day window:
- 3 or more **distinct, unrelated** prescribing providers
- Controlled substance (opioid) prescriptions
- Filled across 3 or more **distinct pharmacies**
