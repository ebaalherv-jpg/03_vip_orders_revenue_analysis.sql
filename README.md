# 03_vip_orders_revenue_analysis.sql
Advanced SQL Analysis: E-commerce VIP order reporting utilizing CTEs, Window Functions (DENSE_RANK, Running Totals), and Conditional Aggregations.
# 📊 Advanced SQL Analytics: VIP Orders & Cumulative Revenue Contribution

## 🎯 Business Context
The executive team requested an analytical report to identify top-tier customer orders, understand product tier composition (High-tier > $100 vs. Low-tier <= $100), and evaluate their running cumulative contribution to overall business revenue.

## 🛠️ Tech Stack & SQL Concepts
- **Dialect:** Standard ANSI SQL (compatible with PostgreSQL, Snowflake, BigQuery, MySQL 8.0+)
- **Key Concepts Applied:**
  - **Common Table Expressions (CTEs):** Modularizing business logic into clean, readable steps.
  - **Conditional Aggregations:** `COUNT(CASE WHEN...)` to classify product tiers without modifying raw data.
  - **Window Functions:** `DENSE_RANK()` for accurate order ranking and `SUM() OVER(...)` with explicit frame boundaries (`ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW`) for running totals.

## 📁 Repository Structure
```text
├── 01_subqueries_and_joins.sql
├── 02_window_functions_basics.sql
└── 03_vip_orders_revenue_analysis.sql   <-- Main Integrative Project
