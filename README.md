# E-Commerce-Data-Warehouse

## Technologies:
- SQL Server

## Project Overview:
In this project, I use nine different CSV files with data about Brazilian E-Commerce orders to construct a Data Warehouse in SQL Server complete with distinct layers, stored procedures, and views. Each schema - labeled bronze, silver, and gold respectively, serves a different purpose in the ETL pipeline. All code can be found in the 'scripts' folder of this repository.

## Dataset

This project was made using the **Brazilian E-Commerce Public Dataset by Olist** dataset from Kaggle.

**Source:**
https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce/data

## Bronze Layer

When building the bronze layer of the Data Warehouse, I first opened each CSV file using Notebook and verified its column names. After loading in each file, I would check the number of rows returned for each table using COUNT(*), and checked this against the number of rows in the original CSV files.

Despite noticing varying datatypes, I stored all data either as VARCHAR or NVARCHAR when loading the CSV files into the bronze tables.

## Silver Layer

Having successfully imported the raw CSV files into the bronze layer, I first inspected them before writing the DDL script for the silver layer. I checked each table for duplicate primary keys, null values, and spaces. What I found to be the most interesting part of this process was while exploring the bronze.olist_orders table. In this table, there were four columns containing dates / times, and I identified the proper order in which the times should progress.

However, I noticed that a small percentage of the data did not follow this correct progression - in these cases, rather than try to 'swap' data on my own, I simply created a new column titled 'invalid_date_sequence_flag' which would have a value of 1 when the dates in its row did not follow the correct progression, and a value of 0 otherwise. This way, I did not perform some erroneous 'fix' on the column, but I am still able to notify users that something seems incorrect with these dates and allow for users to filter them out if desired.

## Gold Layer

During this final stage of building the Data Warehouse I utilized CTEs, Window Functions, and joins to create six views in the gold layer - three dimension tables, and three fact tables. These include:

(1) gold.dim_customers:
- Built by selecting columns after joining the silver.olist_geolocation, silver.olist_customers, and silver.olist_orders tables

(2) gold.dim_products:
- Built by selecting columns after joining the silver.olist_products and silver.product_category_translation tables

(3) gold.dim_sellers:
- Built by selecting columns after joining the silver.olist_geolocation and silver.olist_sellers tables

(4) gold.fact_order_items
- Built by selecting columns after joining the silver.olist_order_reviews, silver.olist_order_items, silver.olist_orders, and silver_olist_customers tables

(5) gold.fact_orders
- Built by selecting columns after joining the silver.olist_orders and silver.olist_customers tables

(6) gold.fact_payments
- Built by selecting columns after joining the silver.olist_order_payments, silver.olist_orders, and silver.olist_customers tables
