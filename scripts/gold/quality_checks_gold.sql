/*
==============================================================================
Quality Checks
==============================================================================
Script Purpose:
    This script performs quality checks to validate the integrity, consistency,
    and accuracy of the Gold layer.
    Because these tables were already thoroughly vetted in the silver layer,
    these checks primarily focus on the uniquness of keys.

Usage Notes:
    - Run these checks after creating the Gold views.
    - Investigate and resolve any discrepancies found during the checks.
==============================================================================
*/

-- ===========================================================================
-- Checking 'gold.dim_customers'
-- ===========================================================================
-- Verifying uniqueness of customer_unique_id in gold.dim_customers
-- Expectation: No Duplicates
SELECT customer_unique_id, COUNT(*)
FROM gold.dim_customers
GROUP BY customer_unique_id
HAVING COUNT(*) > 1;

-- ===========================================================================
-- Checking 'gold.dim_products'
-- ===========================================================================
-- Verifying uniqueness of product_id in gold.dim_products
-- Expectation: No Duplicates
SELECT product_id, COUNT(*)
FROM gold.dim_products
GROUP BY product_id
HAVING COUNT(*) > 1 OR product_id IS NULL;

-- ===========================================================================
-- Checking 'gold.dim_sellers'
-- ===========================================================================
-- Verifying uniqueness of seller_id in gold.dim_sellers
-- Expectation: No Duplicates
SELECT seller_id, COUNT(*)
FROM gold.dim_sellers
GROUP BY seller_id
HAVING COUNT(*) > 1 OR seller_id IS NULL;

-- ===========================================================================
-- Checking 'gold.fact_order_items'
-- ===========================================================================
-- Verifying uniqueness of order_item_key in gold.fact_order_items
-- Expectation: No Duplicates
SELECT order_item_key, COUNT(*)
FROM gold.fact_order_items
GROUP BY order_item_key
HAVING COUNT(*) > 1 OR order_item_key IS NULL;

-- ===========================================================================
-- Checking 'gold.fact_orders'
-- ===========================================================================
-- Verifying uniqueness of order_id in gold.fact_orders
-- Expectation: No Duplicates
SELECT order_id, COUNT(*)
FROM gold.fact_orders
GROUP BY order_id
HAVING COUNT(*) > 1 OR order_id IS NULL;

-- ===========================================================================
-- Checking 'gold.fact_payments'
-- ===========================================================================
-- Verifying uniqueness of payment_key in gold.fact_payments
-- Expectation: No Duplicates
SELECT payment_key, COUNT(*)
FROM gold.fact_payments
GROUP BY payment_key
HAVING COUNT(*) > 1 OR payment_key IS NULL;
