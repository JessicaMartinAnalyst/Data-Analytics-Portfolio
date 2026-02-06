# Outbound Encounter Transmission Monitoring (SQL)


## Overview
This project provides a SQL Server–based monitoring and QA framework for outbound healthcare encounter transmissions. It tracks files sent to external receivers (e.g., EDSCMS), measures acceptance and rejection outcomes, and identifies transmissions that are pending acknowledgment.


## Business Problem
Outbound encounter files may be sent successfully but never acknowledged by the receiving system. Without monitoring, these failures can go unnoticed, leading to reconciliation issues, delayed processing, and compliance risk.


## Solution
Using T-SQL and Common Table Expressions (CTEs), this project:
- Builds a clean base dataset of outbound encounter transmissions
- Produces file-level acceptance metrics
- Flags files pending acknowledgment
- Audits encounters that were sent but not marked as received


## Disposition Codes
- Accepted: 01
- Rejected: 02
- Pending Acknowledgment: 03


## Tech Stack
- SQL Server (T-SQL)
- CTE-based query design
- Operational QA and audit logic


## How to Use
Run the SQL scripts in numerical order. Each script builds on the same core logic but serves a different operational purpose.


## Notes
All data shown in sample outputs is mock data. No PHI is included.
