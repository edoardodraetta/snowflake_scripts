-- CREATE SAMPLE 
CREATE OR REPLACE DATABASE sample_data_limited;
/*
LIMIT 1000000000
*/
CREATE TABLE call_center AS (
SELECT * FROM SNOWFLAKE_SAMPLE_DATA.TPCDS_SF10TCL.CALL_CENTER
);

CREATE TABLE catalog_page AS (
SELECT * FROM SNOWFLAKE_SAMPLE_DATA.TPCDS_SF10TCL.catalog_page
);

--1%
CREATE TABLE catalog_returns AS (
SELECT * FROM SNOWFLAKE_SAMPLE_DATA.TPCDS_SF10TCL.catalog_returns
LIMIT 14000000
);
--1%
CREATE TABLE catalog_sales AS (
SELECT * FROM SNOWFLAKE_SAMPLE_DATA.TPCDS_SF10TCL.catalog_sales
LIMIT 144000000
);
CREATE TABLE customer AS (
SELECT * FROM SNOWFLAKE_SAMPLE_DATA.TPCDS_SF10TCL.customer
);
CREATE TABLE customer_address AS (
SELECT * FROM SNOWFLAKE_SAMPLE_DATA.TPCDS_SF10TCL.customer_address
);
CREATE TABLE customer_demographics AS (
SELECT * FROM SNOWFLAKE_SAMPLE_DATA.TPCDS_SF10TCL.customer_demographics
);
CREATE TABLE household_demographics AS (
SELECT * FROM SNOWFLAKE_SAMPLE_DATA.TPCDS_SF10TCL.household_demographics
);
CREATE TABLE income_band AS (
SELECT * FROM SNOWFLAKE_SAMPLE_DATA.TPCDS_SF10TCL.income_band
);
--1%
CREATE TABLE inventory AS (
SELECT * FROM SNOWFLAKE_SAMPLE_DATA.TPCDS_SF10TCL.inventory
LIMIT 13000000);
CREATE TABLE item AS (
SELECT * FROM SNOWFLAKE_SAMPLE_DATA.TPCDS_SF10TCL.item
);
CREATE TABLE promotion AS (
SELECT * FROM SNOWFLAKE_SAMPLE_DATA.TPCDS_SF10TCL.promotion
);
CREATE TABLE reason AS (
SELECT * FROM SNOWFLAKE_SAMPLE_DATA.TPCDS_SF10TCL.reason
);
CREATE TABLE ship_mode AS (
SELECT * FROM SNOWFLAKE_SAMPLE_DATA.TPCDS_SF10TCL.ship_mode
);
CREATE TABLE store AS (
SELECT * FROM SNOWFLAKE_SAMPLE_DATA.TPCDS_SF10TCL.store
);

CREATE TABLE STORE_RETURNS AS (
SELECT * FROM SNOWFLAKE_SAMPLE_DATA.TPCDS_SF10TCL.STORE_RETURNS
LIMIT 29000000);
--store_sales 1/100
CREATE TABLE store_sales AS (
SELECT * FROM SNOWFLAKE_SAMPLE_DATA.TPCDS_SF10TCL.STORE_SALES
LIMIT 280000000);

CREATE TABLE TIME_DIM AS (
SELECT * FROM SNOWFLAKE_SAMPLE_DATA.TPCDS_SF10TCL.TIME_DIM
);
CREATE TABLE WAREHOUSE AS (
SELECT * FROM SNOWFLAKE_SAMPLE_DATA.TPCDS_SF10TCL.WAREHOUSE
);
CREATE TABLE web_page AS (
SELECT * FROM SNOWFLAKE_SAMPLE_DATA.TPCDS_SF10TCL.web_page
);
--1%
CREATE TABLE web_returns AS (
SELECT * FROM SNOWFLAKE_SAMPLE_DATA.TPCDS_SF10TCL.web_returns
LIMIT 7200000
);
--1%
CREATE TABLE web_sales AS (
SELECT * FROM SNOWFLAKE_SAMPLE_DATA.TPCDS_SF10TCL.web_sales
LIMIT 72000000
);
CREATE TABLE web_site AS (
SELECT * FROM SNOWFLAKE_SAMPLE_DATA.TPCDS_SF10TCL.web_site
);
CREATE TABLE date_dim AS (
SELECT * FROM SNOWFLAKE_SAMPLE_DATA.TPCDS_SF10TCL.date_dim
);

-- exercises start here 
----------
-- EASY --
----------
// 1) What is the total number of in-store sales made in the dataset?

SELECT * FROM store_sales LIMIT 20;
SELECT 
  COUNT(
    DISTINCT 
      ss_item_sk
      , ss_ticket_number
  ) 
FROM store_sales;

SELECT 
  COUNT(*) 
