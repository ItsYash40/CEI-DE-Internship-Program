# ⚡ Spark Questions — Week 5 Assignment

## Name:  Debajyoti Bhakta _ SOA 

> Understand Apache Spark fundamentals and perform data cleaning, transformation, and aggregation using DataFrames — built and executed with **PySpark**.

![Apache Spark](https://img.shields.io/badge/Apache%20Spark-4.2.0-E25A1C?style=flat&logo=apachespark&logoColor=white)
![Python](https://img.shields.io/badge/Python-3.12-3776AB?style=flat&logo=python&logoColor=white)
![Status](https://img.shields.io/badge/status-completed-brightgreen)
![License](https://img.shields.io/badge/license-MIT-lightgrey)

---

## 📌 Overview

This project builds a complete PySpark pipeline over a synthetic
**customer sales dataset** (intentionally messy — duplicates, nulls,
inconsistent casing, bad ages, mixed types) and walks through every stage
of the assignment: cleaning → filtering → transforming → aggregating →
grouping, finishing with a single reusable pipeline function.

```
Load CSV → Clean (dedupe, nulls, casing, type fixes)
        → Filter (age / category / region)
        → Transform (rename, cast)
        → Aggregate (count, sum, avg, min, max)
        → Group (region × category, with HAVING-style conditions)
        → Save results.csv
```

---

## 🗂️ Folder Structure

```
spark-assignment/
│
├── README.md                    ← you are here
│
├── data/
│   └── dataset.csv              ← synthetic, intentionally messy sample dataset (315 rows)
│
├── notebook/
│   └── spark_basics.ipynb       ← full walkthrough notebook, already executed with real output
│
├── output/
    └── results.csv              ← final aggregated pipeline output 

```

---

## ⚙️ Prerequisites

- Python 3.9+
- Java 8/11/17/21 (required by Spark — check with `java -version`)
- pip packages: `pyspark`, `pandas`, `numpy`, `jupyter`, `nbconvert` *(only needed if you want to regenerate the notebook/data yourself)*

```bash
pip install pyspark pandas numpy jupyter nbconvert
```

---

## 🚀 Quick Start

### Option A — Just open the notebook
`notebook/spark_basics.ipynb` is **already executed** with real Spark
output embedded — open it in Jupyter/VS Code and read straight through, no
setup needed beyond viewing it.

```bash
jupyter notebook notebook/spark_basics.ipynb
```

### Option B — Run the standalone pipeline script
```bash
cd spark-assignment
python3 src/spark_pipeline.py
```
This runs the full pipeline end-to-end and writes `output/results.csv`.

### Option C — Regenerate everything from scratch
```bash
python3 src/generate_dataset.py     # rebuilds data/dataset.csv
python3 src/build_notebook.py       # rebuilds an unexecuted notebook
jupyter nbconvert --to notebook --execute --inplace notebook/spark_basics.ipynb
```

---

## 🧩 Dataset

`data/dataset.csv` — 315 rows of synthetic customer-sales data:

| Column | Type | Notes |
|---|---|---|
| `customer_id` | int | unique ID |
| `name` | string | synthetic name |
| `age` | mixed (int/string) | **intentionally dirty**: some nulls, some out-of-range (`-5`, `150`, `0`, `999`), some as `" 47 "` strings |
| `category` | string | `Electronics / Clothing / Grocery / Furniture / Toys`, with inconsistent casing and empty strings |
| `region` | string | `North / South / East / West / Central`, with inconsistent casing and nulls |
| `sales_amount` | float | transaction amount |
| `join_date` | date | customer join date |

Plus **15 exact duplicate rows** injected to exercise deduplication.

---

## 🔍 What the Pipeline Does

### 1. MapReduce vs Spark (concept)
MapReduce writes intermediate results to disk between every stage —
reliable but slow. Spark keeps data **in-memory** and builds an optimized
DAG of transformations, making it typically **10–100x faster** for
multi-stage or iterative jobs, with a much simpler DataFrame API.

### 2–3. Start Spark & Load Data
Creates a local `SparkSession` and loads the CSV with schema inference,
inspecting `.show()`, `.columns`, and `.printSchema()`.

### 4. Data Cleaning
- Drops **15 exact duplicate rows**
- Fixes the `age` column's mixed string/numeric type (cast → trim → cast)
- Converts empty-string categories to nulls
- Standardizes inconsistent casing (`"ELECTRONICS"` → `Electronics`)
- Nulls out unrealistic ages (`≤0` or `>100`)
- **Drops** rows still missing `age` (critical field); **fills** missing
  `region`/`category` with `"Unknown"` (keeps more usable rows)

### 5. Filtering
Age range (25–45), category (`Electronics`), region (`North`), and a
combined multi-condition filter.

### 6. Transformation
Renames `sales_amount` → `total_sales`; casts `age` to `IntegerType` and
`total_sales` to a rounded `DoubleType`.

### 7. Aggregation
`count`, `avg`, `min`, `max`, `sum` across the whole cleaned dataset.

### 8. Grouping
`groupBy("category")`, `groupBy("region")`, and `groupBy("region", "category")`
with a **HAVING-style condition** applied after aggregation (`num_customers > 5`).

### 9. Wide Transformations & Shuffle (concept)
`groupBy().agg()` is a **wide transformation** — it requires a **shuffle**
(data movement across partitions), visible as `Exchange` in
`df.explain()`. `filter()`/`withColumn()` are **narrow transformations**
with no shuffle.

### 10. Complete Pipeline
Everything above chained into one `run_pipeline()` function: Load → Clean
→ Filter → Transform → Aggregate → Group → Save.

---

## 📊 Sample Result (`output/results.csv`)

| region | category | num_customers | avg_sales | total_sales_sum | avg_age |
|---|---|---|---|---|---|
| South | Clothing | 19 | 309.73 | 5884.94 | 40.0 |
| Central | Furniture | 14 | 383.04 | 5362.60 | 47.6 |
| South | Toys | 15 | 254.05 | 3810.75 | 40.2 |
| East | Clothing | 14 | 219.34 | 3070.74 | 40.6 |
| Central | Electronics | 10 | 290.19 | 2901.87 | 34.1 |

*(33 total region × category groups — see the full file for all rows.)*

---

## 💡 Insights & Observations

1. **Cleaning impact**: of 315 raw rows, 15 were exact duplicates and a
   further set had unusable/out-of-range ages — after cleaning, the
   dataset was ready for reliable aggregation.
2. **Casing bugs are silent killers**: without standardizing
   `"ELECTRONICS"` / `"electronics"` / `"Electronics"`, `groupBy` would
   have split one real category into three, quietly corrupting every
   downstream aggregate.
3. **Type inconsistency**: some `age` values arrived as whitespace-padded
   strings (`" 47 "`). Casting straight to `IntegerType` failed until
   routed through `double` first — always check `printSchema()` before
   trusting a column.
4. **Clothing and Furniture** led on total sales across most regions.
   Groups with missing/`"Unknown"` values were naturally smaller and less
   reliable — a good argument for tighter validation upstream.
5. **Wide vs narrow transformations** matter for performance: every
   `groupBy().agg()` call triggers a shuffle (`Exchange` in the physical
   plan), while filters and column transforms don't move data across
   partitions at all.

---

## 📚 Resources

- [Apache Spark Documentation](https://spark.apache.org/docs/latest/)
- [PySpark API Reference](https://spark.apache.org/docs/latest/api/python/index.html)
- [Spark SQL & DataFrame Guide](https://spark.apache.org/docs/latest/sql-programming-guide.html)

---

## 📝 License

This project is for educational/internship purposes. MIT License — feel free to reuse and adapt.