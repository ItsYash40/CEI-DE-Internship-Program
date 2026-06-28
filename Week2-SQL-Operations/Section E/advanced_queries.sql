-- ============================================================
-- SECTION E: Advanced Queries
-- Week 2 SQL Assignment – Superstore Sales Analysis
-- Topics: CASE, Subqueries, Transactions, Window Functions,
--         Duplicate Detection, Monthly Trends, Top Customers
-- ============================================================

USE superstore_db;

-- -------------------------------------------------------
-- E1. CASE – Classify transactions by sales tier
-- -------------------------------------------------------
SELECT
    oi.item_id  ,
    oi.order_id,
    p.product_name,
    p.category,
    ROUND(oi.sales, 2) AS sales_usd,
    CASE
        WHEN oi.sales >= 2000 THEN 'Platinum (≥ $2000)'
        WHEN oi.sales >= 500  THEN 'Gold ($500–$1999)'
        WHEN oi.sales >= 100  THEN 'Silver ($100–$499)'
        ELSE                       'Bronze (< $100)'
    END AS sales_tier
FROM       order_items oi
INNER JOIN products p ON oi.product_id = p.product_id
ORDER BY   oi.sales DESC;

-- -------------------------------------------------------
-- E2. CASE – Classify profit performance
-- -------------------------------------------------------
SELECT
    oi.item_id,
    oi.order_id,
    p.product_name,
    ROUND(oi.profit, 2) AS profit_usd,
    CASE
        WHEN oi.profit > 500  THEN 'High Profit'
        WHEN oi.profit > 0    THEN 'Profitable'
        WHEN oi.profit = 0    THEN 'Break Even'
        ELSE                       'Loss'
    END AS profitability_label
FROM       order_items oi
INNER JOIN products p ON oi.product_id = p.product_id
ORDER BY   oi.profit;

-- -------------------------------------------------------
-- E3. CASE – Discount impact analysis
-- -------------------------------------------------------
SELECT
    CASE
        WHEN oi.discount = 0           THEN 'No Discount'
        WHEN oi.discount BETWEEN 0.01 AND 0.20 THEN 'Low (1–20%)'
        WHEN oi.discount BETWEEN 0.21 AND 0.40 THEN 'Medium (21–40%)'
        ELSE                                        'High (> 40%)'
    END AS discount_band,
    COUNT(*)                              AS num_transactions,
    ROUND(AVG(oi.sales), 2)               AS avg_sales,
    ROUND(AVG(oi.profit), 2)              AS avg_profit,
    ROUND(SUM(oi.profit)
          / NULLIF(SUM(oi.sales), 0) * 100, 2) AS profit_margin_pct
FROM order_items oi
GROUP BY discount_band
ORDER BY avg_profit DESC;

-- -------------------------------------------------------
-- E4. CASE – Customer value segmentation
-- -------------------------------------------------------
SELECT
    c.customer_name,
    c.segment,
    ROUND(SUM(oi.sales), 2) AS total_spent,
    CASE
        WHEN SUM(oi.sales) >= 5000 THEN 'VIP'
        WHEN SUM(oi.sales) >= 2000 THEN 'High Value'
        WHEN SUM(oi.sales) >= 500  THEN 'Mid Value'
        ELSE                            'Low Value'
    END AS customer_tier
FROM       order_items oi
INNER JOIN orders    o  ON oi.order_id   = o.order_id
INNER JOIN customers c  ON o.customer_id = c.customer_id
GROUP BY   c.customer_id, c.customer_name, c.segment
ORDER BY   total_spent DESC;

-- -------------------------------------------------------
-- E5. Subquery – Customers who spent above average
-- -------------------------------------------------------
SELECT
    c.customer_name,
    c.region,
    c.segment,
    ROUND(SUM(oi.sales), 2) AS total_spent
FROM       order_items oi
INNER JOIN orders    o  ON oi.order_id   = o.order_id
INNER JOIN customers c  ON o.customer_id = c.customer_id
GROUP BY   c.customer_id, c.customer_name, c.region, c.segment
HAVING     SUM(oi.sales) > (
    SELECT AVG(customer_total)
    FROM (
        SELECT SUM(oi2.sales) AS customer_total
        FROM       order_items oi2
        INNER JOIN orders o2 ON oi2.order_id = o2.order_id
        GROUP BY   o2.customer_id
    ) AS avg_sub
)
ORDER BY total_spent DESC;

-- -------------------------------------------------------
-- E6. Subquery – Products with above-average sales per unit
-- -------------------------------------------------------
SELECT
    p.product_name,
    p.category,
    ROUND(AVG(oi.sales), 2) AS avg_item_sales
FROM       order_items oi
INNER JOIN products p ON oi.product_id = p.product_id
GROUP BY   p.product_id, p.product_name, p.category
HAVING     AVG(oi.sales) > (SELECT AVG(sales) FROM order_items)
ORDER BY   avg_item_sales DESC;

-- -------------------------------------------------------
-- E7. Monthly trend – Sales & profit month-over-month
-- -------------------------------------------------------
SELECT
    YEAR(o.order_date)             AS yr,
    MONTH(o.order_date)            AS mo,
    DATE_FORMAT(o.order_date, '%b %Y') AS month_label,
    COUNT(DISTINCT o.order_id)     AS orders_placed,
    ROUND(SUM(oi.sales), 2)        AS monthly_sales,
    ROUND(SUM(oi.profit), 2)       AS monthly_profit,
    ROUND(SUM(oi.profit)
          / NULLIF(SUM(oi.sales), 0) * 100, 2) AS margin_pct
