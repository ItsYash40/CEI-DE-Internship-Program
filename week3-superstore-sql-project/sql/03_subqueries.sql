-- ============================================================
-- 03_subqueries.sql
-- Purpose: Answer two questions using SUBQUERIES specifically
--          (as opposed to CTEs/window functions, which come later).
-- ============================================================

-- ------------------------------------------------------------
-- Q1. Which individual order line-items have sales ABOVE the
--     overall average sales value?
--     (Classic subquery-in-WHERE pattern.)
-- ------------------------------------------------------------
SELECT
    o.order_id,
    o.customer_id,
    c.customer_name,
    o.sales
FROM orders o
JOIN customers c ON c.customer_id = o.customer_id
WHERE o.sales > (
    SELECT AVG(sales) FROM orders
)
ORDER BY o.sales DESC;


-- ------------------------------------------------------------
-- Q2. What is the single highest-value order for EACH customer?
--     (Correlated subquery: the inner query re-runs per customer.)
-- ------------------------------------------------------------
SELECT
    o.customer_id,
    c.customer_name,
    o.order_id,
    o.sales AS highest_order_sales
FROM orders o
JOIN customers c ON c.customer_id = o.customer_id
WHERE o.sales = (
    SELECT MAX(o2.sales)
    FROM orders o2
    WHERE o2.customer_id = o.customer_id
)
ORDER BY highest_order_sales DESC;


-- ------------------------------------------------------------
-- Q3. Which customers have TOTAL sales above the average
--     customer's total sales? (subquery inside a subquery /
--     aggregate-of-aggregate pattern -- sets up the CTE version
--     we build cleanly in 04_ctes.sql)
-- ------------------------------------------------------------
SELECT
    customer_id,
    total_sales
FROM (
    SELECT customer_id, SUM(sales) AS total_sales
    FROM orders
    GROUP BY customer_id
) AS customer_totals
WHERE total_sales > (
    SELECT AVG(total_sales)
    FROM (
        SELECT SUM(sales) AS total_sales
        FROM orders
        GROUP BY customer_id
    )
)
ORDER BY total_sales DESC;
