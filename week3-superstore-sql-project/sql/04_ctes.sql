-- ============================================================
-- 04_ctes.sql
-- Purpose: Rebuild the "above-average customer" logic from
--          03_subqueries.sql (Q3) using CTEs instead -- much
--          more readable once you have more than one level of
--          aggregation. Also adds a couple of extra CTE-based
--          aggregations that get reused later.
-- ============================================================

-- ------------------------------------------------------------
-- Q1. Total sales, total profit, and order count per customer
--     (this CTE, customer_sales, is the building block reused
--     by almost every later query in this project)
-- ------------------------------------------------------------
WITH customer_sales AS (
    SELECT
        o.customer_id,
        c.customer_name,
        SUM(o.sales)                    AS total_sales,
        SUM(o.profit)                   AS total_profit,
        COUNT(DISTINCT o.order_id)      AS order_count,
        ROUND(AVG(o.sales), 2)          AS avg_order_value
    FROM orders o
    JOIN customers c ON c.customer_id = o.customer_id
    GROUP BY o.customer_id, c.customer_name
)
SELECT * FROM customer_sales
ORDER BY total_sales DESC;


-- ------------------------------------------------------------
-- Q2. Above-average customers, rebuilt cleanly with a CTE
--     (compare this to Q3 in 03_subqueries.sql -- same result,
--     far easier to read/maintain)
-- ------------------------------------------------------------
WITH customer_sales AS (
    SELECT
        o.customer_id,
        c.customer_name,
        SUM(o.sales) AS total_sales
    FROM orders o
    JOIN customers c ON c.customer_id = o.customer_id
    GROUP BY o.customer_id, c.customer_name
),
overall_avg AS (
    SELECT AVG(total_sales) AS avg_customer_sales
    FROM customer_sales
)
SELECT
    cs.customer_id,
    cs.customer_name,
    cs.total_sales,
    oa.avg_customer_sales,
    ROUND(cs.total_sales - oa.avg_customer_sales, 2) AS diff_from_avg
FROM customer_sales cs
CROSS JOIN overall_avg oa
WHERE cs.total_sales > oa.avg_customer_sales
ORDER BY cs.total_sales DESC;


-- ------------------------------------------------------------
-- Q3. Category-level performance using a CTE, then filtered
--     down to categories that are profitable overall (chained
--     CTEs: one for aggregation, one for filtering)
-- ------------------------------------------------------------
WITH category_perf AS (
    SELECT
        p.category,
        SUM(o.sales)   AS category_sales,
        SUM(o.profit)  AS category_profit,
        COUNT(*)       AS line_items
    FROM orders o
    JOIN products p ON p.product_id = o.product_id
    GROUP BY p.category
)
SELECT *
FROM category_perf
WHERE category_profit > 0
ORDER BY category_sales DESC;
