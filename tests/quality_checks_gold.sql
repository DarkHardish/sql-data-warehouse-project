/*
===========================================================
DATA QUALITY CHECKS - GOLD LAYER
===========================================================

These queries are used to validate data integrity in the Gold layer:
- Detect duplicate surrogate keys in dimension tables
- Verify referential integrity in fact table
===========================================================
*/


-- ===========================================================
-- 1. DUPLICATE CHECK - CUSTOMERS DIMENSION
-- ===========================================================

-- Checks if customer_key (surrogate key) is unique.


SELECT 
    customer_key,
    COUNT(*) AS duplicate_count
FROM gold.dim_customers
GROUP BY customer_key
HAVING COUNT(*) > 1;




-- ===========================================================
-- 2. DUPLICATE CHECK - PRODUCTS DIMENSION
-- ===========================================================

-- Validates uniqueness of product_key in product dimension.

SELECT
    product_key,
    COUNT(*) AS duplicate_count
FROM gold.dim_products
GROUP BY product_key
HAVING COUNT(*) > 1;




-- ===========================================================
-- 3. FACT TABLE INTEGRITY CHECK
-- ===========================================================


-- Ensures that all foreign keys in fact_sales
-- correctly reference dimension tables.

SELECT * 
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
    ON c.customer_key = f.customer_key
LEFT JOIN gold.dim_products p
    ON p.product_key = f.product_key
WHERE p.product_key IS NULL
   OR c.customer_key IS NULL;
