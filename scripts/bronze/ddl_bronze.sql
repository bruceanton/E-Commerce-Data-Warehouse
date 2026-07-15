/*
==============================================================
DDL Script: Create Bronze Tables
==============================================================
Script Purpose:
	This script creates tables in the 'bronze' schema, dropping existing tables 
	if they already exist.
	Run this script to re-define the DDL structure of 'bronze' Tables.
==============================================================
*/

IF OBJECT_ID ('bronze.olist_orders', 'U') IS NOT NULL
    DROP TABLE bronze.olist_orders;
CREATE TABLE bronze.olist_orders (
    order_id VARCHAR(50),
    customer_id VARCHAR(50),
    order_status VARCHAR(20),
    order_purchase_timestamp VARCHAR(50),
    order_approved_at VARCHAR(50),
    order_delivered_carrier_date VARCHAR(50),
    order_delivered_customer_date VARCHAR(50),
    order_estimated_delivery_date VARCHAR(50)
);

IF OBJECT_ID ('bronze.olist_customers', 'U') IS NOT NULL
    DROP TABLE bronze.olist_customers;
CREATE TABLE bronze.olist_customers (
    customer_id VARCHAR(50),
    customer_unique_id VARCHAR(50),
    customer_zip_code_prefix VARCHAR(20),
    customer_city VARCHAR(50),
    customer_state VARCHAR(20)
);

IF OBJECT_ID ('bronze.olist_geolocation', 'U') IS NOT NULL
    DROP TABLE bronze.olist_geolocation;
CREATE TABLE bronze.olist_geolocation (
    geolocation_zip_code_prefix VARCHAR(20),
    geolocation_lat VARCHAR(50),
    geolocation_lng VARCHAR(50),
    geolocation_city NVARCHAR(100),
    geolocation_state NVARCHAR(20)
);

IF OBJECT_ID ('bronze.olist_sellers', 'U') IS NOT NULL
    DROP TABLE bronze.olist_sellers;
CREATE TABLE bronze.olist_sellers (
    seller_id VARCHAR(50),
    seller_zip_code_prefix VARCHAR(20),
    seller_city VARCHAR(50),
    seller_state VARCHAR(20)
);

IF OBJECT_ID ('bronze.olist_order_items', 'U') IS NOT NULL
    DROP TABLE bronze.olist_order_items;
CREATE TABLE bronze.olist_order_items (
    order_id VARCHAR(50),
    order_item_id VARCHAR(20),
    product_id VARCHAR(50),
    seller_id VARCHAR(50),
    shipping_limit_date VARCHAR(50),
    price VARCHAR(20),
    freight_value VARCHAR(20)
);

IF OBJECT_ID ('bronze.olist_products', 'U') IS NOT NULL
    DROP TABLE bronze.olist_products;
CREATE TABLE bronze.olist_products (
    product_id VARCHAR(50),
    product_category_name VARCHAR(50),
    product_name_length VARCHAR(20),
    product_description_length VARCHAR(20),
    product_photos_qty VARCHAR(20),
    product_weight_g VARCHAR(20),
    product_length_cm VARCHAR(20),
    product_height_cm VARCHAR(20),
    product_width_cm VARCHAR(20)
);

IF OBJECT_ID ('bronze.olist_order_payments', 'U') IS NOT NULL
    DROP TABLE bronze.olist_order_payments;
CREATE TABLE bronze.olist_order_payments (
    order_id VARCHAR(50),
    payment_sequential VARCHAR(20),
    payment_type VARCHAR(30),
    payment_installments VARCHAR(20),
    payment_value VARCHAR(20)
);

IF OBJECT_ID ('bronze.olist_order_reviews', 'U') IS NOT NULL
    DROP TABLE bronze.olist_order_reviews;
CREATE TABLE bronze.olist_order_reviews (
    review_id VARCHAR(50),
    order_id VARCHAR(50),
    review_score VARCHAR(20),
    review_comment_title VARCHAR(255),
    review_comment_message NVARCHAR(MAX),
    review_creation_date VARCHAR(20),
    review_answer_timestamp VARCHAR(20)
);

IF OBJECT_ID ('bronze.product_category_translation', 'U') IS NOT NULL
    DROP TABLE bronze.product_category_translation;
CREATE TABLE bronze.product_category_translation (
    product_category_name VARCHAR(100),
    product_category_name_english VARCHAR(100)
);
