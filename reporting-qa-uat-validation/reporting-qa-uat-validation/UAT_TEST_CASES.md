# UAT / Reporting QA Test Cases

## Scope
Validate that report outputs match business rules after changes to dataflows, ETL logic, or source systems.

## Test Cases

1. **KPI totals match baseline (pre vs post change)**
   - KPI(s):
   - Expected: Variance within threshold (e.g., ±0.5%)
   - Actual:
   - Pass/Fail:
   - Notes:

2. **KPI by key dimensions match baseline (month, plan, region, provider)**
   - Dimension(s):
   - Expected:
   - Actual:
   - Pass/Fail:
   - Notes:

3. **Filters / parameters return correct results**
   - Filter(s):
   - Expected:
   - Actual:
   - Pass/Fail:
   - Notes:

4. **Row-level detail ties to KPI totals**
   - Expected: Detail roll-up equals summary KPI
   - Actual:
   - Pass/Fail:
   - Notes:

5. **Null handling and default logic**
   - Expected: No unexpected null-driven changes in totals
   - Actual:
   - Pass/Fail:
   - Notes:

6. **Refresh / run stability**
   - Expected: Report refresh completes successfully; no missing periods
   - Actual:
   - Pass/Fail:
   - Notes:

## Sign-Off
- Tested by:
- Date:
- Overall Status:
- Risks / Open Items:
