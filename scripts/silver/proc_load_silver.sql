/*
==========================================================================
Stored Procedure: Loading the Silver Layer (Bronze -> Silver)
==========================================================================
Script Purpose:
  This stored procedure loads data into the 'silver' schema from the 
  'bronze' schema.
  It performs the following actions:
  - Truncates the silver tables before loading data.
  - Uses the `INSERT INTO` command to load data from bronze tables to
  silver tables.
  - Changes the datatypes of and/or trims certain columns during this 
  process as a part of data cleaning, and adds some feature engineered
  columns.

Parameters:
  None.
  This stored procedure does not accept any parameters or return any 
  values.

Usage Example:
  EXEC silver.load_silver;
==========================================================================
*/

CREATE OR ALTER PROCEDURE silver.load_silver AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;
	BEGIN TRY
		SET @batch_start_time = GETDATE();
		PRINT '================================================';
		PRINT 'Loading Silver Layer';
		PRINT '================================================';

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: silver.olist_orders';
		TRUNCATE TABLE silver.olist_orders;
		PRINT '>> Inserting Data Into: silver.olist_orders';
		INSERT INTO silver.olist_orders (
			order_id,
			customer_id,
			order_status,
			order_purchase_timestamp,
			order_approved_at,
			order_delivered_carrier_date,
			order_delivered_customer_date,
			order_estimated_delivery_date,
			invalid_date_sequence_flag
		)
		SELECT
			order_id,
			customer_id,
			LOWER(TRIM(order_status)),
			CAST(order_purchase_timestamp AS DATETIME),
			CAST(order_approved_at AS DATETIME),
			CAST(order_delivered_carrier_date AS DATETIME),
			CAST(order_delivered_customer_date AS DATETIME),
			CAST(order_estimated_delivery_date AS DATETIME),
			CASE
				WHEN order_delivered_customer_date < order_delivered_carrier_date THEN 1
				WHEN order_delivered_carrier_date < order_approved_at THEN 1
				WHEN order_approved_at < order_purchase_timestamp THEN 1
				ELSE 0
			END AS invalid_date_sequence_flag
		FROM bronze.olist_orders;
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '----------------';

		SET @start_time = GETDATE()
		PRINT '>> Truncating Table: silver.olist_customers';
		TRUNCATE TABLE silver.olist_customers;
		PRINT '>> Inserting Data Into: silver.olist_customers';
		INSERT INTO silver.olist_customers (
			customer_id,
			customer_unique_id,
			customer_zip_code_prefix,
			customer_city,
			customer_state
		)
		SELECT
			customer_id,
			customer_unique_id,
			customer_zip_code_prefix,
			customer_city,
			customer_state
		FROM bronze.olist_customers;
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '----------------';

		SET @start_time = GETDATE()
		PRINT '>> Truncating Table: silver.olist_geolocation';
		TRUNCATE TABLE silver.olist_geolocation;
		PRINT '>> Inserting Data Into: silver.olist_geolocation';
		INSERT INTO silver.olist_geolocation (
			geolocation_zip_code_prefix,
			geolocation_lat,
			geolocation_lng,
			geolocation_city,
			geolocation_state
		)
		SELECT 
			geolocation_zip_code_prefix,
			CAST(geolocation_lat AS DECIMAL(10,7)),
			CAST(geolocation_lng AS DECIMAL(10,7)),
			TRIM(geolocation_city),
			TRIM(geolocation_state)
		FROM bronze.olist_geolocation;
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '----------------';

		SET @start_time = GETDATE()
		PRINT '>> Truncating Table: silver.olist_sellers';
		TRUNCATE TABLE silver.olist_sellers;
		PRINT '>> Inserting Data Into: silver.olist_sellers';
		INSERT INTO silver.olist_sellers (
			seller_id,
			seller_zip_code_prefix,
			seller_city,
			seller_state
		)
		SELECT
			seller_id,
			seller_zip_code_prefix,
			seller_city,
			seller_state
		FROM bronze.olist_sellers;
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '----------------';

		SET @start_time = GETDATE()
		PRINT '>> Truncating Table: silver.olist_order_items';
		TRUNCATE TABLE silver.olist_order_items;
		PRINT '>> Inserting Data Into: silver.olist_order_items';
		INSERT INTO silver.olist_order_items (
			order_id,
			order_item_id,
			product_id,
			seller_id,
			shipping_limit_date,
			price,
			freight_value,
			multiple_product_order
		)
		SELECT
			order_id,
			order_item_id,
			product_id,
			seller_id,
			CAST(shipping_limit_date AS DATETIME),
			CAST(price AS DECIMAL(10,2)),
			CAST(freight_value AS DECIMAL(10,2)),
			CASE
				WHEN COUNT(*) OVER(PARTITION BY order_id) > 1 THEN 1
				ELSE 0
			END AS multiple_product_order
		FROM bronze.olist_order_items;
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '----------------';

		SET @start_time = GETDATE()
		PRINT '>> Truncating Table: silver.olist_products';
		TRUNCATE TABLE silver.olist_products;
		PRINT '>> Inserting Data Into: silver.olist_products';
		INSERT INTO silver.olist_products (
			product_id,
			product_category_name,
			product_name_length,
			product_description_length,
			product_photos_qty,
			product_weight_g,
			product_length_cm,
			product_height_cm,
			product_width_cm
		)
		SELECT 
			product_id,
			CASE
				WHEN product_category_name IS NULL THEN 'Unknown'
				ELSE product_category_name
			END AS product_category_name,
			CAST(product_name_length AS INT),
			CAST(product_description_length AS INT),
			CAST(product_photos_qty AS INT),
			CAST(product_weight_g AS INT),
			CAST(product_length_cm AS INT),
			CAST(product_height_cm AS INT),
			CAST(product_width_cm AS INT)
		FROM bronze.olist_products;
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '----------------';

		SET @start_time = GETDATE()
		PRINT '>> Truncating Table: silver.olist_order_payments';
		TRUNCATE TABLE silver.olist_order_payments;
		PRINT '>> Inserting Data Into: silver.olist_order_payments';
		INSERT INTO silver.olist_order_payments (
			order_id,
			payment_sequential,
			payment_type,
			payment_installments,
			payment_value,
			multiple_payment_order
		)
		SELECT
			order_id,
			payment_sequential,
			payment_type,
			payment_installments,
			CAST(payment_value AS DECIMAL(10,2)),
			CASE
				WHEN COUNT(*) OVER(PARTITION BY order_id) > 1 THEN 1
				ELSE 0
			END AS multiple_payment_order
		FROM bronze.olist_order_payments;
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '----------------';

		SET @start_time = GETDATE()
		PRINT '>> Truncating Table: silver.olist_order_reviews';
		TRUNCATE TABLE silver.olist_order_reviews;
		PRINT '>> Inserting Data Into: silver.olist_order_reviews';
		INSERT INTO silver.olist_order_reviews (
			review_id,
			order_id,
			review_score,
			review_comment_title,
			review_comment_message,
			review_creation_date,
			review_answer_timestamp
		)
		SELECT
			review_id,
			order_id,
			review_score,
			TRIM(review_comment_title),
			TRIM(review_comment_message),
			CAST(review_creation_date AS DATETIME),
			CAST(review_answer_timestamp AS DATETIME)
		FROM bronze.olist_order_reviews;
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '----------------';

		SET @start_time = GETDATE()
		PRINT '>> Truncating Table: silver.product_category_translation';
		TRUNCATE TABLE silver.product_category_translation;
		PRINT '>> Inserting Data Into: silver.product_category_translation';
		INSERT INTO silver.product_category_translation (
			product_category_name,
			product_category_name_english
		)
		SELECT
			product_category_name,
			product_category_name_english
		FROM bronze.product_category_translation;
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '----------------';

		SET @batch_end_time = GETDATE();
		PRINT '================================================';
		PRINT 'Loading Silver Layer is Completed';
		Print 'Total Load Duration: ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
		PRINT '================================================';

	END TRY
	BEGIN CATCH
		PRINT '================================================';
		PRINT 'ERROR OCCURED WHILE LOADING SILVER LAYER';
		PRINT 'Error Message' + ERROR_MESSAGE();
		PRINT 'Error Message' + CAST (ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error Message' + CAST (ERROR_STATE() AS NVARCHAR);
		PRINT '================================================';
	END CATCH
END;
