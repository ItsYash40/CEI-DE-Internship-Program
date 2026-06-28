-- ============================================================
-- SECTION C: Aggregation Queries (GROUP BY)
-- Week 2 SQL Assignment – Superstore Sales Analysis
-- ============================================================

USE superstore_db;

-- -------------------------------------------------------
-- C1. Total sales, quantity, and profit overall
-- -------------------------------------------------------
SELECT
    COUNT(*)                  AS total_transactions,
    ROUND(SUM(sales), 2)      AS total_sales,
    SUM(quantity)             AS total_quantity,
    ROUND(SUM(profit), 2)     AS total_profit,
    ROUND(AVG(sales), 2)      AS avg_sale_per_transaction,
    ROUND(AVG(profit), 2)     AS avg_profit_per_transaction,
    ROUND(MAX(sales), 2)      AS max_single_sale,
    ROUND(MIN(sales), 2)      AS min_single_sale
FROM order_items;

-- -------------------------------------------------------
-- C2. Total sales by product category
-- -------------------------------------------------------
SELECT
    p.category,
    COUNT(oi.item_id)         AS num_transactions,
    SUM(oi.quantity)          AS total_quantity,
    ROUND(SUM(oi.sales), 2)   AS total_sales,
    ROUND(SUM(oi.profit), 2)  AS total_profit,
    ROUND(AVG(oi.sales), 2)   AS avg_sale
FROM       order_items oi
INNER JOIN products    p  ON oi.product_id = p.product_id
GROUP BY   p.category
ORDER BY   total_sales DESC;

-- -------------------------------------------------------
-- C3. Sales and profit by sub-category
-- -------------------------------------------------------
SELECT
    p.category,
    p.sub_category,
    COUNT(oi.item_id)         AS num_transactions,
    SUM(oi.quantity)          AS total_quantity,
    ROUND(SUM(oi.sales), 2)   AS total_sales,
    ROUND(SUM(oi.profit), 2)  AS total_profit,
    ROUND(SUM(oi.profit) / NULLIF(SUM(oi.sales), 0) * 100, 2) AS profit_margin_pct
FROM       order_items oi
INNER JOIN products    p  ON oi.product_id = p.product_id
GROUP BY   p.category, p.sub_category
ORDER BY   total_sales DESC;

-- -------------------------------------------------------
-- C4. Total sales by customer segment
-- -------------------------------------------------------
SELECT
    c.segment,
    COUNT(DISTINCT o.order_id)  AS total_orders,
    COUNT(oi.item_id)           AS total_items,
    ROUND(SUM(oi.sales), 2)     AS total_sales,
    ROUND(SUM(oi.profit), 2)    AS total_profit,
    ROUND(AVG(oi.sales), 2)     AS avg_sale
FROM       order_items oi
INNER JOIN orders   o  ON oi.order_id   = o.order_id
INNER JOIN customers c ON o.customer_id = c.customer_id
GROUP BY   c.segment
ORDER BY   total_sales DESC;

-- -------------------------------------------------------
-- C5. Total sales and orders by region
-- -------------------------------------------------------
SELECT
    c.region,
    COUNT(DISTINCT o.order_id)  AS total_orders,
    COUNT(DISTINCT o.customer_id) AS unique_customers,
    ROUND(SUM(oi.sales), 2)     AS total_sales,
    ROUND(SUM(oi.profit), 2)    AS total_profit
FROM       order_items oi
INNER JOIN orders    o  ON oi.order_id   = o.order_id
INNER JOIN customers c  ON o.customer_id = c.customer_id
GROUP BY   c.region
ORDER BY   total_sales DESC;

-- -------------------------------------------------------
-- C6. Monthly sales trend (all years combined)
-- -------------------------------------------------------
SELECT
    DATE_FORMAT(o.order_date, '%Y-%m') AS year_month,
    COUNT(DISTINCT o.order_id)          AS num_orders,
    ROUND(SUM(oi.sales), 2)             AS monthly_sales,
    ROUND(SUM(oi.profit), 2)            AS monthly_profit
