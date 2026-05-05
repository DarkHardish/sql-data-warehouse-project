/*
===========================================================
Silver Layer Data Quality Checks
===========================================================

This script validates data quality rules for all Silver layer tables.

What it checks:
- Primary key uniqueness and NULL validation
- Unwanted leading or trailing spaces
- Data standardization and consistency
- Invalid or out-of-range dates
- Negative or NULL numeric values
- Business rule validation
- Data relationship consistency

Purpose:
- Ensure transformed Silver data is clean and reliable
- Validate business logic after Bronze-to-Silver transformation
- Detect data anomalies before loading Gold layer

IMPORTANT:
- Most validation queries are expected to return NO RESULTS
- Returned records usually indicate data quality issues
- This script is intended for data validation and troubleshooting
===========================================================
*/


/*=========================================================
    silver.erp_px_cat_g1v2
=========================================================*/

--Check Loaded Data

SELECT
    id,
    cat,
    subcat,
    maintenance
FROM silver.erp_px_cat_g1v2;


--Check for Unwanted Spaces
--Expectations: No Results

SELECT
    *
FROM silver.erp_px_cat_g1v2
WHERE cat != TRIM(cat)
   OR subcat != TRIM(subcat)
   OR maintenance != TRIM(maintenance);


--Check for Data Standardization & Consistency

SELECT DISTINCT
    maintenance
FROM silver.erp_px_cat_g1v2;


--Preview Final Data

SELECT
    *
FROM silver.erp_px_cat_g1v2;


=================================================================================================


/*=========================================================
    silver.erp_loc_a101
=========================================================*/

--Check Transformed Data

SELECT
    REPLACE(cid, '-', '') AS cid,

    CASE
        WHEN TRIM(cntry) = 'DE' THEN 'Germany'
        WHEN TRIM(cntry) IN ('US', 'USA') THEN 'United States'
        WHEN TRIM(cntry) = '' OR cntry IS NULL THEN 'n/a'
        ELSE TRIM(cntry)
    END AS cntry

FROM bronze.erp_loc_a101;


--Check for Data Standardization & Consistency

SELECT DISTINCT
    cntry
FROM silver.erp_loc_a101
ORDER BY cntry;


--Preview Final Data

SELECT
    *
FROM silver.erp_loc_a101;


=================================================================================================


/*=========================================================
    silver.erp_cust_az12
=========================================================*/

--Identify Out-of-Range Dates
--Expectations: No Results

SELECT DISTINCT
    bdate
FROM bronze.erp_cust_az12
WHERE bdate < '1924-01-01'
   OR bdate > GETDATE();


--Check for Data Standardization & Consistency

SELECT DISTINCT
    gen
FROM bronze.erp_cust_az12;


--Preview Final Data

SELECT
    *
FROM silver.erp_cust_az12;


=================================================================================================


/*=========================================================
    silver.crm_sales_details
=========================================================*/

--Check for Invalid Order Dates
--Expectations: No Results

SELECT
    NULLIF(sls_order_dt, 0) AS sls_order_dt
FROM silver.crm_sales_details
WHERE sls_order_dt <= 0
   OR LEN(sls_order_dt) != 8
   OR sls_order_dt > 20500101
   OR sls_order_dt < 19000101;


--Check for Invalid Date Orders
--Expectations: No Results

SELECT
    *
FROM silver.crm_sales_details
WHERE sls_order_dt > sls_ship_dt
   OR sls_order_dt > sls_due_dt;


--Check Sales, Quantity, and Price Consistency
--Sales = Quantity * Price
--Values cannot be NULL, zero, or negative

SELECT
    sls_sales,
    sls_quantity,
    sls_price
FROM silver.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
   OR sls_sales IS NULL
   OR sls_quantity IS NULL
   OR sls_price IS NULL
   OR sls_sales <= 0
   OR sls_quantity <= 0
   OR sls_price <= 0
ORDER BY
    sls_sales,
    sls_quantity,
    sls_price;


--Preview Final Data

SELECT
    *
FROM silver.crm_sales_details;


=================================================================================================


/*=========================================================
    silver.crm_prd_info
=========================================================*/

--Check for Nulls or Duplicates in Primary Key
--Expectations: No Results

SELECT
    prd_id,
    COUNT(*)
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1
    OR prd_id IS NULL;


--Check for Unwanted Spaces
--Expectations: No Results

SELECT
    prd_nm
FROM silver.crm_prd_info
WHERE prd_nm != TRIM(prd_nm);


--Check for Nulls or Negative Values
--Expectations: No Results

SELECT
    prd_cost
FROM silver.crm_prd_info
WHERE prd_cost < 0
   OR prd_cost IS NULL;


--Check for Data Standardization & Consistency

SELECT DISTINCT
    prd_line
FROM silver.crm_prd_info;


--Preview Final Data

SELECT
    *
FROM silver.crm_prd_info;


=================================================================================================


/*=========================================================
    silver.crm_cust_info
=========================================================*/

--Check for Nulls or Duplicates in Primary Key
--Expectations: No Results

SELECT
    cst_id,
    COUNT(*)
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1
    OR cst_id IS NULL;


--Check for Unwanted Spaces
--Expectations: No Results

SELECT
    cst_lastname
FROM silver.crm_cust_info
WHERE cst_lastname != TRIM(cst_lastname);


--Check for Data Standardization & Consistency

SELECT DISTINCT
    cst_gndr
FROM silver.crm_cust_info;


--Check for Marital Status Standardization

SELECT DISTINCT
    cst_material_status
FROM silver.crm_cust_info;


--Preview Final Data

SELECT
    *
FROM silver.crm_cust_info;