FROM store_sales;

// 2) What is the total revenue generated by each store in the dataset?
SELECT
  SUM(ss_sales_price) AS revenue
FROM store_sales
JOIN store
  ON ss_store_sk = s_store_sk
GROUP BY 
  s_store_id
ORDER BY revenue DESC;

// 3) What is the average sales amount for each product category?
SELECT
  SUM(ss_sales_price) AS revenue
FROM store_sales
JOIN item
  ON ss_item_sk = i_item_sk
GROUP BY 
  i_category
ORDER BY revenue DESC;

// 4) What is the total number of products sold in each quarter of the year?
SELECT
  -- SUM(ss_sales_price) AS revenue
  COUNT(*) AS products_sold
  , QUARTER(d_date::DATE) AS quarter
FROM store_sales
JOIN date_dim
  ON ss_sold_date_sk = d_date_sk
GROUP BY quarter
ORDER BY products_sold DESC;

SELECT * FROM date_dim LIMIT 10;

// 5) What is the total revenue generated by each customer demographic?
SELECT
  cd_demo_sk
  , SUM(ss_sales_price) AS revenue
FROM store_sales
JOIN customer_demographics
  ON ss_cdemo_sk = cd_demo_sk
GROUP BY 
  cd_demo_sk
ORDER BY revenue DESC LIMIT 10;

// 6) What is the average time between when a catalog product is sold and when it is shipped?
WITH cat_sold_dates AS (
    SELECT 
        cs_ship_date_sk
        , cs_sold_date_sk
        , d_date AS sold_date
    FROM catalog_sales
    INNER JOIN date_dim
        ON cs_sold_date_sk = d_date_sk
),

cat_sold_ship_dates AS ( 
    SELECT 
        cs_ship_date_sk
        , cs_sold_date_sk
        , d_date AS ship_date
        , sold_date
    FROM cat_sold_dates
    INNER JOIN date_dim
        ON cs_ship_date_sk = d_date_sk 
),

final AS (
    SELECT 
        ship_date
        , sold_date
    FROM cat_sold_ship_dates
)
SELECT 
    ROUND(AVG(ship_date - sold_date), 2) AS average_delay
FROM final
WHERE 1=1;

SELECT
    ROUND(AVG(shipped_date.d_date - sold_date.d_date), 2) AS average_delay
FROM catalog_sales AS cs
JOIN date_dim sold_date 
    ON sold_date.d_date_sk = cs_sold_date_sk
JOIN date_dim shipped_date 
    ON shipped_date.d_date_sk = cs_ship_date_sk
LIMIT 10;

// 7) What is the total number of returns made by each store?

SELECT 
    s_store_id
    , COUNT(*) AS total_returns
FROM store_returns
LEFT JOIN store
    ON sr_store_sk = s_store_sk
GROUP BY s_store_id
ORDER BY total_returns DESC
LIMIT 10;

// 8) What is the most popular product sold in each county from stores?

WITH rank_items AS (
    SELECT
        ss_item_sk
        , s_county
        , RANK() OVER (
            PARTITION BY s_county 
            ORDER BY SUM(ss_quantity) DESC
        ) AS rank
    FROM store_sales
    INNER JOIN store
        ON ss_store_sk = s_store_sk
    WHERE 1=1
        AND ss_quantity IS NOT NULL
    GROUP BY ss_item_sk, s_county
)
SELECT
    ss_item_sk
    , s_county
    , rank
FROM rank_items
WHERE 1=1
    AND rank=1;


// 9) What is the average number of items per order (for store, web and catalog sales)?
SELECT
    AVG(ss_quantity)
FROM store_sales;

SELECT
    AVG(cs_quantity)
FROM catalog_sales;

SELECT
    AVG(ws_quantity)
FROM web_sales;

// 10) What is the total number of orders fulfilled by each warehouse for web sales?
SELECT
    COUNT(*) AS total_orders
    , w_warehouse_sk
FROM web_sales
INNER JOIN warehouse
    ON ws_warehouse_sk = w_warehouse_sk
GROUP BY w_warehouse_sk
ORDER BY total_orders DESC
LIMIT 10;


------------
-- MEDIUM --
------------

// What is the total revenue generated by each store in each quarter of the year?
// What is the top selling product in each product category for each month of the year (not just physical stores)?
// Which store had the highest growth in revenue from the first quarter to the fourth quarter of the year? (so ignore q2,q3 and do q1 vs q4)
// What is the percentage of orders that were returned in each county (not just physical stores)?
// Which shipmode had the highest average item amount per order?

----------
-- HARD --
----------
// Write a query to find the top 10 customers who have made the most purchases from the store, but who have never returned any items.


// Write a query to find the top 5 warehouses that had the most items that were sold to customers who have never made a purchase from the store before.
