/*
==============================================================================================
DDL Script: Creating the Gold Views
==============================================================================================
Script Purpose:
    This script creates views for the Gold layer of the Data Warehouse.
    The Gold layer contains the final dimension and fact tables formed by tables from the
    Silver layer.

    Each view performs transformations and combines data from the Silver layer through the
	use of CTEs, JOINS, and Window Functions.

Usage:
    - These views can be queried directly for analytics and reporting.
==============================================================================================
*/

-- ===========================================================================================
-- Create Dimension: gold.dim_customers
-- ===========================================================================================

IF OBJECT_ID('gold.dim_customers', 'V') IS NOT NULL
    DROP VIEW gold.dim_customers;
GO

CREATE VIEW gold.dim_customers AS
WITH geolocation_by_zip AS (
    SELECT
        geolocation_zip_code_prefix,
        AVG(geolocation_lat) AS latitude,
        AVG(geolocation_lng) AS longitude
    FROM silver.olist_geolocation
    GROUP BY geolocation_zip_code_prefix
),
ranked_customer_addresses AS (
    SELECT
        c.customer_id,
        c.customer_unique_id,
        c.customer_zip_code_prefix,
        c.customer_city,
        c.customer_state,
        o.order_purchase_timestamp,
        ROW_NUMBER() OVER (
            PARTITION BY c.customer_unique_id 
            ORDER BY o.order_purchase_timestamp DESC
        ) AS address_rank
    FROM silver.olist_customers AS c
    INNER JOIN silver.olist_orders AS o
        ON c.customer_id = o.customer_id
)
SELECT
    r.customer_unique_id,
    r.customer_id AS latest_customer_id,
    r.customer_zip_code_prefix,
    r.customer_city,
    r.customer_state,
    g.latitude,
    g.longitude
FROM ranked_customer_addresses AS r
LEFT JOIN geolocation_by_zip AS g
    ON r.customer_zip_code_prefix = g.geolocation_zip_code_prefix
WHERE r.address_rank = 1;

-- ===========================================================================================
-- Create Dimension: gold.dim_products
-- ===========================================================================================

IF OBJECT_ID('gold.dim_products', 'V') IS NOT NULL
    DROP VIEW gold.dim_products;
GO

CREATE VIEW gold.dim_products AS
SELECT
    p.product_id,
	p.product_category_name,
    t.product_category_name_english,
	p.product_name_length,
	p.product_description_length,
	p.product_photos_qty,
	p.product_weight_g,
	p.product_length_cm,
	p.product_height_cm,
	p.product_width_cm
FROM silver.olist_products AS p
LEFT JOIN silver.product_category_translation AS t
    ON p.product_category_name = t.product_category_name;

-- ===========================================================================================
-- Create Dimension: gold.dim_sellers
-- ===========================================================================================

IF OBJECT_ID('gold.dim_sellers', 'V') IS NOT NULL
    DROP VIEW gold.dim_sellers;
GO

CREATE VIEW gold.dim_sellers AS
WITH geolocation_by_zip AS (
    SELECT
        geolocation_zip_code_prefix,
        AVG(geolocation_lat) AS latitude,
        AVG(geolocation_lng) AS longitude
    FROM silver.olist_geolocation
    GROUP BY geolocation_zip_code_prefix
)
SELECT 
    s.seller_id,
	s.seller_zip_code_prefix,
    s.seller_city,
    s.seller_state,
    g.latitude,
    g.longitude
FROM silver.olist_sellers AS s
LEFT JOIN geolocation_by_zip AS g
    ON s.seller_zip_code_prefix = g.geolocation_zip_code_prefix;

-- ===========================================================================================
-- Create Fact Table: gold.fact_order_items
-- ===========================================================================================

IF OBJECT_ID ('gold.fact_order_items', 'V') IS NOT NULL
	DROP VIEW gold.fact_order_items;
GO

CREATE VIEW gold.fact_order_items AS
SELECT
    CONCAT(
        oi.order_id,
        '-',
        oi.order_item_id
    ) AS order_item_key,
    oi.order_id,
    oi.order_item_id,
    c.customer_unique_id,
    oi.product_id,
    oi.seller_id,
    o.order_purchase_timestamp,
    oi.shipping_limit_date,
    oi.price,
    oi.freight_value,
    oi.price + oi.freight_value AS total_item_value,
    CASE
        WHEN oi.price = 0 THEN NULL
        ELSE oi.freight_value / oi.price
    END AS freight_to_price_ratio,
    1 AS item_count
FROM silver.olist_order_items AS oi
INNER JOIN silver.olist_orders AS o
    ON oi.order_id = o.order_id
INNER JOIN silver.olist_customers AS c
    ON o.customer_id = c.customer_id;

-- ===========================================================================================
-- Create Fact Table: gold.fact_orders
-- ===========================================================================================

IF OBJECT_ID ('gold.fact_orders', 'V') IS NOT NULL
    DROP VIEW gold.fact_orders;
GO

CREATE VIEW gold.fact_orders AS
SELECT
    o.order_id,
    c.customer_unique_id,
    o.order_purchase_timestamp,
    o.order_approved_at,
    o.order_delivered_carrier_date,
    o.order_delivered_customer_date,
    o.order_estimated_delivery_date,
    o.order_status,
    1 AS order_count,
    DATEDIFF(
        HOUR,
        o.order_purchase_timestamp,
        o.order_approved_at
    ) AS approval_hours,
    DATEDIFF(
        DAY,
        o.order_purchase_timestamp,
        o.order_delivered_customer_date
    ) AS delivery_days,
    DATEDIFF(
        DAY,
        o.order_estimated_delivery_date,
        o.order_delivered_customer_date
    ) AS days_late,
    CASE
        WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date THEN 1
        ELSE 0
    END AS late_delivery_flag,
    o.invalid_date_sequence_flag
FROM silver.olist_orders AS o
INNER JOIN silver.olist_customers AS c
    ON o.customer_id = c.customer_id;

-- ===========================================================================================
-- Create Fact Table: gold.fact_payments
-- ===========================================================================================

IF OBJECT_ID ('gold.fact_payments', 'V') IS NOT NULL
    DROP VIEW gold.fact_payments;
GO

CREATE VIEW gold.fact_payments AS
SELECT
    CONCAT(
        p.order_id,
        '-',
        p.payment_sequential
    ) AS payment_key,
    p.order_id,
    p.payment_sequential,
    c.customer_unique_id,
    o.order_purchase_timestamp,
    p.payment_type,
    p.payment_installments,
    p.payment_value,
    1 AS payment_count
FROM silver.olist_order_payments AS p
INNER JOIN silver.olist_orders AS o
    ON p.order_id = o.order_id
INNER JOIN silver.olist_customers AS c
    ON o.customer_id = c.customer_id;
