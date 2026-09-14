# Resolving the "Risk Score Degradation" Gap

**Domain:** Value-Based Care / CMS Risk Adjustment
**Client:** Operations & Finance leadership at a regional Medicare Advantage health plan
**Role:** Sole analyst — requirements gathering through delivered dashboard

## The Problem

Medicare Advantage risk scores reset to a baseline every January 1st. If a chronic-condition patient (e.g., COPD, Type 2 Diabetes) isn't seen and coded for that exact HCC (Hierarchical Condition Category) within the current calendar year, CMS funding for that patient drops the following year — even though the patient's underlying health hasn't changed.

The plan's operations team had raw medical claims but no systematic way to identify which high-risk patients had un-submitted or un-captured HCC codes before the year-end reporting deadline.

## The Ask, As It Actually Came In

The initial request was informal: *"Help us find patients who might have care gaps."* Left as-is, that request would have produced an unusable list of tens of thousands of patients. See [`docs/requirements.md`](./docs/requirements.md) for how this got translated into a technical spec that care teams could actually act on.

## What I Built

- SQL logic (CTE + window function) to identify members with a prior-year HCC code and zero matching claims in the current year, filtered to active enrollment
- A "Suspected Risk Score Delta" model using pharmacy fill data as a secondary signal, to prioritize the list by financial/clinical impact rather than flagging every gap equally
- A monthly-refreshed Power BI dashboard for regional provider network managers
- A data dictionary and compliance audit trail, since risk adjustment submissions are subject to CMS audit

## Outcome

**12%** of the suspected cohort had closed clinical care gaps before the end-of-year CMS reporting deadline — capturing appropriate risk-adjusted funding that would otherwise have been lost, and improving preventative care outreach for a genuinely high-risk patient population.

## Contents

- [`docs/requirements.md`](./docs/requirements.md) — how the ask was scoped
- [`docs/methodology.md`](./docs/methodology.md) — the data challenges and the technical pivot
- [`docs/data_dictionary.md`](./docs/data_dictionary.md) — field and logic definitions
- [`sql/risk_gap_identification.sql`](./sql/risk_gap_identification.sql) — the core query logic
- [`sample_data/`](./sample_data) — synthetic data + `run_demo.py` to run the query end-to-end
