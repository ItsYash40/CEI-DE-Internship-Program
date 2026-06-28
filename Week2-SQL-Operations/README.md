# 📊 SQL-Based Sales Data Analysis using MySQL


### 🚀 Celebel Technologies Data Engineering Internship

### **Week 2 Assignment – SQL-Based Business Analytics**

**Developed by:** **Debajyoti Bhakta**

**Institute:** ITER, Siksha 'O' Anusandhan (SOA University)

---

![MySQL](https://img.shields.io/badge/MySQL-8.0-blue?logo=mysql)
![SQL](https://img.shields.io/badge/SQL-Data%20Analysis-green)
![Database](https://img.shields.io/badge/Database-Relational-orange)
![Status](https://img.shields.io/badge/Completed-success)
![License](https://img.shields.io/badge/Internship-Celebel-red)


---

# Project Overview

This project demonstrates a complete **SQL-based Sales Data Analysis Pipeline** using the **Superstore Sales Dataset**.

The objective is to transform raw transactional sales data into meaningful business insights using SQL. The project covers database design, querying, filtering, aggregation, joins, subqueries, transactions, and analytical reporting.

This repository is structured as a real-world SQL analytics project where each section focuses on a different aspect of SQL programming and business intelligence.

---

# 🎯 Objectives

The project covers:

* Designing a relational database
* Creating normalized tables
* Importing structured sales data
* Performing exploratory SQL queries
* Filtering records using multiple conditions
* Aggregating sales metrics
* Joining multiple tables
* Writing advanced business queries
* Detecting duplicate records
* Using transactions (COMMIT / ROLLBACK)
* Exporting query results into CSV reports

---

#  Project Architecture

```
                    Superstore Dataset
                           │
                           ▼
                setup_database.sql
                           │
                           ▼
                MySQL Relational Database
                           │
        ┌──────────┬────────────┬────────────┐
        ▼          ▼            ▼            ▼
   Customers    Products      Orders    Order Items
        │          │             │            │
        └──────────┴──────┬──────┴────────────┘
                           ▼
                  SQL Business Analytics
                           │
     ┌──────────┬──────────┬──────────┬──────────┐
     ▼          ▼          ▼          ▼          ▼
 Section A  Section B  Section C  Section D  Section E
 Basic      Filter     Aggregate   Joins      Advanced
 Queries    Queries    Queries     Queries    SQL
                           │
                           ▼
                    CSV Report Outputs
                           │
                           ▼
                  Business Intelligence
```

---

# 🗂️ Repository Structure

```
Week2-SQL-Analysis
│
├── setup_database.sql
│
├── README.md
│
├── Section_A
│   ├── basic_queries.sql
│   └── Section_A_Output.csv
│
├── Section_B
│   ├── filtering_queries.sql
│   └── Section_B_Output.csv
│
├── Section_C
│   ├── aggregation_queries.sql
│   └── Section_C_Output.csv
│
├── Section_D
│   ├── joins_queries.sql
│   └── Section_D_Output.csv
│
├── Section_E
│   ├── advanced_queries.sql
│   └── Section_E_Output.csv
│
└── Dataset
    └── Superstore.csv
```

---

# 🗄️ Database Schema

```
CUSTOMERS
──────────────
customer_id (PK)
customer_name
segment
country
city
state
postal_code
region


PRODUCTS
──────────────
product_id (PK)
product_name
category
sub_category


ORDERS
──────────────
order_id (PK)
customer_id (FK)
order_date
ship_date
ship_mode


ORDER_ITEMS
──────────────
item_id (PK)
order_id (FK)
product_id (FK)
sales
quantity
discount
profit
```

---

# 🔗 Entity Relationship

```
Customers
     │
     │
     │1
     │
     ▼
Orders
     │
     │1
     │
     ▼
Order Items
     ▲
     │
     │Many
Products
```

---

# ⚙️ Technologies Used

| Technology                | Purpose         |
| ------------------------- | --------------- |
| MySQL 8+                  | Database        |
| SQL                       | Data Analysis   |
| MySQL Workbench           | Query Execution |
| CSV                       | Report Export   |
| Git & GitHub              | Version Control |

---

# 🚀 Getting Started

## Clone Repository

```bash
git clone https://github.com/ItsYash40/CEI-DE-Internship-Program.git

cd Week2-SQL-Analysis
```

# 📈 Business Insights

| Analysis                      | Observation                         |
| ----------------------------- | ----------------------------------- |
| Highest Revenue Category      | Technology                          |
| Best Selling Products         | Phones & Machines                   |
| Highest Loss Category         | Furniture                           |
| Worst Performing Sub-category | Tables                              |
| Best Region                   | West                                |
| Highest Order Segment         | Consumer                            |
| Highest Average Order Value   | Corporate                           |
| High Discount Impact          | Discounts >20% reduce profitability |
| Duplicate Records             | None Found                          |

---

# 📊 Execution Reports

Each SQL section generates a CSV report for verification and documentation.

| Section | SQL File                | Output Report        |
| ------- | ----------------------- | -------------------- |
| A       | basic_queries.sql       | Execution A Tables  |
| B       | filtering_queries.sql   | Execution B Tables |
| C       | aggregation_queries.sql | Execution C Tables |
| D       | joins_queries.sql       | Execution D Tables |
| E       | advanced_queries.sql    | Execution E Tables |

These reports make the project reproducible and allow reviewers to validate every SQL query independently.

---

# 📌 Learning Outcomes

Through this project, I gained practical experience in:

* Relational Database Design
* SQL Query Optimization
* Data Cleaning
* Business Intelligence
* Analytical Reporting
* Database Normalization
* Foreign Key Relationships
* Aggregation & KPI Analysis
* Multi-table Data Integration
* SQL Transactions
* Query Debugging
* Exporting Analytical Reports

---

# ⭐ Future Improvements

* Stored Procedures
* SQL Views
* Window Functions
* Common Table Expressions (CTEs)
* Triggers
* User Roles & Permissions
* Performance Optimization
* Dashboard Integration using Power BI / Tableau

---

# 🙌 Acknowledgements

**Celebel Technologies**
Data Engineering Internship Program

Dataset Source: https://www.kaggle.com/datasets/vivek468/superstore-dataset-finalhttps://celebaltech.sharepoint.com/:w:/s/Celebal-LMS/IQDQ_Co-E08_RZo3eKklxGR-AQ09RkM5df72wSBZjaL9LYc?e=04TLA8

**Kaggle – Superstore Sales Dataset**

---

# 👨‍💻 Author

## Debajyoti Bhakta

**B.Tech – Computer Science & Engineering**

Institute of Technical Education and Research (ITER)

Siksha 'O' Anusandhan (SOA University)

**Thank You for Visiting! 🚀**

