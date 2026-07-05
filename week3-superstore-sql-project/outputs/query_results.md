# Query Results

**Query 1**

| order_id | customer_id | customer_name | sales |
|---|---|---|---|
| US-2019-100036 | CU-10017 | Sam Baker | 14136.08 |
| US-2022-100283 | CU-10024 | Sara Young | 13622.47 |
| US-2022-100083 | CU-10044 | Ethan Brown | 13547.55 |
| US-2022-100307 | CU-10039 | Lucas Harris | 12811.87 |
| US-2022-100023 | CU-10059 | Tara Green | 12590.0 |
| US-2020-100205 | CU-10055 | Zoe Wilson | 12376.21 |
| US-2020-100273 | CU-10038 | Sam Walker | 12320.08 |
| US-2019-100148 | CU-10038 | Sam Walker | 12266.43 |
| US-2019-100188 | CU-10049 | Ravi Baker | 11426.32 |
| US-2019-100232 | CU-10006 | Ethan King | 11361.82 |
| US-2022-100011 | CU-10042 | David Martin | 10602.18 |
| US-2020-100277 | CU-10003 | Chloe Green | 10527.7 |
| US-2020-100057 | CU-10051 | Ava Baker | 10442.64 |
| US-2021-100294 | CU-10043 | David Jackson | 10284.31 |
| US-2021-100018 | CU-10025 | Chloe Anderson | 10282.13 |



**Query 2**

| customer_id | customer_name | order_id | highest_order_sales |
|---|---|---|---|
| CU-10017 | Sam Baker | US-2019-100036 | 14136.08 |
| CU-10024 | Sara Young | US-2022-100283 | 13622.47 |
| CU-10044 | Ethan Brown | US-2022-100083 | 13547.55 |
| CU-10039 | Lucas Harris | US-2022-100307 | 12811.87 |
| CU-10059 | Tara Green | US-2022-100023 | 12590.0 |
| CU-10055 | Zoe Wilson | US-2020-100205 | 12376.21 |
| CU-10038 | Sam Walker | US-2020-100273 | 12320.08 |
| CU-10049 | Ravi Baker | US-2019-100188 | 11426.32 |
| CU-10006 | Ethan King | US-2019-100232 | 11361.82 |
| CU-10042 | David Martin | US-2022-100011 | 10602.18 |
| CU-10003 | Chloe Green | US-2020-100277 | 10527.7 |
| CU-10051 | Ava Baker | US-2020-100057 | 10442.64 |
| CU-10043 | David Jackson | US-2021-100294 | 10284.31 |
| CU-10025 | Chloe Anderson | US-2021-100018 | 10282.13 |
| CU-10028 | Ethan Brown | US-2020-100097 | 9970.48 |


**Query 3**

| customer_id | total_sales |
|---|---|
| CU-10042 | 62470.590000000004 |
| CU-10043 | 61183.52 |
| CU-10029 | 55051.43 |
| CU-10055 | 54636.34 |
| CU-10048 | 53246.81 |
| CU-10039 | 49595.97 |
| CU-10040 | 49491.27 |
| CU-10049 | 43726.8 |
| CU-10059 | 42950.62 |
| CU-10038 | 42002.64 |
| CU-10017 | 40624.2 |
| CU-10019 | 35925.65 |
| CU-10002 | 34181.52 |
| CU-10023 | 33468.950000000004 |
| CU-10007 | 32979.76 |



## 04_ctes.sql


**Query 1**

