-- ============================================================
-- 05_window_functions.sql
-- Purpose: Practice ROW_NUMBER, RANK, DENSE_RANK, and a couple
--          of other window functions (LAG, running totals) on
--          the order-level and customer-level data.
-- ============================================================

-- ------------------------------------------------------------
-- Q1. Rank every ORDER LINE-ITEM by sales value, highest first.
--     Shows the difference between the three ranking functions
--     when there are ties in sales value.
-- ------------------------------------------------------------
SELECT
    order_id,
    customer_id,
    sales,
    ROW_NUMBER() OVER (ORDER BY sales DESC) AS row_num,   -- always unique, no gaps
    RANK()       OVER (ORDER BY sales DESC) AS rank_num,  -- ties share a rank, then skips
    DENSE_RANK() OVER (ORDER BY sales DESC) AS dense_rank_num -- ties share a rank, no skip
FROM orders
ORDER BY sales DESC;


-- ------------------------------------------------------------
-- Q2. Within each customer, rank their own orders by sales
--     (PARTITION BY customer_id) -- useful for "show me each
--     customer's #1 order" type questions.
-- ------------------------------------------------------------
SELECT
    customer_id,
    order_id,
    sales,
    ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY sales DESC) AS order_rank_for_customer
FROM orders
ORDER BY customer_id, order_rank_for_customer;


-- ------------------------------------------------------------
-- Q3. Rank CUSTOMERS by total sales (this is the query most of
--     the business questions in 06 build on top of).
-- ------------------------------------------------------------
WITH customer_sales AS (
    SELECT
        o.customer_id,
        c.customer_name,
        SUM(o.sales) AS total_sales
    FROM orders o
    JOIN customers c ON c.customer_id = o.customer_id
    GROUP BY o.customer_id, c.customer_name
)
SELECT
    customer_id,
    customer_name,
    total_sales,
    RANK()       OVER (ORDER BY total_sales DESC) AS sales_rank,
    DENSE_RANK() OVER (ORDER BY total_sales DESC) AS sales_dense_rank,
    NTILE(4)     OVER (ORDER BY total_sales DESC) AS sales_quartile -- 1 = top 25% of spenders
FROM customer_sales
ORDER BY total_sales DESC;


-- ------------------------------------------------------------
-- Q4. Running total of sales per customer over time, ordered by
--     order date -- shows cumulative spend building up
--     (classic window-function running-total pattern).
-- ------------------------------------------------------------
SELECT
    customer_id,
    order_id,
    order_date,
    sales,
    SUM(sales) OVER (
        PARTITION BY customer_id
        ORDER BY order_date
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_total_sales
FROM orders
ORDER BY customer_id, order_date;


-- ------------------------------------------------------------
-- Q5. Compare each order to the customer's PREVIOUS order value
--     using LAG() -- helps spot customers whose spend is
--     trending up or down order-to-order.
-- ------------------------------------------------------------
SELECT
    customer_id,
    order_id,
    order_date,
    sales,
    LAG(sales) OVER (PARTITION BY customer_id ORDER BY order_date) AS previous_order_sales,
    ROUND(
        sales - LAG(sales) OVER (PARTITION BY customer_id ORDER BY order_date), 2
    ) AS change_vs_previous_order
FROM orders
ORDER BY customer_id, order_date;
