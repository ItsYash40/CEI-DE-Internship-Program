-- ============================================================
-- SECTION D: Join Queries (INNER JOIN & LEFT JOIN)
-- Week 2 SQL Assignment – Superstore Sales Analysis
-- ============================================================

USE superstore_db;

-- -------------------------------------------------------
-- D1. INNER JOIN – Full order detail
--     (orders + customers + order_items + products)
-- -------------------------------------------------------
SELECT
    o.order_id,
    o.order_date,
    o.ship_mode,
    c.customer_name,
    c.segment,
    c.region,
    c.state,
    p.product_name,
    p.category,
    p.sub_category,
    oi.quantity,
    ROUND(oi.sales, 2)    AS sales_usd,
    oi.discount,
    ROUND(oi.profit, 2)   AS profit_usd
FROM       order_items oi
INNER JOIN orders    o  ON oi.order_id   = o.order_id
INNER JOIN customers c  ON o.customer_id = c.customer_id
INNER JOIN products  p  ON oi.product_id = p.product_id
ORDER BY   o.order_date DESC, o.order_id;

-- -------------------------------------------------------
-- D2. INNER JOIN – Orders with customer details
-- -------------------------------------------------------
SELECT
    o.order_id,
    o.order_date,
    o.ship_date,
    o.ship_mode,
    c.customer_name,
    c.city,
    c.state,
    c.region,
    c.segment
FROM   orders    o
INNER JOIN customers c ON o.customer_id = c.customer_id
ORDER BY o.order_date;

-- -------------------------------------------------------
-- D3. INNER JOIN – Order items with product details
-- -------------------------------------------------------
SELECT
    oi.order_id,
    p.product_name,
    p.category,
    p.sub_category,
    oi.quantity,
    ROUND(oi.sales, 2)   AS unit_revenue,
    ROUND(oi.profit, 2)  AS unit_profit,
    oi.discount
FROM   order_items oi
INNER JOIN products p ON oi.product_id = p.product_id
ORDER BY oi.order_id, p.category;

-- -------------------------------------------------------
-- D4. INNER JOIN – Sales summary per customer (all joins)
-- -------------------------------------------------------
SELECT
    c.customer_id,
    c.customer_name,
    c.segment,
    c.region,
    COUNT(DISTINCT o.order_id)   AS total_orders,
    SUM(oi.quantity)             AS total_items_bought,
    ROUND(SUM(oi.sales), 2)      AS lifetime_value,
    ROUND(SUM(oi.profit), 2)     AS profit_generated
FROM       order_items oi
INNER JOIN orders    o  ON oi.order_id   = o.order_id
INNER JOIN customers c  ON o.customer_id = c.customer_id
GROUP BY   c.customer_id, c.customer_name, c.segment, c.region
ORDER BY   lifetime_value DESC;

-- -------------------------------------------------------
-- D5. INNER JOIN – Revenue by category per region
-- -------------------------------------------------------
SELECT
    c.region,
    p.category,
    ROUND(SUM(oi.sales), 2)   AS total_sales,
    ROUND(SUM(oi.profit), 2)  AS total_profit,
    COUNT(oi.item_id)         AS num_line_items
FROM       order_items oi
INNER JOIN orders    o  ON oi.order_id   = o.order_id
INNER JOIN customers c  ON o.customer_id = c.customer_id
INNER JOIN products  p  ON oi.product_id = p.product_id
GROUP BY   c.region, p.category
ORDER BY   c.region, total_sales DESC;

-- -------------------------------------------------------
-- D6. LEFT JOIN – All customers including those with no orders
-- -------------------------------------------------------
SELECT
    c.customer_id,
    c.customer_name,
    c.segment,
    c.region,
    COUNT(o.order_id)         AS total_orders,
    ROUND(SUM(oi.sales), 2)   AS total_sales
FROM       customers  c
LEFT JOIN  orders     o  ON c.customer_id  = o.customer_id
LEFT JOIN  order_items oi ON o.order_id   = oi.order_id
GROUP BY   c.customer_id, c.customer_name, c.segment, c.region
ORDER BY   total_sales DESC NULLS LAST;

-- -------------------------------------------------------
-- D7. LEFT JOIN – Products that were never sold
-- -------------------------------------------------------
SELECT
    p.product_id,
    p.product_name,
    p.category,
    p.sub_category
FROM       products    p
LEFT JOIN  order_items oi ON p.product_id = oi.product_id
WHERE      oi.item_id IS NULL
ORDER BY   p.category, p.product_name;

-- -------------------------------------------------------
-- D8. INNER JOIN – Top 5 most profitable orders
-- -------------------------------------------------------
SELECT
    o.order_id,
    o.order_date,
    c.customer_name,
    c.region,
    ROUND(SUM(oi.sales), 2)   AS order_sales,
    ROUND(SUM(oi.profit), 2)  AS order_profit
FROM       order_items oi
INNER JOIN orders    o  ON oi.order_id   = o.order_id
INNER JOIN customers c  ON o.customer_id = c.customer_id
GROUP BY   o.order_id, o.order_date, c.customer_name, c.region
ORDER BY   order_profit DESC
LIMIT 5;

-- -------------------------------------------------------
-- D9. INNER JOIN – Year-over-year sales by category
-- -------------------------------------------------------
SELECT
    YEAR(o.order_date)        AS yr,
    p.category,
    ROUND(SUM(oi.sales), 2)   AS total_sales,
    ROUND(SUM(oi.profit), 2)  AS total_profit
FROM       order_items oi
INNER JOIN orders   o ON oi.order_id   = o.order_id
INNER JOIN products p ON oi.product_id = p.product_id
GROUP BY   yr, p.category
ORDER BY   yr, total_sales DESC;

-- -------------------------------------------------------
-- D10. INNER JOIN – Customers who bought Technology products
-- -------------------------------------------------------
SELECT DISTINCT
    c.customer_name,
    c.segment,
    c.region,
    p.sub_category
FROM       order_items oi
INNER JOIN orders    o  ON oi.order_id   = o.order_id
INNER JOIN customers c  ON o.customer_id = c.customer_id
INNER JOIN products  p  ON oi.product_id = p.product_id
WHERE      p.category = 'Technology'
ORDER BY   c.customer_name;

-- -------------------------------------------------------
-- INSIGHT (Section D):
-- LEFT JOIN confirms all 30 customers have placed orders.
-- No products in the catalogue were left unsold (all products
-- appear in order_items). Technology drives highest revenue
-- across all regions, with West leading in every category.
-- -------------------------------------------------------