| customer_id | customer_name | total_sales | total_profit | order_count | avg_order_value |
|---|---|---|---|---|---|
| CU-10042 | David Martin | 62470.590000000004 | 8452.25 | 14 | 2313.73 |
| CU-10043 | David Jackson | 61183.52 | 2955.37 | 12 | 3059.18 |
| CU-10029 | David Thomas | 55051.43 | -1226.6 | 7 | 3238.32 |
| CU-10055 | Zoe Wilson | 54636.34 | 7581.53 | 9 | 3035.35 |
| CU-10048 | Wei Davis | 53246.81 | 5358.05 | 13 | 2047.95 |
| CU-10039 | Lucas Harris | 49595.97 | 4734.0 | 9 | 2610.31 |
| CU-10040 | Elena Jackson | 49491.27 | 5669.36 | 13 | 2356.73 |
| CU-10049 | Ravi Baker | 43726.8 | 2067.38 | 5 | 4858.53 |
| CU-10059 | Tara Green | 42950.62 | 7526.26 | 8 | 2684.41 |
| CU-10038 | Sam Walker | 42002.64 | 1800.3799999999999 | 9 | 3230.97 |
| CU-10017 | Sam Baker | 40624.2 | 1146.2900000000002 | 9 | 2901.73 |
| CU-10019 | Aarav Clark | 35925.65 | 2816.36 | 4 | 4490.71 |
| CU-10002 | Omar Garcia | 34181.52 | 5283.64 | 7 | 2629.35 |
| CU-10023 | Sam Thomas | 33468.950000000004 | 3045.6 | 7 | 2091.81 |
| CU-10007 | Ava Anderson | 32979.76 | 4819.25 | 9 | 2355.7 |



**Query 2**

| customer_id | customer_name | total_sales | avg_customer_sales | diff_from_avg |
|---|---|---|---|---|
| CU-10042 | David Martin | 62470.590000000004 | 24184.032545454545 | 38286.56 |
| CU-10043 | David Jackson | 61183.52 | 24184.032545454545 | 36999.49 |
| CU-10029 | David Thomas | 55051.43 | 24184.032545454545 | 30867.4 |
| CU-10055 | Zoe Wilson | 54636.34 | 24184.032545454545 | 30452.31 |
| CU-10048 | Wei Davis | 53246.81 | 24184.032545454545 | 29062.78 |
| CU-10039 | Lucas Harris | 49595.97 | 24184.032545454545 | 25411.94 |
| CU-10040 | Elena Jackson | 49491.27 | 24184.032545454545 | 25307.24 |
| CU-10049 | Ravi Baker | 43726.8 | 24184.032545454545 | 19542.77 |
| CU-10059 | Tara Green | 42950.62 | 24184.032545454545 | 18766.59 |
| CU-10038 | Sam Walker | 42002.64 | 24184.032545454545 | 17818.61 |
| CU-10017 | Sam Baker | 40624.2 | 24184.032545454545 | 16440.17 |
| CU-10019 | Aarav Clark | 35925.65 | 24184.032545454545 | 11741.62 |
| CU-10002 | Omar Garcia | 34181.52 | 24184.032545454545 | 9997.49 |
| CU-10023 | Sam Thomas | 33468.950000000004 | 24184.032545454545 | 9284.92 |
| CU-10007 | Ava Anderson | 32979.76 | 24184.032545454545 | 8795.73 |



**Query 3**

| category | category_sales | category_profit | line_items |
|---|---|---|---|
| Technology | 722924.52 | 58565.04 | 160 |
| Furniture | 459002.43 | 56658.520000000004 | 139 |
| Office Supplies | 148194.84 | 12054.04 | 221 |



## 05_window_functions.sql


**Query 1**

| order_id | customer_id | sales | row_num | rank_num | dense_rank_num |
|---|---|---|---|---|---|
| US-2019-100036 | CU-10017 | 14136.08 | 1 | 1 | 1 |
| US-2022-100283 | CU-10024 | 13622.47 | 2 | 2 | 2 |
| US-2022-100083 | CU-10044 | 13547.55 | 3 | 3 | 3 |
| US-2022-100307 | CU-10039 | 12811.87 | 4 | 4 | 4 |
| US-2022-100023 | CU-10059 | 12590.0 | 5 | 5 | 5 |
| US-2020-100205 | CU-10055 | 12376.21 | 6 | 6 | 6 |
| US-2020-100273 | CU-10038 | 12320.08 | 7 | 7 | 7 |
| US-2019-100148 | CU-10038 | 12266.43 | 8 | 8 | 8 |
| US-2019-100188 | CU-10049 | 11426.32 | 9 | 9 | 9 |
| US-2019-100232 | CU-10006 | 11361.82 | 10 | 10 | 10 |
| US-2022-100011 | CU-10042 | 10602.18 | 11 | 11 | 11 |
| US-2020-100277 | CU-10003 | 10527.7 | 12 | 12 | 12 |
| US-2020-100057 | CU-10051 | 10442.64 | 13 | 13 | 13 |
| US-2021-100294 | CU-10043 | 10284.31 | 14 | 14 | 14 |
| US-2021-100018 | CU-10025 | 10282.13 | 15 | 15 | 15 |


