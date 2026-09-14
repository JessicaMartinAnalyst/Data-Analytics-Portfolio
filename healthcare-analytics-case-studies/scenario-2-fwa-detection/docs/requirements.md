# Requirements Gathering & Team Communication

## The Business Rule Translation

I collaborated with clinical auditors and healthcare fraud investigators. They didn't ask for "a list of doctors" — they needed a **statistically rigorous, defensible threshold** for what constitutes an outlier. In an investigative and potentially legal context, a vague or subjective threshold isn't just imprecise — it's a liability, since it could result in a false accusation against a legitimate provider.

## Defining the Logic

I translated investigative leads into hard, numeric parameters:

- **Upcoding:** established a baseline distribution of Evaluation & Management (E&M) codes for a given provider specialty, and flagged providers billing significantly above that specialty-specific baseline.
- **Doctor shopping:** defined precisely as any patient filling opioid prescriptions from **3 or more distinct, unrelated providers** across **3 or more pharmacies**, within a **rolling 90-day window**.

That specificity — exact counts, exact windows — was the difference between an investigative lead and something that could actually be acted on or presented as evidence.

## Team Communication

Because the underlying data included sensitive claims and text files, I partnered with system administrators to securely ingest the data without compromising data privacy protocols — a constraint that shaped how (and where) the analysis could even be run.

## Why This Mattered

An investigator's intuition ("this looks suspicious") isn't something a query can execute. The real work was sitting with domain experts long enough to turn pattern-recognition into an explicit, defensible rule — one precise enough that another analyst, or an opposing expert in a legal proceeding, could reproduce the exact same result.
