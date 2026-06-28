-- ============================================================
-- SECTION A: Basic Queries
-- Week 2 SQL Assignment – Superstore Sales Analysis
-- ============================================================

USE superstore_db;

-- -------------------------------------------------------
-- A1. View all customers
-- -------------------------------------------------------
SELECT *
FROM customers;

-- -------------------------------------------------------
-- A2. View all products
-- -------------------------------------------------------
SELECT *
FROM products;

-- -------------------------------------------------------
-- A3. View all orders
-- -------------------------------------------------------
SELECT *
FROM orders;

-- -------------------------------------------------------
-- A4. View all order items
-- -------------------------------------------------------
SELECT *
FROM order_items;

-- -------------------------------------------------------
-- A5. Schema exploration – columns in each table
-- -------------------------------------------------------
DESCRIBE customers;
DESCRIBE products;
DESCRIBE orders;
DESCRIBE order_items;

-- -------------------------------------------------------
-- A6. Sample data – first 10 rows from each table
-- -------------------------------------------------------
SELECT * FROM customers   LIMIT 10;
SELECT * FROM products    LIMIT 10;
SELECT * FROM orders      LIMIT 10;
SELECT * FROM order_items LIMIT 10;

-- -------------------------------------------------------
-- A7. Total row count per table (data validation)
-- -------------------------------------------------------
SELECT 'customers'   AS table_name, COUNT(*) AS total_rows FROM customers  UNION ALL
SELECT 'products',                  COUNT(*)               FROM products   UNION ALL
SELECT 'orders',                    COUNT(*)               FROM orders     UNION ALL
SELECT 'order_items',               COUNT(*)               FROM order_items;

-- -------------------------------------------------------
-- A8. Distinct values in key categorical columns
-- -------------------------------------------------------
-- Customer segments
SELECT DISTINCT segment FROM customers ORDER BY segment;

-- Regions
SELECT DISTINCT region FROM customers ORDER BY region;

-- Product categories
SELECT DISTINCT category FROM products ORDER BY category;

-- Product sub-categories
SELECT DISTINCT sub_category FROM products ORDER BY category, sub_category;

-- Ship modes
SELECT DISTINCT ship_mode FROM orders ORDER BY ship_mode;

-- -------------------------------------------------------
-- A9. Basic column selection (only relevant columns)
-- -------------------------------------------------------
SELECT customer_id, customer_name, segment, region
FROM   customers
LIMIT  10;

SELECT product_id, product_name, category, sub_category
FROM   products
LIMIT  10;

-- -------------------------------------------------------
-- A10. Check for NULL values in critical fields
-- -------------------------------------------------------
SELECT
    SUM(CASE WHEN customer_id   IS NULL THEN 1 ELSE 0 END) AS null_customer_id,
    SUM(CASE WHEN customer_name IS NULL THEN 1 ELSE 0 END) AS null_customer_name,
    SUM(CASE WHEN region        IS NULL THEN 1 ELSE 0 END) AS null_region
FROM customers;

SELECT
    SUM(CASE WHEN sales    IS NULL THEN 1 ELSE 0 END) AS null_sales,
    SUM(CASE WHEN quantity IS NULL THEN 1 ELSE 0 END) AS null_quantity,
    SUM(CASE WHEN profit   IS NULL THEN 1 ELSE 0 END) AS null_profit
FROM order_items;

-- -------------------------------------------------------
-- INSIGHT (Section A):
-- The database contains 4 tables: customers (30), products (30),
-- orders (40), and order_items (60 line items). No NULL values
-- found in critical fields, confirming data integrity.
-- -------------------------------------------------------

