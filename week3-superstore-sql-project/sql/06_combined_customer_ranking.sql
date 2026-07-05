-- ============================================================
-- 06_combined_customer_ranking.sql
-- Purpose: This is the "final result" script -- it combines
--          JOINs + CTEs + Window Functions to answer every
--          business question asked in the assignment:
--            (a) full customer sales ranking (customer, total
--                sales, rank)
--            (b) top N customers
--            (c) bottom N customers
--            (d) single-order customers
--            (e) above-average customers
-- ============================================================

-- ------------------------------------------------------------
-- MASTER CTE: customer_ranked
-- Joins orders -> customers, aggregates to customer level,
-- then ranks with window functions. Every query below just
-- filters/reads from this one CTE.
-- ------------------------------------------------------------
WITH customer_sales AS (
    SELECT
        c.customer_id,
        c.customer_name,
        c.segment,
        c.region,
        SUM(o.sales)                 AS total_sales,
        SUM(o.profit)                AS total_profit,
        COUNT(DISTINCT o.order_id)   AS order_count,
        ROUND(AVG(o.sales), 2)       AS avg_order_value
    FROM orders o
    JOIN customers c ON c.customer_id = o.customer_id
    GROUP BY c.customer_id, c.customer_name, c.segment, c.region
),
overall_avg AS (
    SELECT AVG(total_sales) AS avg_customer_sales
    FROM customer_sales
),
customer_ranked AS (
    SELECT
        cs.*,
        oa.avg_customer_sales,
        RANK()       OVER (ORDER BY cs.total_sales DESC) AS sales_rank,
        DENSE_RANK() OVER (ORDER BY cs.total_sales DESC) AS sales_dense_rank,
        ROW_NUMBER() OVER (ORDER BY cs.total_sales DESC) AS sales_row_num,
        CASE
            WHEN cs.total_sales > oa.avg_customer_sales THEN 'Above Average'
            ELSE 'At or Below Average'
        END AS vs_average_flag
    FROM customer_sales cs
    CROSS JOIN overall_avg oa
)

-- ---- (a) FULL RANKING: customer, total sales, rank ----
SELECT
    customer_id,
    customer_name,
    segment,
    region,
    total_sales,
    total_profit,
    order_count,
    sales_rank
FROM customer_ranked
ORDER BY sales_rank;


-- ============================================================
-- (b) TOP 10 CUSTOMERS BY SALES
-- ============================================================
WITH customer_sales AS (
    SELECT
        c.customer_id, c.customer_name, c.segment, c.region,
        SUM(o.sales) AS total_sales,
        SUM(o.profit) AS total_profit,
        COUNT(DISTINCT o.order_id) AS order_count
    FROM orders o
    JOIN customers c ON c.customer_id = o.customer_id
    GROUP BY c.customer_id, c.customer_name, c.segment, c.region
),
customer_ranked AS (
    SELECT
        cs.*,
        RANK() OVER (ORDER BY cs.total_sales DESC) AS sales_rank
    FROM customer_sales cs
)
SELECT * FROM customer_ranked
WHERE sales_rank <= 10
ORDER BY sales_rank;


-- ============================================================
-- (c) BOTTOM 10 CUSTOMERS BY SALES (still counts as a customer
--     -- i.e. they placed at least one order; this excludes
--     nobody, it just looks at the low end of the ranking)
-- ============================================================
WITH customer_sales AS (
    SELECT
        c.customer_id, c.customer_name, c.segment, c.region,
        SUM(o.sales) AS total_sales,
        COUNT(DISTINCT o.order_id) AS order_count
    FROM orders o
    JOIN customers c ON c.customer_id = o.customer_id
    GROUP BY c.customer_id, c.customer_name, c.segment, c.region
),
customer_ranked AS (
    SELECT
        cs.*,
        RANK() OVER (ORDER BY cs.total_sales ASC) AS bottom_rank
    FROM customer_sales cs
)
SELECT * FROM customer_ranked
WHERE bottom_rank <= 10
ORDER BY bottom_rank;


-- ============================================================
-- (d) SINGLE-ORDER CUSTOMERS
--     Customers who have placed exactly one order overall.
--     Useful for identifying one-time buyers worth targeting
--     with a "come back" campaign.
-- ============================================================
WITH customer_order_counts AS (
    SELECT
        c.customer_id,
        c.customer_name,
        c.segment,
        COUNT(DISTINCT o.order_id) AS order_count,
        SUM(o.sales) AS total_sales
    FROM orders o
    JOIN customers c ON c.customer_id = o.customer_id
    GROUP BY c.customer_id, c.customer_name, c.segment
)
SELECT *
FROM customer_order_counts
WHERE order_count = 1
ORDER BY total_sales DESC;


-- ============================================================
-- (e) ABOVE-AVERAGE CUSTOMERS
--     Customers whose total sales exceed the average total
--     sales across all customers (CTE + subquery-style average,
--     window-function-flagged).
-- ============================================================
WITH customer_sales AS (
    SELECT
        c.customer_id, c.customer_name, c.segment,
        SUM(o.sales) AS total_sales
    FROM orders o
    JOIN customers c ON c.customer_id = o.customer_id
    GROUP BY c.customer_id, c.customer_name, c.segment
),
customer_flagged AS (
    SELECT
        cs.*,
        AVG(cs.total_sales) OVER () AS avg_customer_sales   -- window function, no self-join needed
    FROM customer_sales cs
)
SELECT
    customer_id,
    customer_name,
    segment,
    total_sales,
    ROUND(avg_customer_sales, 2) AS avg_customer_sales
FROM customer_flagged
WHERE total_sales > avg_customer_sales
ORDER BY total_sales DESC;
