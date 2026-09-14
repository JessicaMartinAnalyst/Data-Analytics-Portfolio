# Managing Data Complexity & the Technical Pivot

## The Data Mess

The analysis worked against unaggregated, multi-year claims records containing millions of line items. Detecting patterns like "billing spikes" or "duplicate billing" required comparing records against themselves across varying time horizons — a fundamentally different problem than a simple point-in-time lookup.

## The SQL Solution

I used **window functions** to compute rolling and peer-relative statistics without collapsing the underlying row-level detail. Specifically, `AVG() OVER (PARTITION BY specialty)` and `STDDEV() OVER (PARTITION BY specialty)` compute a peer-group mean and standard deviation for each provider's specialty, then flag any provider whose billing exceeds **3 standard deviations** above their specialty peer average.

See [`sql/fwa_outlier_detection.sql`](../sql/fwa_outlier_detection.sql) for the full query.

**Why 3 standard deviations, not 2?** In a normal distribution, 2 SD still flags roughly 5% of entirely normal behavior as anomalous — far too many false positives at this data volume, and especially costly given the legal context. 3 SD (~0.3%) is a standard statistical convention for "genuinely rare," and a stricter threshold protects against false accusations against legitimate providers.

## The Analytical Pivot

My first version of this logic flagged any provider with a high absolute billing day. In practice, this meant a legitimately busy, high-volume clinic looked statistically identical to a fraudulent one — both would show high total billed amounts.

I pivoted to introduce **Z-score normalization**, adjusting for total patient panel size before comparing providers. This isolates true behavioral anomalies — billing that's unusual *relative to how many patients a provider actually sees* — rather than simply flagging busy practices.

**The lesson:** raw thresholds break down at scale because "high" is meaningless without a relevant peer comparison. Normalizing against the right peer group is what turns a noisy signal into an actionable one.