**Query 2**

| customer_id | order_id | sales | order_rank_for_customer |
|---|---|---|---|
| CU-10001 | US-2022-100151 | 8285.31 | 1 |
| CU-10001 | US-2021-100002 | 5931.87 | 2 |
| CU-10001 | US-2022-100251 | 1381.44 | 3 |
| CU-10001 | US-2022-100151 | 1028.83 | 4 |
| CU-10001 | US-2022-100251 | 773.31 | 5 |
| CU-10001 | US-2022-100151 | 681.3 | 6 |
| CU-10001 | US-2021-100002 | 390.72 | 7 |
| CU-10001 | US-2019-100260 | 217.71 | 8 |
| CU-10001 | US-2021-100234 | 115.04 | 9 |
| CU-10002 | US-2021-100182 | 8857.17 | 1 |
| CU-10002 | US-2021-100102 | 6889.4 | 2 |
| CU-10002 | US-2020-100049 | 5694.6 | 3 |
| CU-10002 | US-2021-100102 | 3057.72 | 4 |
| CU-10002 | US-2020-100049 | 2186.46 | 5 |
| CU-10002 | US-2021-100066 | 1809.47 | 6 |


**Query 3**

| customer_id | customer_name | total_sales | sales_rank | sales_dense_rank | sales_quartile |
|---|---|---|---|---|---|
| CU-10042 | David Martin | 62470.590000000004 | 1 | 1 | 1 |
| CU-10043 | David Jackson | 61183.52 | 2 | 2 | 1 |
| CU-10029 | David Thomas | 55051.43 | 3 | 3 | 1 |
| CU-10055 | Zoe Wilson | 54636.34 | 4 | 4 | 1 |
| CU-10048 | Wei Davis | 53246.81 | 5 | 5 | 1 |
| CU-10039 | Lucas Harris | 49595.97 | 6 | 6 | 1 |
| CU-10040 | Elena Jackson | 49491.27 | 7 | 7 | 1 |
| CU-10049 | Ravi Baker | 43726.8 | 8 | 8 | 1 |
| CU-10059 | Tara Green | 42950.62 | 9 | 9 | 1 |
| CU-10038 | Sam Walker | 42002.64 | 10 | 10 | 1 |
| CU-10017 | Sam Baker | 40624.2 | 11 | 11 | 1 |
| CU-10019 | Aarav Clark | 35925.65 | 12 | 12 | 1 |
| CU-10002 | Omar Garcia | 34181.52 | 13 | 13 | 1 |
| CU-10023 | Sam Thomas | 33468.950000000004 | 14 | 14 | 1 |
| CU-10007 | Ava Anderson | 32979.76 | 15 | 15 | 2 |


**Query 4**

| customer_id | order_id | order_date | sales | running_total_sales |
|---|---|---|---|---|
| CU-10001 | US-2021-100002 | 2020-03-06 | 5931.87 | 5931.87 |
| CU-10001 | US-2021-100002 | 2020-03-06 | 390.72 | 6322.59 |
| CU-10001 | US-2019-100260 | 2020-04-08 | 217.71 | 6540.3 |
| CU-10001 | US-2021-100234 | 2020-08-26 | 115.04 | 6655.34 |
| CU-10001 | US-2022-100151 | 2021-02-03 | 8285.31 | 14940.65 |
| CU-10001 | US-2022-100151 | 2021-02-03 | 1028.83 | 15969.48 |
| CU-10001 | US-2022-100151 | 2021-02-03 | 681.3 | 16650.78 |
| CU-10001 | US-2022-100251 | 2022-02-23 | 1381.44 | 18032.22 |
| CU-10001 | US-2022-100251 | 2022-02-23 | 773.31 | 18805.53 |
| CU-10002 | US-2020-100197 | 2019-03-23 | 1057.49 | 1057.49 |
| CU-10002 | US-2020-100049 | 2019-08-26 | 607.1 | 1664.5900000000001 |
| CU-10002 | US-2020-100049 | 2019-08-26 | 2186.46 | 3851.05 |
| CU-10002 | US-2020-100049 | 2019-08-26 | 5694.6 | 9545.65 |
| CU-10002 | US-2021-100182 | 2020-12-14 | 420.98 | 9966.630000000001 |
| CU-10002 | US-2021-100182 | 2020-12-14 | 8857.17 | 18823.8 |



