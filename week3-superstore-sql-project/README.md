# Superstore SQL Analytics — Week 3 Internship Assignment

## Debajyoti Bhakta _ SOA DU

**Topic:** Subqueries, CTEs, and Window Functions
**Goal:** Analyze Superstore sales data and answer real business questions about customer performance using progressively more advanced SQL techniques.

---

## A quick, honest note before anything else

The task pointed to the Kaggle Superstore dataset
(https://www.kaggle.com/datasets/vivek468/superstore-dataset-final). I built and ran this
project in a sandboxed environment that only has network access to package registries
(PyPI, npm, GitHub, etc.) — it cannot reach kaggle.com.

So instead of faking numbers, I generated a **synthetic dataset with the exact same
column structure** as the real Superstore file (`Order ID`, `Customer ID`, `Sales`,
`Profit`, `Discount`, `Category`, `Region`, etc. — see `scripts/generate_sample_data.py`
for exactly how it's built: 55 customers, 42 products, 520 order line-items across
307 orders, deliberately including repeat customers, one-time customers, and a mix of
profitable/loss-making orders, so the business questions actually have interesting
answers). Every query below ran for real against this data — nothing here is a mock-up.

**To use the real Kaggle CSV instead (recommended before submitting if you can download it):**
1. Download `Sample - Superstore.csv` from the link above.
2. Save it as `data/superstore.csv` (same file name, same columns).
3. Re-run `python3 scripts/run_analysis.py`.
No SQL needs to change — column names in the scripts already match the real dataset.

---

## Folder structure

```
superstore-sql-project/
│
├── data/
│   └── superstore.csv                 # Superstore-style dataset (see note above)
│
├── sql/
│   ├── 01_load_raw.sql                # staging table: superstore_raw
│   ├── 02_create_dimension_tables.sql # customers / products / orders via SELECT DISTINCT
│   ├── 03_subqueries.sql              # above-average sales, highest order per customer
│   ├── 04_ctes.sql                    # customer-level aggregation with CTEs
│   ├── 05_window_functions.sql        # ROW_NUMBER, RANK, DENSE_RANK, LAG, NTILE
│   └── 06_combined_customer_ranking.sql  # JOIN + CTE + window functions -> final business answers
│
├── scripts/
│   ├── generate_sample_data.py        # builds data/superstore.csv
│   └── run_analysis.py                # loads CSV -> SQLite, runs all SQL, saves results
│
├── outputs/
│   ├── superstore.db                  # the built SQLite database (generated)
│   └── query_results.md               # every query's actual output (generated)
│
└── README.md                          # this file
```

## How to run it yourself

```bash
cd superstore-sql-project
python3 scripts/generate_sample_data.py   # only needed if data/superstore.csv is missing
python3 scripts/run_analysis.py           # builds the DB, runs every SQL file, writes outputs/query_results.md
```

I used **SQLite** (via Python's built-in `sqlite3`) rather than installing MySQL/Postgres,
because it needs no server setup and fully supports CTEs and window functions
(`ROW_NUMBER`, `RANK`, `DENSE_RANK`, `LAG`, `NTILE`) since version 3.25. Every query in
`/sql` is standard ANSI SQL and will also run unmodified on MySQL 8+, PostgreSQL, or SQL
Server — I didn't use any SQLite-only syntax.

---

## What each SQL file does, and why I structured it that way

### `01_load_raw.sql` — the staging table
Creates `superstore_raw`, a flat table matching the CSV column-for-column. This is
intentionally "dirty" — one row per order line-item, with customer and product details
repeated on every row, exactly like the raw file. Nothing is cleaned yet; this table's
only job is to be a faithful landing zone for the CSV.

### `02_create_dimension_tables.sql` — normalizing with `SELECT DISTINCT`
From the flat raw table, I pulled out three cleaner tables:
- **`customers`** — one row per customer (`SELECT DISTINCT customer_id, customer_name, segment, region, ...`)
- **`products`** — one row per product
- **`orders`** — the fact table: order/line-item level records with foreign keys back to `customer_id` and `product_id`, but without repeating all the customer/product attributes

This is basic normalization. It matters here because without it, every aggregation later
(`SUM(sales) GROUP BY customer_id`) would still work, but the schema would be messier and
harder to reason about — and it's also just what the assignment explicitly asked for.

### `03_subqueries.sql` — Subqueries
- **Above-average sales**: a simple subquery in `WHERE` (`WHERE sales > (SELECT AVG(sales) FROM orders)`) to flag individual line-items that outperform the overall average.
- **Highest order per customer**: a **correlated subquery** — the inner query re-evaluates `MAX(sales)` separately for each customer, so we get each customer's personal best order.
- **Above-average customers**: a subquery on top of a subquery (aggregate total sales per customer, then compare each customer's total against the average of those totals). This one gets noticeably harder to read — which is exactly why CTEs exist, and I rebuilt it cleanly in the next file to make that contrast obvious.

### `04_ctes.sql` — CTEs
Same logic as above, rewritten with `WITH` blocks. The key building block here is
`customer_sales` — a CTE that aggregates `total_sales`, `total_profit`, `order_count`,
and `avg_order_value` per customer. This single CTE pattern gets reused across almost
every later query, which is the main point of CTEs: define the aggregation once,
reference it multiple times, keep the final `SELECT` readable.

### `05_window_functions.sql` — Window Functions
- **`ROW_NUMBER()` vs `RANK()` vs `DENSE_RANK()`** on order sales — shown side-by-side deliberately so the difference is visible whenever there's a tie (`ROW_NUMBER` never repeats or skips, `RANK` skips numbers after a tie, `DENSE_RANK` doesn't skip).
- **`PARTITION BY customer_id`** — ranks each customer's own orders independently instead of ranking globally.
- **`NTILE(4)`** — splits customers into spending quartiles.
- **`SUM() OVER (... ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)`** — a running total of each customer's cumulative spend over time.
- **`LAG()`** — compares each order to that same customer's previous order, to see if their spend is trending up or down.

### `06_combined_customer_ranking.sql` — the final deliverable
This is where JOINs, CTEs, and window functions come together to directly answer the
business questions the assignment asked for:
1. **Full customer ranking** — customer, total sales, `RANK()`
2. **Top 10 customers**
3. **Bottom 10 customers**
4. **Single-order customers** — one-time buyers, a useful re-engagement target list
5. **Above-average customers** — using `AVG(total_sales) OVER ()`, a window function, instead of a second query/self-join, to get the overall average alongside every row in one pass

---

## Key insights (from the actual run — see `outputs/query_results.md` for full output)

Dataset overview: **55 customers, 42 products, 307 distinct orders, 520 order line-items,
total sales ≈ $1,330,121.79**, average line-item sale ≈ $2,557.93.

1. **Sales are concentrated in a small group of customers.** The top customer,
   *David Martin*, generated **$62,470.59** across 14 orders — over 2.5x the average
   customer total of **$24,184.03**. Only **25 of 55 customers (≈45%)** are above that
   average; the other 55% sit below it, meaning nearly half of the customer base is
   underperforming relative to the mean, which is common in retail ("a few big spenders
   carry the average up"). This is a good argument for a loyalty/retention program aimed
   specifically at the top ~10 accounts, since they're disproportionately valuable.

2. **A small but real segment of customers never came back.** 4 customers
   (*Rahul Jackson, Mia Patel, Fatima Walker, Elena Thomas*) placed exactly one order
   each. Notably, one of them (*Rahul Jackson*) spent **$9,851.50** in that single order —
   a high-value customer who has not reordered. Following up with one-time high-spenders
   specifically (rather than treating all single-order customers the same) is likely the
   highest-leverage re-engagement move here.

3. **Technology drives revenue, but Furniture is nearly as profitable on far less
   volume.** By category: Technology = $722,924.52 sales / $58,565.04 profit (160
   line-items); Furniture = $459,002.43 sales / $56,658.52 profit (139 line-items);
   Office Supplies = $148,194.84 sales / $12,054.04 profit (221 line-items, the most
   line-items but the smallest profit pool). Furniture converts sales to profit noticeably
   more efficiently than Technology (a ~12.3% margin vs ~8.1%), which is worth knowing if
   the business is deciding where to invest marketing spend.

4. **High discounting shows up as negative profit at the customer level.** *David Thomas*
   ranks #3 overall by total sales ($55,051.43) but has a **negative total profit
   (-$1,226.60)** — a clear example of a customer who is high-revenue but low (or
   negative) value once discounting and margin are accounted for. Ranking by sales alone,
   as most of the "top customer" queries do by design, can hide this — which is why the
   combined-ranking query also surfaces `total_profit` next to `total_sales` rather than
   sales in isolation.

5. **Ties matter more than they seem.** In the order-level ranking query,
   `RANK()` and `DENSE_RANK()` diverge visibly whenever two orders have identical sales
   values — `RANK()` leaves a gap in the numbering after a tie while `DENSE_RANK()`
   doesn't. This is a small technical detail, but it changes downstream logic like
   "get me the top 10 by rank" if there are ties near the cutoff — `DENSE_RANK` may
   return more than 10 rows in that case, `RANK` may return fewer than expected.

---

## What I'd do with more time / real data

- Add a `date`-based cohort analysis (first purchase month → retention over time), which
  needs `DATE_TRUNC`/`strftime` plus window functions — natural next step after this project.
- Validate the "single-order customer" segment against recency (are they one-time
  buyers from 3 years ago, or from last month?) before deciding they're worth chasing.
- Re-run everything against the real Kaggle CSV (see note at the top) — the SQL logic
  won't change, only the numbers will.
