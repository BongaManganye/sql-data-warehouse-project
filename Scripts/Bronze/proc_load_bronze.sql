/*

=================================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
=================================================================================
Script Purpose:
This stored procedure loads data into the 'bronze' schema from external CSV files.
It performs the following actions:
- Truncates the bronze tables before loading data.
- Uses the `LOAD DATA INFILE' command to load data from csv Files to bronze tables.

Parameters:

None.

This stored procedure does not accept any parameters or return any values.

Usage Example:
CALL bronze.load_bronze;
=================================================================================
*/

CREATE PROCEDURE bronze.load_bronze()
BEGIN
    SELECT 'Bronze layer procedure executed successfully!' AS status;
END//

DELIMITER ;

BEGIN
	SET @start_time = NOW();
SET @end_time = CURDATE();

SELECT @start_time AS start_time, @end_time AS end_time;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SELECT 'Error occurred during table creation' AS error_message;
		END;

		SELECT 'Starting bronze layer table creation...' AS status;
    
SET @start_time = NOW();
	DROP TABLE IF EXISTS bronze_crm_cust_info;
	CREATE TABLE bronze.crm_cust_info(
		cst_id INT,
		cst_key VARCHAR(50),
		cst_firstname VARCHAR(50),
		cst_lastname VARCHAR(50),
		cst_marital_status VARCHAR(50),
		cst_gndr VARCHAR(50),
		cst_create_date Date
);
SET @end_time = NOW();
SELECT CONCAT('>> Load Duration: ', TIMESTAMPDIFF(SECOND, @start_time, @end_time), ' seconds') AS load_duration;

SET @start_time = NOW();
	DROP TABLE IF EXISTS bronze_crm_prd_info;
	CREATE TABLE bronze.crm_prd_info(
		prd_id INT,
		prd_key VARCHAR(50),
		prd_nm VARCHAR(50),
		prd_cost INT,
		prd_line VARCHAR(50),
		prd_start_dt DATE,
		prd_end_dt DATE
);
SET @end_time = NOW();
SELECT CONCAT('>> Load Duration: ', TIMESTAMPDIFF(SECOND, @start_time, @end_time), ' seconds') AS load_duration;

SET @start_time = NOW();
	DROP TABLE IF EXISTS bronze_crm_sales_details;
	CREATE TABLE bronze.crm_sales_details(
		sls_ord_num VARCHAR(50),
		sls_prd_key VARCHAR(50),
		sls_cust_id INT,
		sls_order_dt INT,
		sls_ship_dt INT,
		sls_dues_dt INT,	
		sls_sales INT,
		sls_quantity INT,
		sls_price INT
);
SET @end_time = NOW();
SELECT CONCAT('>> Load Duration: ', TIMESTAMPDIFF(SECOND, @start_time, @end_time), ' seconds') AS load_duration;

SET @start_time = NOW();
	DROP TABLE IF EXISTS bronze_erp_loc_a101;
	CREATE TABLE bronze.erp_loc_a101(
		cid VARCHAR(50),
		cntry VARCHAR(50)
);
SET @end_time = NOW();
SELECT CONCAT('>> Load Duration: ', TIMESTAMPDIFF(SECOND, @start_time, @end_time), ' seconds') AS load_duration;

SET @start_time = NOW();
		DROP TABLE IF EXISTS bronze_crm_cust_az12;
		CREATE TABLE bronze.erp_cust_az12(
			cid VARCHAR(50),
			bdate DATE,
			gen VARCHAR(50)
);
SET @end_time = NOW();
SELECT CONCAT('>> Load Duration: ', TIMESTAMPDIFF(SECOND, @start_time, @end_time), ' seconds') AS load_duration;

SET @start_time = NOW();
		DROP TABLE IF EXISTS bronze_erp_px_cat_g1v2;
		CREATE TABLE bronze.erp_px_cat_g1v2(
			id VARCHAR(50),
			cat VARCHAR(50),
			subcat VARCHAR(50),
			maintenance VARCHAR(50)
);
SET @end_time = NOW();
SELECT CONCAT('>> Load Duration: ', TIMESTAMPDIFF(SECOND, @start_time, @end_time), ' seconds') AS load_duration;

	SELECT '=======================================================================' AS separator;
    SELECT 'BRONZE LAYER TABLES CREATED SUCCESSFULLY' AS success_message;
	SELECT '=======================================================================' AS separator;

END//
DELIMITER ;
