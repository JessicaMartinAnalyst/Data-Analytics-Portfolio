# Managing Data Complexity & the Technical Pivot

## The Data Mess

The source data spanned raw medical claims, pharmacy claims, and eligibility files pulled from an enterprise data warehouse. Two problems surfaced immediately:

1. **Scale** — the row volume was large enough that a traditional self-join approach (joining the claims table to itself to compare current-year vs. prior-year HCC billing) caused queries to time out.
2. **Duplication** — a single patient could have dozens of claims for the same condition across the year, but only the most recent visit status was relevant to determine whether the gap was still open.

## The SQL Solution

Rather than a self-join, I used a **Common Table Expression (CTE)** combined with a **window function** (`ROW_NUMBER() OVER (PARTITION BY member_id, hcc_code ORDER BY service_date DESC)`) to compute, in a single pass, the most recent claim per member per HCC code. This avoided the join-multiplication problem entirely and ran in a fraction of the time.

See [`sql/risk_gap_identification.sql`](../sql/risk_gap_identification.sql) for the full query.

## The Analytical Pivot

My first version of this logic simply flagged **every** patient with an un-coded gap. In practice, this produced a list of roughly 50,000 patients — far more than the care coordination team could act on before the reporting deadline.

I pivoted the approach to calculate a **"Suspected Risk Score Delta"**: using historical pharmacy fill data as a secondary signal (e.g., a member actively filling metformin prescriptions but with no corresponding diabetes ICD-10 claim in the current year), I could estimate which gaps represented the highest financial and clinical risk. This let the team sort and triage the list by impact instead of treating every gap as equally urgent.

**The lesson:** the right answer to "too much data to act on" usually isn't more filtering — it's a smarter prioritization signal that makes the output usable by the people who have to act on it.