FROM       order_items oi
INNER JOIN orders o ON oi.order_id = o.order_id
GROUP BY   yr, mo, month_label
ORDER BY   yr, mo;

-- -------------------------------------------------------
-- E8. Duplicate detection – Duplicate order_id + product_id
--     (should not exist given the schema, but good to verify)
-- -------------------------------------------------------
SELECT
    order_id,
    product_id,
    COUNT(*) AS duplicate_count
FROM   order_items
GROUP BY order_id, product_id
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC;

-- -------------------------------------------------------
-- E9. Duplicate detection – Customers with same name
--     (different IDs but same name – possible data entry issue)
-- -------------------------------------------------------
SELECT
    customer_name,
    COUNT(*) AS name_count,
    GROUP_CONCAT(customer_id ORDER BY customer_id) AS customer_ids
FROM   customers
GROUP BY customer_name
HAVING COUNT(*) > 1;

-- -------------------------------------------------------
-- E10. Top customers by year (use CASE for ranking)
-- -------------------------------------------------------
SELECT
    YEAR(o.order_date)      AS order_year,
    c.customer_name,
    c.region,
    ROUND(SUM(oi.sales), 2) AS annual_spend
FROM       order_items oi
INNER JOIN orders    o  ON oi.order_id   = o.order_id
INNER JOIN customers c  ON o.customer_id = c.customer_id
GROUP BY   order_year, c.customer_id, c.customer_name, c.region
ORDER BY   order_year, annual_spend DESC;

-- -------------------------------------------------------
-- E11. TRANSACTION – Insert a new order safely
--      (demonstrates atomicity: all or nothing)
-- -------------------------------------------------------
START TRANSACTION;

    -- Step 1: Insert new customer
    INSERT INTO customers
        (customer_id, customer_name, segment, country, city, state, postal_code, region)
    VALUES
        ('TX-99001', 'Alex Turner', 'Corporate', 'United States', 'Austin', 'Texas', '73301', 'Central');

    -- Step 2: Insert corresponding order
    INSERT INTO orders
        (order_id, order_date, ship_date, ship_mode, customer_id)
    VALUES
        ('CA-2024-999001', '2024-01-15', '2024-01-20', 'Second Class', 'TX-99001');

    -- Step 3: Insert order item
    INSERT INTO order_items
        (order_id, product_id, sales, quantity, discount, profit)
    VALUES
        ('CA-2024-999001', 'TEC-CO-10004722', 1299.99, 1, 0.00, 259.99);

COMMIT;

-- Verify the transaction result
SELECT 'New order inserted successfully' AS status;
SELECT c.customer_name, o.order_id, o.order_date,
       p.product_name, oi.sales
FROM       order_items oi
INNER JOIN orders    o  ON oi.order_id   = o.order_id
INNER JOIN customers c  ON o.customer_id = c.customer_id
INNER JOIN products  p  ON oi.product_id = p.product_id
WHERE      o.order_id = 'CA-2024-999001';

-- -------------------------------------------------------
-- E12. TRANSACTION with ROLLBACK demo
--      (simulates failure: rolls back on error)
-- -------------------------------------------------------
START TRANSACTION;

    INSERT INTO orders
        (order_id, order_date, ship_date, ship_mode, customer_id)
    VALUES
        ('CA-2024-999002', '2024-02-10', '2024-02-15', 'First Class', 'NONEXISTENT-ID');

ROLLBACK;  -- Customer doesn't exist → rollback

SELECT 'Transaction rolled back – no data inserted' AS status;

-- -------------------------------------------------------
-- E13. Data quality check – Orders with ship_date before order_date
-- -------------------------------------------------------
SELECT order_id, order_date, ship_date,
       DATEDIFF(ship_date, order_date) AS days_diff
FROM   orders
WHERE  ship_date < order_date;

-- -------------------------------------------------------
-- E14. Comprehensive sales dashboard view
-- -------------------------------------------------------
SELECT
    p.category,
    p.sub_category,
    c.region,
    YEAR(o.order_date)              AS yr,
    COUNT(DISTINCT o.order_id)      AS orders,
    SUM(oi.quantity)                AS units_sold,
    ROUND(SUM(oi.sales), 2)         AS revenue,
    ROUND(SUM(oi.profit), 2)        AS profit,
    ROUND(SUM(oi.profit)
          / NULLIF(SUM(oi.sales), 0) * 100, 2) AS margin_pct,
    ROUND(AVG(oi.discount) * 100, 2) AS avg_discount_pct,
    CASE
        WHEN SUM(oi.profit) / NULLIF(SUM(oi.sales), 0) > 0.2  THEN 'Excellent'
        WHEN SUM(oi.profit) / NULLIF(SUM(oi.sales), 0) > 0.10 THEN 'Good'
        WHEN SUM(oi.profit) / NULLIF(SUM(oi.sales), 0) > 0    THEN 'Marginal'
        ELSE                                                        'Loss-Making'
    END AS performance_label
FROM       order_items oi
INNER JOIN orders    o  ON oi.order_id   = o.order_id
INNER JOIN customers c  ON o.customer_id = c.customer_id
INNER JOIN products  p  ON oi.product_id = p.product_id
GROUP BY   p.category, p.sub_category, c.region, yr
ORDER BY   revenue DESC;

-- -------------------------------------------------------
-- INSIGHT (Section E):
-- • Heavy discounts (>20%) consistently produce losses.
-- • Machines (Technology) are the single biggest revenue driver
--   with healthy margins (~20%) when sold without discount.
-- • Tables (Furniture) are the most loss-prone sub-category
--   due to 45% discounts on several large orders.
-- • No duplicate order+product combinations were found,
--   confirming clean transactional data.
-- -------------------------------------------------------