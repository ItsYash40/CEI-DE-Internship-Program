-- Week 2 SQL Assignment – Superstore Sales Analysis
-- Name: Debajyoti Bhakta
-- Date: 2026-06-26
-- Description: Complete database setup with schema and data

-- Create and use the database
CREATE DATABASE IF NOT EXISTS superstore_db;
USE superstore_db;

-- DROP TABLES (if re-running)
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS customers;

-- TABLE 1: customers
CREATE TABLE customers (
    customer_id   VARCHAR(20)  PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    segment       VARCHAR(50)  NOT NULL,   -- Consumer / Corporate / Home Office
    country       VARCHAR(50)  NOT NULL,
    city          VARCHAR(100) NOT NULL,
    state         VARCHAR(100) NOT NULL,
    postal_code   VARCHAR(20),
    region        VARCHAR(50)  NOT NULL    -- East / West / Central / South
);

-- TABLE 2: products
CREATE TABLE products (
    product_id   VARCHAR(50)  PRIMARY KEY,
    product_name VARCHAR(200) NOT NULL,
    category     VARCHAR(50)  NOT NULL,    -- Furniture / Office Supplies / Technology
    sub_category VARCHAR(50)  NOT NULL
);

-- TABLE 3: orders
CREATE TABLE orders (
    order_id      VARCHAR(30)  PRIMARY KEY,
    order_date    DATE         NOT NULL,
    ship_date     DATE         NOT NULL,
    ship_mode     VARCHAR(50)  NOT NULL,
    customer_id   VARCHAR(20)  NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- TABLE 4: order_items
CREATE TABLE order_items (
    item_id     INT           AUTO_INCREMENT PRIMARY KEY,
    order_id    VARCHAR(30)   NOT NULL,
    product_id  VARCHAR(50)   NOT NULL,
    sales       DECIMAL(10,4) NOT NULL,
    quantity    INT           NOT NULL,
    discount    DECIMAL(5,4)  NOT NULL DEFAULT 0,
    profit      DECIMAL(10,4) NOT NULL,
    FOREIGN KEY (order_id)   REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- INDEXES for query optimization
CREATE INDEX idx_orders_order_date   ON orders(order_date);
CREATE INDEX idx_orders_customer_id  ON orders(customer_id);
CREATE INDEX idx_order_items_order   ON order_items(order_id);
CREATE INDEX idx_order_items_product ON order_items(product_id);
CREATE INDEX idx_customers_region    ON customers(region);
CREATE INDEX idx_customers_segment   ON customers(segment);
CREATE INDEX idx_products_category   ON products(category);

-- INSERT: customers (30 sample rows from Superstore dataset)
INSERT INTO customers VALUES
('CG-12520','Claire Gute',        'Consumer',    'United States','Henderson',     'Kentucky',       '42420','South'),
('DV-13045','Darrin Van Huff',    'Corporate',   'United States','Los Angeles',   'California',     '90036','West'),
('SO-20335','Sean O\'Donnell',    'Consumer',    'United States','Fort Lauderdale','Florida',       '33311','South'),
('BH-11710','Brosina Hoffman',    'Consumer',    'United States','Los Angeles',   'California',     '90032','West'),
('AA-10480','Andrew Allen',       'Consumer',    'United States','Concord',        'North Carolina', '28027','South'),
('IM-15070','Irene Maddox',       'Consumer',    'United States','Seattle',        'Washington',     '98103','West'),
('HP-14815','Harold Pawlan',      'Home Office', 'United States','Fort Worth',     'Texas',          '76106','Central'),
('PK-19075','Pete Kriz',          'Consumer',    'United States','Madison',        'Wisconsin',      '53711','Central'),
('AG-10270','Alejandro Grove',    'Consumer',    'United States','West Jordan',    'Utah',           '84084','West'),
('ZD-21925','Zuschuss Donatelli', 'Consumer',    'United States','San Francisco',  'California',     '94109','West'),
('KL-16645','Ken Lonsdale',       'Corporate',   'United States','New York City',  'New York',       '10024','East'),
('RB-19360','Rick Bensley',       'Consumer',    'United States','Burlington',     'Vermont',        '05401','East'),
('JE-15715','Jim Ealy',           'Consumer',    'United States','Philadelphia',   'Pennsylvania',   '19140','East'),
('CS-12355','Chad Sievert',       'Corporate',   'United States','Chicago',        'Illinois',       '60610','Central'),
('KN-16705','Karen Narrow',       'Home Office', 'United States','Dallas',         'Texas',          '75201','Central'),
('MB-17755','Matt Bhatt',         'Corporate',   'United States','Atlanta',        'Georgia',        '30301','South'),
('GT-14635','Grant Thornton',     'Corporate',   'United States','Denver',         'Colorado',       '80202','West'),
('EW-13945','Erin Wyman',         'Consumer',    'United States','Portland',       'Oregon',         '97201','West'),
('TM-21490','Todd Mathew',        'Corporate',   'United States','Houston',        'Texas',          '77002','Central'),
('NB-18715','Nick Barnes',        'Home Office', 'United States','Miami',          'Florida',        '33101','South'),
('LS-17230','Lena Stephens',      'Consumer',    'United States','Boston',         'Massachusetts',  '02101','East'),
('PH-19045','Phil Houdyshell',    'Corporate',   'United States','Phoenix',        'Arizona',        '85001','West'),
('DP-13240','Dave Poirier',       'Consumer',    'United States','Minneapolis',    'Minnesota',      '55401','Central'),
('SC-20470','Sylvia Candelaria',  'Home Office', 'United States','San Diego',      'California',     '92101','West'),
('TR-21175','Tom Roden',          'Corporate',   'United States','Charlotte',      'North Carolina', '28201','South'),
('MV-17845','Mark Vaughn',        'Consumer',    'United States','Columbus',       'Ohio',           '43004','East'),
('JL-15775','Justin Lacourse',    'Home Office', 'United States','Nashville',      'Tennessee',      '37201','South'),
('BC-11785','Bart Cloudsley',     'Consumer',    'United States','Las Vegas',      'Nevada',         '89101','West'),
('SF-20095','Sanjit Frey',        'Corporate',   'United States','Detroit',        'Michigan',       '48201','East'),
('AL-10735','Annie Lyvyn',        'Consumer',    'United States','Baltimore',      'Maryland',       '21201','East');

-- ============================================================
-- INSERT: products (30 sample rows)
-- ============================================================
INSERT INTO products VALUES
('FUR-BO-10001798','Bush Somerset Collection Bookcase',             'Furniture',       'Bookcases'),
('FUR-CH-10000454','Hon Deluxe Fabric Upholstered Stacking Chairs', 'Furniture',       'Chairs'),
('OFF-LA-10000240','Self-Adhesive Address Labels',                   'Office Supplies', 'Labels'),
('FUR-TA-10000577','Bretford CR4500 Series Slim Rectangular Table', 'Furniture',       'Tables'),
('OFF-ST-10000760','Eldon Fold-Up Mobile Desk Accessories',         'Office Supplies', 'Storage'),
('FUR-FU-10001487','Eldon Expressions Punched Metal & Wood Folders','Furniture',       'Furnishings'),
('OFF-AR-10002833','Newell 322',                                    'Office Supplies', 'Art'),
('TEC-PH-10002275','Mitel 5320 IP Phone VoIP phone',               'Technology',      'Phones'),
('OFF-BI-10003910','DXL Angle-View Binders with Locking Rings',    'Office Supplies', 'Binders'),
('OFF-AP-10002892','Belkin F5C206VTEL 6 Outlet Surge',             'Office Supplies', 'Appliances'),
('FUR-TA-10001539','Chromcraft Rectangular Conference Tables',      'Furniture',       'Tables'),
('OFF-PA-10001569','Xerox 1967',                                    'Office Supplies', 'Paper'),
('TEC-PH-10004093','Konftel 250 Conference phone',                 'Technology',      'Phones'),
('OFF-BI-10000756','Avery 504',                                     'Office Supplies', 'Binders'),
('TEC-AC-10003832','Logitech G500s Laser Gaming Mouse',            'Technology',      'Accessories'),
('FUR-CH-10004218','Global Adaptabilities Executive Chair',         'Furniture',       'Chairs'),
('TEC-CO-10004722','Apple MacBook Pro 15"',                        'Technology',      'Machines'),
('TEC-CO-10001970','Cisco TelePresence System EX90',               'Technology',      'Machines'),
('OFF-EN-10001509','Staple envelope',                               'Office Supplies', 'Envelopes'),
('OFF-FA-10000304','Fiskars 8" Scissors',                          'Office Supplies', 'Fasteners'),
('FUR-FU-10004158','Seth Thomas Clock (Set of 6)',                  'Furniture',       'Furnishings'),
('OFF-ST-10004186','Fellowes Super Stor/Drawer',                    'Office Supplies', 'Storage'),
('TEC-AC-10001227','Logitech Wireless Combo MK270',                'Technology',      'Accessories'),
('OFF-LA-10002762','Avery 506',                                     'Office Supplies', 'Labels'),
('FUR-BO-10004834','O\'Sullivan Plantations 2-Door Library',        'Furniture',       'Bookcases'),
('OFF-PA-10003169','Enermax Note Cards',                            'Office Supplies', 'Paper'),
('TEC-PH-10001530','Plantronics CS510',                            'Technology',      'Phones'),
('OFF-BI-10004738','GBC DocuBind P400 Electric Binding System',    'Office Supplies', 'Binders'),
('FUR-TA-10003542','Bevis 36 x 72 Conference Tables',              'Furniture',       'Tables'),
('TEC-AC-10002167','Belkin 7-Outlet Metallic Surge Strip',         'Technology',      'Accessories');

-- INSERT: orders (40 sample rows)
INSERT INTO orders VALUES
('CA-2021-152156','2021-11-08','2021-11-11','Second Class', 'CG-12520'),
('CA-2021-152157','2021-11-08','2021-11-11','Second Class', 'DV-13045'),
('CA-2021-138688','2021-06-12','2021-06-16','Second Class', 'SO-20335'),
('US-2020-108966','2020-10-11','2020-10-18','Standard Class','BH-11710'),
('US-2020-108967','2020-10-11','2020-10-18','Standard Class','AA-10480'),
('CA-2021-115812','2021-06-09','2021-06-14','Standard Class','IM-15070'),
('CA-2021-115813','2021-06-09','2021-06-14','First Class',  'HP-14815'),
('CA-2020-105893','2020-03-14','2020-03-18','Standard Class','PK-19075'),
('CA-2020-167164','2020-01-28','2020-02-03','Second Class', 'AG-10270'),
('CA-2022-143336','2022-08-27','2022-09-01','Second Class', 'ZD-21925'),
('CA-2022-143337','2022-08-27','2022-09-01','Same Day',     'KL-16645'),
('CA-2022-160782','2022-12-09','2022-12-13','Standard Class','RB-19360'),
('CA-2021-119823','2021-04-15','2021-04-20','First Class',  'JE-15715'),
('CA-2021-135069','2021-09-22','2021-09-27','Standard Class','CS-12355'),
('CA-2021-135070','2021-09-22','2021-09-27','Second Class', 'KN-16705'),
('US-2020-118983','2020-11-22','2020-11-26','Standard Class','MB-17755'),
('CA-2022-100391','2022-03-17','2022-03-22','Second Class', 'GT-14635'),
('CA-2022-100392','2022-03-17','2022-03-22','Standard Class','EW-13945'),
('CA-2023-112220','2023-06-05','2023-06-09','First Class',  'TM-21490'),
('CA-2023-112221','2023-06-05','2023-06-09','Standard Class','NB-18715'),
('CA-2023-145317','2023-11-30','2023-12-04','Second Class', 'LS-17230'),
('CA-2022-167199','2022-07-19','2022-07-23','First Class',  'PH-19045'),
('CA-2022-167200','2022-07-19','2022-07-23','Standard Class','DP-13240'),
('CA-2023-102925','2023-02-08','2023-02-12','Second Class', 'SC-20470'),
('CA-2023-102926','2023-02-08','2023-02-12','Same Day',     'TR-21175'),
('CA-2021-127180','2021-07-31','2021-08-05','Second Class', 'MV-17845'),
('CA-2022-140839','2022-05-23','2022-05-28','Standard Class','JL-15775'),
('CA-2020-134515','2020-09-04','2020-09-08','First Class',  'BC-11785'),
('CA-2023-118255','2023-04-11','2023-04-16','Standard Class','SF-20095'),
('CA-2023-118256','2023-04-11','2023-04-16','Second Class', 'AL-10735'),
('CA-2022-155363','2022-02-14','2022-02-19','Standard Class','CG-12520'),
('CA-2021-163265','2021-12-01','2021-12-06','Second Class', 'DV-13045'),
('CA-2023-170310','2023-08-17','2023-08-21','First Class',  'SO-20335'),
('CA-2020-143259','2020-05-30','2020-06-04','Standard Class','BH-11710'),
('CA-2023-122428','2023-10-22','2023-10-26','Second Class', 'KL-16645'),
('CA-2021-107727','2021-03-18','2021-03-23','Standard Class','CS-12355'),
('CA-2022-179980','2022-10-05','2022-10-09','First Class',  'MB-17755'),
('CA-2020-195725','2020-08-12','2020-08-16','Standard Class','GT-14635'),
('CA-2023-138897','2023-09-14','2023-09-18','Second Class', 'TM-21490'),
('CA-2022-112244','2022-06-28','2022-07-03','Standard Class','LS-17230');

-- ============================================================
-- INSERT: order_items (60 sample rows)
-- ============================================================
INSERT INTO order_items (order_id, product_id, sales, quantity, discount, profit) VALUES
('CA-2021-152156','FUR-BO-10001798', 261.9600, 2, 0.00,  41.9136),
('CA-2021-152156','FUR-CH-10000454', 731.9400, 3, 0.00, 219.5820),
('CA-2021-152157','OFF-LA-10000240',  14.6200, 2, 0.00,   6.8714),
('CA-2021-138688','FUR-TA-10000577', 957.5775, 5, 0.45,-383.0310),
('CA-2021-138688','OFF-ST-10000760',  22.3680, 2, 0.20,   2.5164),
('CA-2021-138688','FUR-FU-10001487',  48.8600, 7, 0.00,  14.1694),
('US-2020-108966','OFF-AR-10002833',   7.2800, 4, 0.00,   1.9656),
('US-2020-108966','TEC-PH-10002275', 907.1520, 6, 0.20,  90.7152),
('US-2020-108966','OFF-BI-10003910',  18.5040, 3, 0.20,   5.7825),
('US-2020-108967','OFF-AP-10002892', 114.9000, 5, 0.00,  34.4700),
('CA-2021-115812','FUR-TA-10001539',1706.1840, 9, 0.20, 85.3092),
('CA-2021-115812','OFF-PA-10001569',  22.3680, 2, 0.20,   4.4736),
('CA-2021-115813','TEC-PH-10004093', 911.4240, 4, 0.20, 68.3568),
('CA-2021-115813','OFF-BI-10000756',  18.5040, 3, 0.20,  -3.7972),
('CA-2020-105893','TEC-AC-10003832',  29.6000, 2, 0.00,  12.6640),
('CA-2020-167164','FUR-CH-10004218', 288.3750, 5, 0.00, 103.8150),
('CA-2022-143336','TEC-CO-10004722',4099.9900, 2, 0.00, 819.9980),
('CA-2022-143336','OFF-EN-10001509',  16.4480, 4, 0.20,   5.5523),
('CA-2022-143337','OFF-FA-10000304',   4.6900, 2, 0.00,   1.6886),
('CA-2022-143337','FUR-FU-10004158', 102.0000, 2, 0.00,  25.0290),
('CA-2022-160782','OFF-ST-10004186',  99.9600, 2, 0.00,  29.9880),
('CA-2022-160782','TEC-AC-10001227',  72.7740, 3, 0.20,   2.8280),
('CA-2021-119823','OFF-LA-10002762',  26.4000, 6, 0.10,  10.3950),
('CA-2021-119823','FUR-BO-10004834', 120.3700, 1, 0.00,  35.2289),
('CA-2021-135069','OFF-PA-10003169',  22.3680, 2, 0.20,   5.5920),
('CA-2021-135070','TEC-PH-10001530', 499.9900, 1, 0.00, 149.9970),
('US-2020-118983','OFF-BI-10004738', 549.9800, 2, 0.00, 219.9920),
('CA-2022-100391','FUR-TA-10003542', 380.1600, 4, 0.20,  19.0080),
('CA-2022-100392','TEC-AC-10002167',  24.9600, 2, 0.00,   6.8640),
('CA-2023-112220','FUR-CH-10004218', 432.7500, 5, 0.25,  -7.5938),
('CA-2023-112221','TEC-CO-10004722',2499.9900, 1, 0.00, 499.9980),
('CA-2023-145317','OFF-LA-10000240',  48.4800, 6, 0.10,  19.8000),
('CA-2022-167199','FUR-BO-10001798', 523.9200, 4, 0.00,  83.8272),
('CA-2022-167200','OFF-ST-10000760',  44.7360, 4, 0.20,   5.0328),
('CA-2023-102925','TEC-PH-10002275',1360.7280, 9, 0.20, 136.0728),
('CA-2023-102926','FUR-TA-10000577', 383.0310, 2, 0.45,-153.2124),
('CA-2021-127180','OFF-AR-10002833',  18.2000, 7, 0.00,   4.9140),
('CA-2022-140839','TEC-AC-10003832',  59.2000, 4, 0.00,  25.3280),
('CA-2020-134515','FUR-CH-10000454', 487.9600, 2, 0.00, 146.3880),
('CA-2023-118255','OFF-PA-10001569',  44.7360, 4, 0.20,   8.9472),
('CA-2023-118256','TEC-PH-10004093', 455.7120, 2, 0.20,  34.1784),
('CA-2022-155363','FUR-FU-10001487', 209.6700, 3, 0.30,  14.1694),
('CA-2021-163265','OFF-BI-10003910',  37.0080, 6, 0.20,  11.5650),
('CA-2023-170310','TEC-CO-10004722',1999.9900, 1, 0.00, 399.9980),
('CA-2020-143259','OFF-AP-10002892',  45.9600, 2, 0.00,  13.7880),
('CA-2023-122428','FUR-BO-10004834', 240.7400, 2, 0.00,  70.4578),
('CA-2021-107727','TEC-AC-10001227', 121.2900, 5, 0.20,   4.7125),
('CA-2022-179980','OFF-ST-10004186', 199.9200, 4, 0.00,  59.9760),
('CA-2020-195725','FUR-TA-10001539', 568.7280, 3, 0.20,  28.4364),
('CA-2023-138897','TEC-PH-10001530', 999.9800, 2, 0.00, 299.9940),
('CA-2022-112244','OFF-EN-10001509',  41.1200, 10,0.20,  13.8780),
('CA-2021-152156','TEC-AC-10002167',  37.4400, 3, 0.00,  10.3060),
('CA-2021-138688','TEC-CO-10001970',7999.9800, 2, 0.00,1599.9960),
('US-2020-108966','FUR-CH-10004218', 576.7500, 5, 0.25, -10.1344),
('CA-2022-143336','OFF-BI-10000756',  27.7560, 3, 0.20,  -5.6956),
('CA-2021-135069','FUR-BO-10001798', 523.9200, 4, 0.00,  83.8272),
('CA-2023-102925','OFF-ST-10004186', 149.9400, 3, 0.00,  44.9820),
('CA-2021-107727','FUR-TA-10003542', 570.2400, 6, 0.20,  28.5120),
('CA-2022-179980','TEC-PH-10002275', 453.5760, 3, 0.20,  45.3576),
('CA-2020-195725','OFF-PA-10003169',  44.7360, 4, 0.20,  11.1840);

-- ============================================================
-- VERIFICATION QUERIES
-- ============================================================
SELECT 'customers'   AS table_name, COUNT(*) AS row_count FROM customers  UNION ALL
SELECT 'products'    AS table_name, COUNT(*) AS row_count FROM products   UNION ALL
SELECT 'orders'      AS table_name, COUNT(*) AS row_count FROM orders     UNION ALL
SELECT 'order_items' AS table_name, COUNT(*) AS row_count FROM order_items;