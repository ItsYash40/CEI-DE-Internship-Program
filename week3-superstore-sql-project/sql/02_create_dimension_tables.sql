-- ============================================================
-- 02_create_dimension_tables.sql
-- Purpose: The raw table is "flat" (customer + product + order
--          info repeated on every line-item row). Here we split
--          it into three cleaner, de-duplicated tables:
--            - customers  (one row per customer)
--            - products   (one row per product)
--            - orders     (one row per order line-item, but only
--                          the columns actually needed for
--                          sales analysis, referencing the other
--                          two tables by ID)
-- This is basic normalization -- it removes repeated customer/
-- product attributes and keeps the fact table (orders) lean.
-- ============================================================

-- ---------- CUSTOMERS ----------
DROP TABLE IF EXISTS customers;

CREATE TABLE customers AS
SELECT DISTINCT
    customer_id,
    customer_name,
    segment,
    country,
    city,
    state,
    postal_code,
    region
FROM superstore_raw;

-- customer_id should be unique after this; if a customer somehow
-- shows up with two different names/regions in the source data,
-- SELECT DISTINCT will keep both rows -- worth checking:
-- SELECT customer_id, COUNT(*) FROM customers GROUP BY customer_id HAVING COUNT(*) > 1;


-- ---------- PRODUCTS ----------
DROP TABLE IF EXISTS products;

CREATE TABLE products AS
SELECT DISTINCT
    product_id,
    product_name,
    category,
    sub_category
FROM superstore_raw;


-- ---------- ORDERS (fact table) ----------
DROP TABLE IF EXISTS orders;

CREATE TABLE orders AS
SELECT DISTINCT
    row_id,
    order_id,
    order_date,
    ship_date,
    ship_mode,
    customer_id,
    product_id,
    sales,
    quantity,
    discount,
    profit
FROM superstore_raw;

-- Quick row counts to confirm the split worked as expected:
-- SELECT 'customers' AS tbl, COUNT(*) FROM customers
-- UNION ALL SELECT 'products', COUNT(*) FROM products
-- UNION ALL SELECT 'orders', COUNT(*) FROM orders
-- UNION ALL SELECT 'superstore_raw', COUNT(*) FROM superstore_raw;
