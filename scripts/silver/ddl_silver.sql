/*
==========================================================================
DDL Script: Creating the Silver Tables
==========================================================================
Script Purpose:
	This script creates tables in the 'silver' schema to receive the cleaned
	versions of the bronze tables, dropping tables with matching names if 
	they already exist.
	Run this script to re-define the DDL structure of 'silver' tables.
Note:
	There are some changes in datatypes in this layer of the Data Warehouse,
	as well as some lightly engineered features which were not present
	in the bronze layer.
==========================================================================
*/

IF OBJECT_ID('silver.olist_orders', 'U') IS NOT NULL
	DROP TABLE silver.olist_orders;
CREATE TABLE silver.olist_orders (
	order_id VARCHAR(50),
	customer_id VARCHAR(50),
	order_status VARCHAR(20),
	order_purchase_timestamp DATETIME,
	order_approved_at DATETIME,
	order_delivered_carrier_date DATETIME,
	order_delivered_customer_date DATETIME,
	order_estimated_delivery_date DATETIME,
	invalid_date_sequence_flag BIT
);

IF OBJECT_ID ('silver.olist_customers', 'U') IS NOT NULL
	DROP TABLE silver.olist_customers;
CREATE TABLE silver.olist_customers (
    customer_id VARCHAR(50),
    customer_unique_id VARCHAR(50),
    customer_zip_code_prefix VARCHAR(20),
    customer_city VARCHAR(50),
    customer_state VARCHAR(2)
);

IF OBJECT_ID ('silver.olist_geolocation', 'U') IS NOT NULL
	DROP TABLE silver.olist_geolocation;
CREATE TABLE silver.olist_geolocation (
    geolocation_zip_code_prefix VARCHAR(5),
    geolocation_lat DECIMAL(10,7),
    geolocation_lng DECIMAL(10,7),
    geolocation_city NVARCHAR(100),
    geolocation_state NVARCHAR(2)
);

IF OBJECT_ID ('silver.olist_sellers', 'U') IS NOT NULL
	DROP TABLE silver.olist_sellers;
CREATE TABLE silver.olist_sellers (
    seller_id VARCHAR(50),
    seller_zip_code_prefix VARCHAR(5),
    seller_city VARCHAR(50),
    seller_state VARCHAR(2)
);

IF OBJECT_ID ('silver.olist_order_items', 'U') IS NOT NULL
	DROP TABLE silver.olist_order_items;
CREATE TABLE silver.olist_order_items (
	order_id VARCHAR(50),
    order_item_id VARCHAR(3),
    product_id VARCHAR(50),
    seller_id VARCHAR(50),
    shipping_limit_date DATETIME,
    price DECIMAL(10,2),
    freight_value DECIMAL(10,2),
    multiple_product_order BIT
);

IF OBJECT_ID ('silver.olist_products', 'U') IS NOT NULL
	DROP TABLE silver.olist_products;
CREATE TABLE silver.olist_products (
	product_id VARCHAR(50),
    product_category_name VARCHAR(50),
    product_name_length INT,
    product_description_length INT,
    product_photos_qty INT,
    product_weight_g INT,
    product_length_cm INT,
    product_height_cm INT,
    product_width_cm INT
);

IF OBJECT_ID ('silver.olist_order_payments', 'U') IS NOT NULL
	DROP TABLE silver.olist_order_payments;
CREATE TABLE silver.olist_order_payments (
    order_id VARCHAR(50),
    payment_sequential VARCHAR(3),
    payment_type VARCHAR(30),
    payment_installments VARCHAR(3),
    payment_value DECIMAL(10,2),
    multiple_payment_order BIT
);

IF OBJECT_ID ('silver.olist_order_reviews', 'U') IS NOT NULL
	DROP TABLE silver.olist_order_reviews;
CREATE TABLE silver.olist_order_reviews (
	review_id VARCHAR(50),
    order_id VARCHAR(50),
    review_score VARCHAR(1),
    review_comment_title VARCHAR(MAX),
    review_comment_message NVARCHAR(MAX),
    review_creation_date DATETIME,
    review_answer_timestamp DATETIME
);

IF OBJECT_ID ('silver.product_category_translation', 'U') IS NOT NULL
	DROP TABLE silver.product_category_translation;
CREATE TABLE silver.product_category_translation (
	product_category_name VARCHAR(100),
    product_category_name_english VARCHAR(100)
);
