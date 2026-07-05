-- ============================================================
-- 01_load_raw.sql
-- Purpose: Create the raw staging table that mirrors the
--          Superstore CSV exactly (one row per order line-item).
-- ============================================================
-- NOTE ON LOADING:
-- In SQLite (used for this project via scripts/run_analysis.py),
-- the CSV is loaded into this table using Python's csv + sqlite3
-- libraries (see run_analysis.py -> load_csv_to_raw()).
-- If you are doing this in MySQL/Postgres instead, load the CSV
-- with LOAD DATA INFILE / \copy respectively. The table shape
-- below is identical either way.

DROP TABLE IF EXISTS superstore_raw;

CREATE TABLE superstore_raw (
    row_id          INTEGER,
    order_id        TEXT,
    order_date      TEXT,      -- kept as TEXT/DATE string (YYYY-MM-DD)
    ship_date       TEXT,
    ship_mode       TEXT,
    customer_id     TEXT,
    customer_name   TEXT,
    segment         TEXT,
    country         TEXT,
    city            TEXT,
    state           TEXT,
    postal_code     TEXT,
    region          TEXT,
    product_id      TEXT,
    category        TEXT,
    sub_category    TEXT,
    product_name    TEXT,
    sales           REAL,
    quantity        INTEGER,
    discount        REAL,
    profit          REAL
);

-- Sanity checks after loading (run manually if you like):
-- SELECT COUNT(*) FROM superstore_raw;
-- SELECT * FROM superstore_raw LIMIT 10;
