/*
==============================================================================
Quality Checks
==============================================================================
Script Purpose:
    This script performs quality checks to validate the integrity, consistency,
    and accuracy of the Silver Layer.
    There was additional EDA / Feature Engineering work during the creation
    of this layer detailed in the README section of this project.

Usage Notes:
    - Run these checks after creating the Silver tables.
    - Investigate and resolve any discrepancies found during the checks.
==============================================================================
*/

-- ===========================================================================
-- Checking 'silver.olist_orders'
-- ===========================================================================
-- Verifying uniqueness of order_id and customer_id in silver.olist_orders
-- Expectation: No Duplicates
SELECT order_id, COUNT(*)
FROM silver.olist_orders
GROUP BY order_id
HAVING COUNT(*) > 1 OR order_id IS NULL;

SELECT customer_id, COUNT(*)
FROM silver.olist_orders
GROUP BY customer_id
HAVING COUNT(*) > 1 OR customer_id IS NULL;

-- ===========================================================================
-- Checking 'silver.olist_customers'
-- ===========================================================================
-- Verifying uniqueness of customer_id in silver.olist_customers
-- Expectation: No Duplicates
SELECT customer_id, COUNT(*)
FROM silver.olist_customers
GROUP BY customer_id
HAVING COUNT(*) > 1 OR customer_id IS NULL;

-- ===========================================================================
-- Checking 'silver.olist_sellers'
-- ===========================================================================
-- Verifying uniqueness of seller_id in silver.olist_sellers
-- Expectation: No Duplicates
SELECT seller_id, COUNT(*)
FROM silver.olist_sellers
GROUP BY seller_id
HAVING COUNT(*) > 1 OR seller_id IS NULL;

-- ===========================================================================
-- Checking 'silver.olist_products'
-- ===========================================================================
-- Verifying uniqueness of product_id in silver.olist_products
-- Expectation: No Duplicates
SELECT product_id, COUNT(*)
FROM silver.olist_products
GROUP BY product_id
HAVING COUNT(*) > 1 OR product_id IS NULL;