**Query 5**

| customer_id | order_id | order_date | sales | previous_order_sales | change_vs_previous_order |
|---|---|---|---|---|---|
| CU-10001 | US-2021-100002 | 2020-03-06 | 5931.87 | None | None |
| CU-10001 | US-2021-100002 | 2020-03-06 | 390.72 | 5931.87 | -5541.15 |
| CU-10001 | US-2019-100260 | 2020-04-08 | 217.71 | 390.72 | -173.01 |
| CU-10001 | US-2021-100234 | 2020-08-26 | 115.04 | 217.71 | -102.67 |
| CU-10001 | US-2022-100151 | 2021-02-03 | 8285.31 | 115.04 | 8170.27 |
| CU-10001 | US-2022-100151 | 2021-02-03 | 1028.83 | 8285.31 | -7256.48 |
| CU-10001 | US-2022-100151 | 2021-02-03 | 681.3 | 1028.83 | -347.53 |
| CU-10001 | US-2022-100251 | 2022-02-23 | 1381.44 | 681.3 | 700.14 |
| CU-10001 | US-2022-100251 | 2022-02-23 | 773.31 | 1381.44 | -608.13 |
| CU-10002 | US-2020-100197 | 2019-03-23 | 1057.49 | None | None |
| CU-10002 | US-2020-100049 | 2019-08-26 | 607.1 | 1057.49 | -450.39 |
| CU-10002 | US-2020-100049 | 2019-08-26 | 2186.46 | 607.1 | 1579.36 |
| CU-10002 | US-2020-100049 | 2019-08-26 | 5694.6 | 2186.46 | 3508.14 |
| CU-10002 | US-2021-100182 | 2020-12-14 | 420.98 | 5694.6 | -5273.62 |
| CU-10002 | US-2021-100182 | 2020-12-14 | 8857.17 | 420.98 | 8436.19 |


## 06_combined_customer_ranking.sql


**Query 1**

| customer_id | customer_name | segment | region | total_sales | total_profit | order_count | sales_rank |
|---|---|---|---|---|---|---|---|
| CU-10042 | David Martin | Home Office | West | 62470.590000000004 | 8452.25 | 14 | 1 |
| CU-10043 | David Jackson | Home Office | Central | 61183.52 | 2955.37 | 12 | 2 |
| CU-10029 | David Thomas | Consumer | East | 55051.43 | -1226.6 | 7 | 3 |
| CU-10055 | Zoe Wilson | Home Office | West | 54636.34 | 7581.53 | 9 | 4 |
| CU-10048 | Wei Davis | Consumer | West | 53246.81 | 5358.05 | 13 | 5 |
| CU-10039 | Lucas Harris | Consumer | West | 49595.97 | 4734.0 | 9 | 6 |
| CU-10040 | Elena Jackson | Consumer | East | 49491.27 | 5669.36 | 13 | 7 |
| CU-10049 | Ravi Baker | Corporate | West | 43726.8 | 2067.38 | 5 | 8 |
| CU-10059 | Tara Green | Consumer | West | 42950.62 | 7526.26 | 8 | 9 |
| CU-10038 | Sam Walker | Corporate | South | 42002.64 | 1800.3799999999999 | 9 | 10 |
| CU-10017 | Sam Baker | Corporate | Central | 40624.2 | 1146.2900000000002 | 9 | 11 |
| CU-10019 | Aarav Clark | Corporate | Central | 35925.65 | 2816.36 | 4 | 12 |
| CU-10002 | Omar Garcia | Corporate | Central | 34181.52 | 5283.64 | 7 | 13 |
| CU-10023 | Sam Thomas | Consumer | East | 33468.950000000004 | 3045.6 | 7 | 14 |
| CU-10007 | Ava Anderson | Corporate | Central | 32979.76 | 4819.25 | 9 | 15 |




**Query 2**

