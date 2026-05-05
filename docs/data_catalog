# Data Catalog for Gold Layer

## Overview
Gold Layer contains business-ready data used for reporting and analysis. It is split into:
- **Dimension tables** (descriptive data)
- **Fact tables** (transactions and metrics)

---

## 1. gold.dim_customers

-Basic information about customers.

### Columns:

| Column Name      | Data Type    | Description |
|------------------|-------------|-------------|
| customer_key     | INT         | Unique ID for each customer record. |
| customer_id      | INT         | Original customer identifier. |
| customer_number  | NVARCHAR(50)| Customer code used in system. |
| first_name       | NVARCHAR(50)| Customer first name. |
| last_name        | NVARCHAR(50)| Customer last name. |
| country          | NVARCHAR(50)| Customer country. |
| marital_status   | NVARCHAR(50)| Marital status (e.g. Single, Married). |
| gender           | NVARCHAR(50)| Customer gender. |
| birthdate        | DATE        | Date of birth. |
| create_date      | DATE        | Date when customer was added. |

---

## 2. gold.dim_products

-Basic product information.

### Columns:

| Column Name          | Data Type    | Description |
|---------------------|-------------|-------------|
| product_key         | INT         | Unique product record ID. |
| product_id          | INT         | Original product ID. |
| product_number      | NVARCHAR(50)| Product code. |
| product_name        | NVARCHAR(50)| Product name. |
| category_id         | NVARCHAR(50)| Category ID. |
| category            | NVARCHAR(50)| Product category. |
| subcategory         | NVARCHAR(50)| Product subcategory. |
| maintenance_required| NVARCHAR(50)| If product needs maintenance (Yes/No). |
| cost                | INT         | Product cost. |
| product_line        | NVARCHAR(50)| Product group/line. |
| start_date          | DATE        | Date product became available. |

---

## 3. gold.fact_sales

-Sales transactions data.

### Columns:

| Column Name   | Data Type    | Description |
|--------------|-------------|-------------|
| order_number | NVARCHAR(50)| Order ID. |
| product_key  | INT         | Links to product. |
| customer_key | INT         | Links to customer. |
| order_date   | DATE        | Date order was placed. |
| shipping_date| DATE        | Date order was shipped. |
| due_date     | DATE        | Payment due date. |
| sales_amount | INT         | Total sale value. |
| quantity     | INT         | Number of items sold. |
| price        | INT         | Price per item. |
