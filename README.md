# 🎬 End-to-End Entertainment Business Analytics Project

## 📌 Project Overview

This portfolio project analyzes customer rental behavior, movie performance, revenue trends, and actor popularity using SQL Server and relational data modeling.

The objective was to transform multiple raw datasets into actionable business insights through advanced SQL analysis and dashboard-ready outputs.

The project evolved from simple transaction analysis into a full entertainment business intelligence case study.

---

## 🛠 Tools & Technologies

* SQL Server
* T-SQL
* CSV / Excel
* GitHub
* Power BI (next phase)

---

## 🗂 Database Structure

This project uses a multi-table relational schema:

* **customers** → customer information
* **renting** → rental transactions
* **movies** → movie catalog and pricing
* **actors** → actor demographics
* **actsin** → bridge table linking actors and movies

### Relationship Model

customers ← renting → movies ← actsin → actors

---

## 📊 Business Analysis Performed

### Customer Intelligence

* Customer segmentation (VIP / Active / Low Activity)
* Repeat customer analysis
* Top spending customers
* Customer lifetime value
* Country-level customer distribution

### Revenue Analytics

* Total rental revenue
* Revenue by movie
* Revenue by country
* Monthly revenue trend
* Running cumulative revenue

### Movie Performance

* Most rented movies
* Highest rated movies
* Genre performance analysis
* Revenue by genre

### Actor Analytics

* Most popular actors
* Actor rental appearances
* Actor nationality demographics
* Gender and birth-year analysis

### Advanced SQL Analytics

* Multi-table JOINs
* GROUP BY / HAVING
* CASE WHEN logic
* Common Table Expressions (CTEs)
* Window Functions
* RANK / DENSE_RANK
* LAG
* Running Totals

---

## 📈 Sample Insights

* A small share of customers generated repeat rentals.
* Revenue was concentrated in a limited number of movie titles.
* Several genres outperformed others in both ratings and revenue.
* Actor participation strongly influenced rental volume.
* Monthly rental activity fluctuated across the observed period.

---

## 🚀 Power BI Dashboard (Coming Next)

Planned dashboard pages:

1. Executive Overview
2. Movie Performance
3. Customer Intelligence
4. Actor Analytics

---

## 📁 Repository Structure

```text
movie-rental-sql-project/
│── dataset/
│   ├── customers.csv
│   ├── renting.csv
│   ├── movies.csv
│   ├── actors.csv
│   └── actsin.csv
│── sql/
│   ├── chapter_1_basic_analysis.sql
│   ├── chapter_2_customer_analysis.sql
│   ├── chapter_3_kpis.sql
│   ├── chapter_4_advanced_sql.sql
│   ├── chapter_5_multitable_analytics.sql
│   └── chapter_6_window_functions.sql
│── dashboard/
│── README.md
```

---

## 👤 Author

Created by **Fengzhe Li** as a portfolio project for Data Analyst opportunities.
