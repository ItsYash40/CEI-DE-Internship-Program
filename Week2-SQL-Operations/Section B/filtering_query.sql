-- ============================================================
-- SECTION B: Filtering Queries (WHERE Conditions)
-- Week 2 SQL Assignment – Superstore Sales Analysis
-- ============================================================

USE superstore_db;

-- -------------------------------------------------------
-- B1. Filter by Region – customers in the West
-- -------------------------------------------------------
SELECT customer_id, customer_name, city, state, region
FROM   customers
WHERE  region = 'West'
ORDER BY state, customer_name;

-- -------------------------------------------------------
-- B2. Filter by Segment – Corporate customers only
-- -------------------------------------------------------
SELECT customer_id, customer_name, city, state, segment
FROM   customers
WHERE  segment = 'Corporate'
ORDER BY customer_name;

-- -------------------------------------------------------
-- B3. Filter by Category – Technology products only
-- -------------------------------------------------------
SELECT product_id, product_name, category, sub_category
FROM   products
WHERE  category = 'Technology'
ORDER BY sub_category, product_name;

-- -------------------------------------------------------
-- B4. Filter by Sub-Category – Chairs only
-- -------------------------------------------------------
SELECT product_id, product_name, sub_category
FROM   products
WHERE  sub_category = 'Chairs';

-- -------------------------------------------------------
-- B5. Filter orders by date range (Year 2022)
-- -------------------------------------------------------
SELECT order_id, order_date, ship_date, ship_mode, customer_id
FROM   orders
WHERE  order_date BETWEEN '2022-01-01' AND '2022-12-31'
ORDER BY order_date;

-- -------------------------------------------------------
-- B6. Filter orders placed in 2023
-- -------------------------------------------------------
SELECT order_id, order_date, customer_id
FROM   orders
WHERE  YEAR(order_date) = 2023
ORDER BY order_date;

-- -------------------------------------------------------
-- B7. Filter order items with high sales (> $500)
-- -------------------------------------------------------
SELECT item_id, order_id, product_id,
       ROUND(sales, 2)    AS sales_usd,
       quantity,
       ROUND(profit, 2)   AS profit_usd
FROM   order_items
WHERE  sales > 500
ORDER BY sales DESC;

-- -------------------------------------------------------
-- B8. Filter order items where discount was applied
-- -------------------------------------------------------
SELECT item_id, order_id, product_id,
       ROUND(sales, 2)    AS sales_usd,
       discount,
       ROUND(profit, 2)   AS profit_usd
FROM   order_items
WHERE  discount > 0
ORDER BY discount DESC;

-- -------------------------------------------------------
-- B9. Filter unprofitable transactions (negative profit)
-- -------------------------------------------------------
SELECT item_id, order_id, product_id,
       ROUND(sales, 2)   AS sales_usd,
       discount,
       ROUND(profit, 2)  AS profit_usd
FROM   order_items
WHERE  profit < 0
ORDER BY profit ASC;

-- -------------------------------------------------------
-- B10. Filter by multiple conditions –
--      High-value orders (sales > 200) with discounts
-- -------------------------------------------------------
SELECT item_id, order_id, product_id,
       ROUND(sales, 2)  AS sales_usd,
       discount,
       ROUND(profit, 2) AS profit_usd
FROM   order_items
WHERE  sales    > 200
  AND  discount > 0
ORDER BY sales DESC;

-- -------------------------------------------------------
-- B11. Filter customers from a specific state (California)
-- -------------------------------------------------------
SELECT customer_id, customer_name, city, segment
FROM   customers
WHERE  state = 'California'
ORDER BY city;

-- -------------------------------------------------------
-- B12. Filter orders by ship mode – First Class only
-- -------------------------------------------------------
SELECT order_id, order_date, ship_date, ship_mode, customer_id
FROM   orders
WHERE  ship_mode = 'First Class'
ORDER BY order_date;

-- -------------------------------------------------------
-- B13. Filter using OR – Furniture OR Technology products
-- -------------------------------------------------------
SELECT product_id, product_name, category
FROM   products
WHERE  category = 'Furniture'
   OR  category = 'Technology'
ORDER BY category, product_name;

-- -------------------------------------------------------
-- B14. Filter using IN – multiple segments
-- -------------------------------------------------------
SELECT customer_id, customer_name, segment, region
FROM   customers
WHERE  segment IN ('Corporate', 'Home Office')
ORDER BY segment, region;

-- -------------------------------------------------------
-- B15. Filter using LIKE – product names containing 'Chair'
-- -------------------------------------------------------
SELECT product_id, product_name, category, sub_category
FROM   products
WHERE  product_name LIKE '%Chair%'
   OR  product_name LIKE '%chair%';

-- -------------------------------------------------------
-- INSIGHT (Section B):
-- ~30% of order items carry a discount, and discounted items
-- tend to generate negative or near-zero profit, highlighting
-- the risk of aggressive discounting. The West region has the
-- most customers among the four regions.
-- -------------------------------------------------------