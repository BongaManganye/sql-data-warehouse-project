/*
==========================================================================
Quality Checks
==========================================================================
Script Purpose:
This script performs various quality checks for data consistency, accuracy,
and standardization across the 'silver' schemas. It includes checks for:
- Null or duplicate primary keys.
- Unwanted spaces in string fields.
- Data standardization and consistency.
- Invalid date ranges and orders.
- Data consistency between related fields.

Usage Notes:
- Run these checks after data loading Silver Layer.
- Investigate and resolve any discrepancies found during the checks.
=======================================================================
*/
--=====================================================================
-- Quality Checks
-- Checks For Nulls or Dupilcates in Primary Key
-- Expectation: No Result
--=====================================================================
SELECT
prd_id,
COUNT(*)
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL
--=====================================================================
-- Check for Invalid Dates
--=====================================================================
SELECT
NULLIF(sls_order_dt,0) sls_order_dt
FROM bronze.crm_sales_details
WHERE sls_order_dt <= 0
OR LENGTH(sls_order_dt) != 8 
OR sls_order_dt > 20500101
OR sls_order_dt < 19000101
  
--=====================================================================
-- Check for Invalid Date Orders
--=====================================================================
SELECT
*
FROM silver.crm_sales_details
WHERE sls_order_dt > sls_ship_dt OR sls_order_dt > sls_due_dt

-- Check Data Consistency: Between Sales, Quantity, and Price
-- >> Sales = Quantity * Price
-- >> Values must not be NULL, zero, or negative.

SELECT distinct
	sls_sales,
    sls_quantity,
    sls_price 
FROM silver.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
OR sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL
OR sls_sales <= 0 OR sls_quantity <= 0  OR sls_price <= 0
ORDER BY sls_sales, sls_quantity, sls_price;

--=====================================================================
-- Identify Out Of Range Dates
--=====================================================================
SELECT 
CASE WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LENGTH(cid))
	ELSE cid
END AS cid,
CASE WHEN bdate > CURDATE() THEN null
	ELSE bdate
END AS bdate,
gen
FROM bronze.erp_cust_az12;

-- Data Standardization & Consistency
SELECT DISTINCT 
gen,
CASE WHEN UPPER(TRIM(gen)) IN ('F', 'FEMALE') THEN 'FEMALE'
	WHEN UPPER(TRIM(gen)) IN ('M', 'MALE') THEN 'MALE'
    ELSE 'n/a'
END AS gen
FROM bronze.erp_cust_az12

-- Identify Out Of Ranges Dates
SELECT DISTINCT
bdate
FROM silver.erp_cust_az12
WHERE bdate < '1924-01-01' OR bdate > CURDATE();

-- Data Standardization & Consistency
SELECT distinct
gen
FROM silver.erp_cust_az12;

-- Data Standardization & Consistency
SELECT DISTINCT
cntry
FROM silver.erp_loc_a101
ORDER BY cntry;
