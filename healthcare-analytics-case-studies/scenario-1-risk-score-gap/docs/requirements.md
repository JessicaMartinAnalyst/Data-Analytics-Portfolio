# Requirements Gathering & Team Communication

## The Business Rule Translation

I met with the plan's Risk Adjustment Coding compliance leads and the Payer Contract Director. The initial framing of the request was simply "find patients with care gaps" — but in that meeting, it became clear they didn't need a list of everyone who might be at risk. They needed patients **prioritized by financial and clinical impact**, since the care coordination team could only reach a fraction of the full population before the reporting deadline.

That one clarifying conversation changed the entire technical approach — from "flag everyone" to "rank by impact."

## Defining the Logic

I translated the business ask into a precise, testable technical schema:

> Find members who had a specific HCC code billed in the **prior** calendar year, but have **zero claims** containing that same HCC cluster in the **current** calendar year — filtered strictly to members in an **active enrollment** status.

Getting to a one-sentence, unambiguous rule like this was the signal that I had enough to start building. Anything short of this specificity would have produced a list that reasonable people could disagree about.

## Data Pipeline Collaboration

I partnered with data engineering to ensure the reference tables mapping ICD-10 codes to CMS HCC categories were updated dynamically rather than hardcoded — CMS updates its risk model periodically (e.g., v24 → v28), and a static crosswalk would have silently gone stale.

## Why This Mattered

Without this requirements-gathering step, the deliverable would have been technically correct but operationally useless — a spreadsheet of 50,000+ names that no care coordination team could act on. The real work was translating a vague, well-intentioned ask into something a downstream team could actually execute against.
