# Healthcare Data Analytics Portfolio

Two client-driven analytics projects from my work as a healthcare data analyst, documented end-to-end: the original stakeholder ask, requirements gathering, the SQL logic and technical pivot, governance/documentation practices, and the measured outcome.

Client names have been anonymized/generalized; the technical approach, logic, and methodology are unchanged.

## Projects

| Project | Domain | Core Problem | Stack |
|---|---|---|---|
| [Risk Score Degradation Gap](./scenario-1-risk-score-gap) | Value-Based Care / Risk Adjustment | Identifying Medicare Advantage patients with un-recaptured HCC codes before CMS's annual reporting deadline | SQL (CTEs, window functions), Power BI |
| [Fraud, Waste & Abuse Detection](./scenario-2-fwa-detection) | Healthcare Fraud Investigation | Isolating statistically defensible billing outliers (upcoding, doctor shopping, billing spikes) across millions of claims for a federal investigative team | SQL (window functions, statistical thresholds), Power BI / Tableau |

## How each project is documented

Every project folder follows the same structure, which mirrors how I actually approach client-driven analytics work:

1. **`README.md`** — the scenario, the client ask, and the outcome, at a glance
2. **`docs/requirements.md`** — how the ask was gathered and translated into a technical spec
3. **`docs/methodology.md`** — the data challenges, the technical pivot, and why the final approach was chosen over the first attempt
4. **`docs/data_dictionary.md`** — governance artifact: exact field/code definitions so the logic is auditable and reproducible by someone else
5. **`sql/`** — the actual query logic
6. **`sample_data/`** — synthetic data that makes the SQL runnable end-to-end, plus a `run_demo.py` script that executes the real query file (unmodified) and prints results

## Why this structure

Most portfolio repos show the final query. These show the *reasoning* behind it — what the client actually needed (not just what they asked for), where the first approach broke down, and what I built so someone else could trust, audit, and reuse the work after I moved on. That's the part of analytics work I find most valuable, and it's what these two projects are meant to demonstrate.

## Running the SQL yourself

Each project includes a `sample_data/` folder with fully synthetic data and a `run_demo.py` script. Both scripts execute the actual `.sql` file in that project's `sql/` folder — unmodified — against [DuckDB](https://duckdb.org/), so you can verify the logic actually works, not just read it.

```bash
pip install duckdb pandas
cd scenario-1-risk-score-gap && python3 sample_data/run_demo.py
cd ../scenario-2-fwa-detection && python3 sample_data/run_demo.py
```

---

*Note: All data in `sample_data/` is synthetic and randomly generated for demonstration purposes only. No real patient, provider, or claims data is included or reproduced in this repository.*
