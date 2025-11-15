/*
===========================================================================
Quality Checks
===========================================================================
Script Purpose:
  This script performs quality checks to validate the integrity, consistency,
  and accuracy of the SIl Layer. These checks ensure:
  - Uniqueness of surrogate keys in dimension tables.
  - Referential integrity between fact and dimension tables.
  - Validation of relationships in the data model for analytical purposes.

Usage Notes:
  - Run these checks after data loading Silver Layer.
  - Investigate and resolve any discrepancies found during the checks.
===========================================================================
*/
--=========================================================================
-- Check for Uniqueness of Customer Key in gold.dim_customers
-- Expectation: No results

-- Check for Invalid Date Orders
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

-- Identify Out Of Range Dates
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

