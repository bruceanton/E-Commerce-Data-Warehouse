/*
==========================================================================
Stored Procedure: Loading the Bronze Layer (Source -> Bronze)
==========================================================================
Script Purpose:
  This stored procedure loads data into the 'bronze' schema from external CSV files.
  It performs the following actions:
  - Truncates the bronze tables before loading data.
  - Uses the `BULK INSERT` command to load data from CSV fles to bronze tables.

Parameters:
    None.
  This stored procedure does not accept any parameters or return any values.

Usage Example:
  EXEC bronze.load_bronze;
==========================================================================
*/

CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;
	BEGIN TRY
		SET @batch_start_time = GETDATE();
		PRINT '==================================';
		PRINT 'Loading Bronze Layer';
		PRINT '==================================';

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.olist_orders';
    TRUNCATE TABLE bronze.olist_orders;

    PRINT '>> Inserting Data Into: bronze.olist_orders';
    BULK INSERT bronze.olist_orders
    FROM 'C:\Users\Anton\Downloads\DATA_WAREHOUSE_PROJECT\data\olist_orders_dataset.csv'
    WITH (
        FORMAT = 'CSV',
        FIRSTROW = 2,
        FIELDQUOTE = '"',
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '0x0a',
        TABLOCK
    );
    SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST (DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '----------------';
    
    SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.olist_customers';
    TRUNCATE TABLE bronze.olist_customers;

    PRINT '>> Inserting Data Into: bronze.olist_customers';
    BULK INSERT bronze.olist_customers
    FROM 'C:\Users\Anton\Downloads\DATA_WAREHOUSE_PROJECT\data\olist_customers_dataset.csv'
    WITH (
        FORMAT = 'CSV',
        FIRSTROW = 2,
        FIELDQUOTE = '"',
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '0x0a',
        TABLOCK
    );
    SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST (DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '----------------';
    
    SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.olist_geolocation';
    TRUNCATE TABLE bronze.olist_geolocation;

    PRINT '>> Inserting Data Into: bronze.olist_geolocation';
    BULK INSERT bronze.olist_geolocation
    FROM 'C:\Users\Anton\Downloads\DATA_WAREHOUSE_PROJECT\data\olist_geolocation_dataset.csv'
    WITH (
        FORMAT = 'CSV',
        FIRSTROW = 2,
        FIELDQUOTE = '"',
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '0x0a',
        CODEPAGE = '65001',
        TABLOCK
    );
    SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST (DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '----------------';

    SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.olist_sellers';
    TRUNCATE TABLE bronze.olist_sellers;

    PRINT '>> Inserting Data Into: bronze.olist_sellers';
    BULK INSERT bronze.olist_sellers
    FROM 'C:\Users\Anton\Downloads\DATA_WAREHOUSE_PROJECT\data\olist_sellers_dataset.csv'
    WITH (
        FORMAT = 'CSV',
        FIRSTROW = 2,
        FIELDQUOTE = '"',
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '0x0a',
        TABLOCK
    );
    SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST (DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '----------------';
    
    SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.olist_order_items';
    TRUNCATE TABLE bronze.olist_order_items;

    PRINT '>> Inserting Data Into: bronze.olist_order_items';
    BULK INSERT bronze.olist_order_items
    FROM 'C:\Users\Anton\Downloads\DATA_WAREHOUSE_PROJECT\data\olist_order_items_dataset.csv'
    WITH (
        FORMAT = 'CSV',
        FIRSTROW = 2,
        FIELDQUOTE = '"',
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '0x0a',
        TABLOCK
    );
    SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST (DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '----------------';
    
    SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.olist_products';
    TRUNCATE TABLE bronze.olist_products;

    PRINT '>> Inserting Data Into: bronze.olist_products';
    BULK INSERT bronze.olist_products
    FROM 'C:\Users\Anton\Downloads\DATA_WAREHOUSE_PROJECT\data\olist_products_dataset.csv'
    WITH (
        FORMAT = 'CSV',
        FIRSTROW = 2,
        FIELDQUOTE = '"',
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '0x0a',
        TABLOCK
    );
    SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST (DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '----------------';
    
    SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.olist_payments';
    TRUNCATE TABLE bronze.olist_order_payments;

    PRINT '>> Inserting Data Into: bronze.olist_payments';
    BULK INSERT bronze.olist_order_payments
    FROM 'C:\Users\Anton\Downloads\DATA_WAREHOUSE_PROJECT\data\olist_order_payments_dataset.csv'
    WITH (
        FORMAT = 'CSV',
        FIRSTROW = 2,
        FIELDQUOTE = '"',
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '0x0a',
        TABLOCK
    );
    SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST (DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '----------------';
    
    SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.olist_order_reviews';
    TRUNCATE TABLE bronze.olist_order_reviews;

    PRINT '>> Inserting Data Into: bronze.olist_order_reviews';
    BULK INSERT bronze.olist_order_reviews
    FROM 'C:\Users\Anton\Downloads\DATA_WAREHOUSE_PROJECT\data\olist_order_reviews_dataset.csv'
    WITH (
        FORMAT = 'CSV',
        FIRSTROW = 2,
        FIELDQUOTE = '"',
        CODEPAGE = '65001',
        TABLOCK
    );
    SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST (DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '----------------';
    
    SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.product_category_translation';
    TRUNCATE TABLE bronze.product_category_translation;

    PRINT '>> Inserting Data Into: bronze.product_category_translation';
    BULK INSERT bronze.product_category_translation
    FROM 'C:\Users\Anton\Downloads\DATA_WAREHOUSE_PROJECT\data\product_category_name_translation.csv'
    WITH (
        FORMAT = 'CSV',
        FIRSTROW = 2,
        FIELDQUOTE = '"',
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '0x0a',
        TABLOCK
    );
    SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST (DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '----------------';

    SET @batch_end_time = GETDATE();
		PRINT '======================================';
		PRINT 'Loading Bronze Layer is Completed';
		PRINT 'Total Load Duration: ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
		PRINT '======================================';

	END TRY
	BEGIN CATCH
		PRINT '==============================================';
		PRINT 'ERROR OCCURRED WHILE LOADING BRONZE LAYER';
		PRINT 'Error Message' + ERROR_MESSAGE();
		PRINT 'Error Message' + CAST (ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error MEssage' + CAST (ERROR_STATE() AS NVARCHAR);
		PRINT '==============================================';
	END CATCH
END;