| customer_id | customer_name | segment | region | total_sales | total_profit | order_count | sales_rank |
|---|---|---|---|---|---|---|---|
| CU-10042 | David Martin | Home Office | West | 62470.590000000004 | 8452.25 | 14 | 1 |
| CU-10043 | David Jackson | Home Office | Central | 61183.52 | 2955.37 | 12 | 2 |
| CU-10029 | David Thomas | Consumer | East | 55051.43 | -1226.6 | 7 | 3 |
| CU-10055 | Zoe Wilson | Home Office | West | 54636.34 | 7581.53 | 9 | 4 |
| CU-10048 | Wei Davis | Consumer | West | 53246.81 | 5358.05 | 13 | 5 |
| CU-10039 | Lucas Harris | Consumer | West | 49595.97 | 4734.0 | 9 | 6 |
| CU-10040 | Elena Jackson | Consumer | East | 49491.27 | 5669.36 | 13 | 7 |
| CU-10049 | Ravi Baker | Corporate | West | 43726.8 | 2067.38 | 5 | 8 |
| CU-10059 | Tara Green | Consumer | West | 42950.62 | 7526.26 | 8 | 9 |
| CU-10038 | Sam Walker | Corporate | South | 42002.64 | 1800.3799999999999 | 9 | 10 |



**Query 3**

| customer_id | customer_name | segment | region | total_sales | order_count | bottom_rank |
|---|---|---|---|---|---|---|
| CU-10036 | Elena Thomas | Consumer | East | 230.1 | 1 | 1 |
| CU-10050 | Fatima Walker | Home Office | Central | 599.84 | 1 | 2 |
| CU-10032 | Liam Green | Consumer | West | 2074.5 | 2 | 3 |
| CU-10056 | Sam Johnson | Consumer | Central | 2399.88 | 2 | 4 |
| CU-10031 | Aarav Young | Corporate | West | 2870.79 | 2 | 5 |
| CU-10054 | Mia Patel | Consumer | Central | 3077.06 | 1 | 6 |
| CU-10011 | Emily Walker | Corporate | Central | 3667.35 | 2 | 7 |
| CU-10010 | Liam Miller | Consumer | South | 5235.4800000000005 | 2 | 8 |
| CU-10045 | Kevin King | Home Office | West | 6382.61 | 3 | 9 |
| CU-10052 | Lucas Sharma | Consumer | Central | 7388.91 | 3 | 10 |



**Query 4**

| customer_id | customer_name | segment | order_count | total_sales |
|---|---|---|---|---|
| CU-10016 | Rahul Jackson | Home Office | 1 | 9851.5 |
| CU-10054 | Mia Patel | Consumer | 1 | 3077.06 |
| CU-10050 | Fatima Walker | Home Office | 1 | 599.84 |
| CU-10036 | Elena Thomas | Consumer | 1 | 230.1 |



**Query 5**

| customer_id | customer_name | segment | total_sales | avg_customer_sales |
|---|---|---|---|---|
| CU-10042 | David Martin | Home Office | 62470.590000000004 | 24184.03 |
| CU-10043 | David Jackson | Home Office | 61183.52 | 24184.03 |
| CU-10029 | David Thomas | Consumer | 55051.43 | 24184.03 |
| CU-10055 | Zoe Wilson | Home Office | 54636.34 | 24184.03 |
| CU-10048 | Wei Davis | Consumer | 53246.81 | 24184.03 |
| CU-10039 | Lucas Harris | Consumer | 49595.97 | 24184.03 |
| CU-10040 | Elena Jackson | Consumer | 49491.27 | 24184.03 |
| CU-10049 | Ravi Baker | Corporate | 43726.8 | 24184.03 |
| CU-10059 | Tara Green | Consumer | 42950.62 | 24184.03 |
| CU-10038 | Sam Walker | Corporate | 42002.64 | 24184.03 |
| CU-10017 | Sam Baker | Corporate | 40624.2 | 24184.03 |
| CU-10019 | Aarav Clark | Corporate | 35925.65 | 24184.03 |
| CU-10002 | Omar Garcia | Corporate | 34181.52 | 24184.03 |
| CU-10023 | Sam Thomas | Consumer | 33468.950000000004 | 24184.03 |
| CU-10007 | Ava Anderson | Corporate | 32979.76 | 24184.03 |