FROM       order_items oi
INNER JOIN orders o ON oi.order_id = o.order_id
GROUP BY   year_month
ORDER BY   year_month;

-- -------------------------------------------------------
-- C7. Annual sales trend
-- -------------------------------------------------------
SELECT
    YEAR(o.order_date)          AS order_year,
    COUNT(DISTINCT o.order_id)  AS total_orders,
    ROUND(SUM(oi.sales), 2)     AS annual_sales,
    ROUND(SUM(oi.profit), 2)    AS annual_profit,
    ROUND(AVG(oi.sales), 2)     AS avg_order_value
FROM       order_items oi
INNER JOIN orders o ON oi.order_id = o.order_id
GROUP BY   order_year
ORDER BY   order_year;

-- -------------------------------------------------------
-- C8. Average discount by category
-- -------------------------------------------------------
SELECT
    p.category,
    ROUND(AVG(oi.discount) * 100, 2) AS avg_discount_pct,
    COUNT(CASE WHEN oi.discount > 0 THEN 1 END) AS discounted_items,
    COUNT(oi.item_id)                 AS total_items
FROM       order_items oi
INNER JOIN products p ON oi.product_id = p.product_id
GROUP BY   p.category
ORDER BY   avg_discount_pct DESC;

-- -------------------------------------------------------
-- C9. Top 10 products by total sales
-- -------------------------------------------------------
SELECT
    p.product_name,
    p.category,
    p.sub_category,
    SUM(oi.quantity)         AS total_qty_sold,
    ROUND(SUM(oi.sales), 2)  AS total_sales,
    ROUND(SUM(oi.profit), 2) AS total_profit
FROM       order_items oi
INNER JOIN products p ON oi.product_id = p.product_id
GROUP BY   p.product_id, p.product_name, p.category, p.sub_category
ORDER BY   total_sales DESC
LIMIT 10;

-- -------------------------------------------------------
-- C10. Top 10 customers by total purchase value
-- -------------------------------------------------------
SELECT
    c.customer_id,
    c.customer_name,
    c.segment,
    c.region,
    COUNT(DISTINCT o.order_id)  AS total_orders,
    ROUND(SUM(oi.sales), 2)     AS total_spent,
    ROUND(SUM(oi.profit), 2)    AS total_profit_generated
FROM       order_items oi
INNER JOIN orders    o  ON oi.order_id   = o.order_id
INNER JOIN customers c  ON o.customer_id = c.customer_id
GROUP BY   c.customer_id, c.customer_name, c.segment, c.region
ORDER BY   total_spent DESC
LIMIT 10;

-- -------------------------------------------------------
-- C11. Ship mode frequency and average shipping time
-- -------------------------------------------------------
SELECT
    ship_mode,
    COUNT(*)                                            AS total_orders,
    ROUND(AVG(DATEDIFF(ship_date, order_date)), 1)      AS avg_ship_days,
    MIN(DATEDIFF(ship_date, order_date))                AS min_ship_days,
    MAX(DATEDIFF(ship_date, order_date))                AS max_ship_days
FROM   orders
GROUP BY ship_mode
ORDER BY avg_ship_days;

-- -------------------------------------------------------
-- C12. Profit margin by region and segment
-- -------------------------------------------------------
SELECT
    c.region,
    c.segment,
    ROUND(SUM(oi.sales), 2)   AS total_sales,
    ROUND(SUM(oi.profit), 2)  AS total_profit,
    ROUND(SUM(oi.profit) / NULLIF(SUM(oi.sales), 0) * 100, 2) AS profit_margin_pct
FROM       order_items oi
INNER JOIN orders    o  ON oi.order_id   = o.order_id
INNER JOIN customers c  ON o.customer_id = c.customer_id
GROUP BY   c.region, c.segment
ORDER BY   c.region, profit_margin_pct DESC;

-- -------------------------------------------------------
-- INSIGHT (Section C):
-- Technology is the highest-revenue category but Machines
-- alone contribute a disproportionate share. Tables sub-category
-- consistently shows negative margins due to heavy discounting.
-- The West region leads in both sales and orders.
-- -------------------------------------------------------