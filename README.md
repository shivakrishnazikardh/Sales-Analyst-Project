# 📊 Sales & Product Analysis SQL Project

## 📁 Project Overview

This SQL project focuses on analyzing a retail/fmcg-style database involving customers, products, pricing, manufacturing, and sales. It uses **advanced SQL techniques** like CTEs, aggregations, joins, subqueries, and window functions to derive business insights from transactional and dimensional data.

### NOTE: I have also included Power BI visualization file named "atliq power bi.pdf", in which i have turned the insights and visually interepreted it using Power BI tool.

---

## 🧰 Tools & Technologies Used

- **SQL** (MySQL/PostgreSQL style)
- **Joins** (INNER JOIN, subqueries)
- **Aggregations & Grouping**
- **Common Table Expressions (CTEs)**
- **Window Functions (e.g., DENSE_RANK)**
- **String functions & Date functions**

---

## 📂 Dataset Tables

- `dim_customer`: Customer details including region, channel, and market.
- `dim_product`: Product metadata like segment and division.
- `fact_sales_monthly`: Monthly sales data (sold quantity, date).
- `fact_gross_price`: Product pricing data per fiscal year.
- `fact_manufacturing_cost`: Manufacturing cost per product.
- `fact_pre_invoice_deductions`: Discount information before invoicing.

---

## 🔍 Query Descriptions

### 1️⃣ Query: Market Identification
**Goal:** Identify which market "Atliq Exclusive" operates in within the world map.  
**SQL:** `SELECT DISTINCT market ...`

---

### 2️⃣ Query: Product Count Growth
**Goal:** Compare the number of unique products sold in 2020 and 2021, and calculate the percentage change.  
**SQL:** CTEs for both years and a final calculation using arithmetic expressions.

---

### 3️⃣ Query: Product Count by Segment
**Goal:** Count the number of unique products per segment and rank them.  
**SQL:** `GROUP BY segment ORDER BY product_count DESC`

---

### 4️⃣ Query: Year-over-Year Product Difference by Segment
**Goal:** Calculate the difference in unique products per segment from 2020 to 2021.  
**SQL:** Uses CTEs for both years and computes the difference.

---

### 5️⃣ Query: Manufacturing Cost Extremes
**Goal:** Find the products with the **highest and lowest** manufacturing costs.  
**SQL:** Subqueries to get `MAX()` and `MIN()`.

---

### 6️⃣ Query: Top Discounts in India (2021)
**Goal:** Identify top 5 customers in India who received the highest average pre-invoice discount in 2021.  
**SQL:** `AVG()`, `ROUND()`, `ORDER BY DESC LIMIT 5`

---

### 7️⃣ Query: Gross Sales Over Time for Atliq Exclusive
**Goal:** Calculate the monthly gross sales amount for "Atliq Exclusive".  
**SQL:** Uses date formatting and multiple joins.

---

### 8️⃣ Query: Quarterly Sold Quantity (2020)
**Goal:** Show total quantity sold per quarter in 2020, ranked by quantity.  
**SQL:** Uses `QUARTER()` and `GROUP BY`.

---

### 9️⃣ Query: Sales Contribution by Channel (2021)
**Goal:** Calculate gross sales by channel and their percentage contribution to total sales.  
**SQL:** CTEs for partial and total sales, with percentage calculation.

---

### 🔟 Query: Top Products by Division (2021)
**Goal:** Identify top 3 best-selling products in each division in 2021 using ranking.  
**SQL:** Uses `DENSE_RANK()` window function within CTE.

---

## ✅ Summary

This project demonstrates practical business intelligence tasks using SQL:
- Performance comparison over time
- Market/customer segmentation
- Profitability insights
- Product and sales prioritization
- Trend and growth tracking

---

## 🚀 Usage

You can run these queries in any SQL environment (MySQL, PostgreSQL, etc.) connected to the relevant database schema. Ensure all necessary tables are loaded and indexed for optimal performance.

Developed by Riakantha Shiva Krishna
