-----------
-- SQL 1 -- 
-----------

-- SNOWFLAKE_SAMPLE_DATA / TPCH_SF1

USE SCHEMA snowflake_sample_data.tpch_sf1;

-- Answer the following questions :

-- 1) What is the total revenue generated by all orders in the dataset?
SELECT * 
FROM orders 
LIMIT 10;

SELECT
    SUM(o_totalprice) AS total_revenue
FROM orders;

-- What is the average discount applied to line items in all orders?
SELECT
    AVG(l_discount) AS average_discount
FROM lineitem;

-- How many distinct customers have placed orders in the dataset?
SELECT 
    COUNT(DISTINCT o_custkey) AS distinct_customers
FROM orders;

-- What is the highest price of a part in the inventory?
SELECT
    MAX(p_retailprice) AS max_price_in_inventory
FROM part;

-- How many orders were placed on a Monday?
SELECT 
    COUNT(*)
FROM orders
WHERE DAYOFWEEK(o_orderdate::DATE) = 1;


-----------
-- SQL 2 -- 
-----------

-- Answer the following questions :

-- 1) What is the total revenue generated by all orders in the dataset for the month of January 1993?
SELECT 
    SUM(o_totalprice) AS total_revenue_jan_93
FROM orders
WHERE 1=1
    AND YEAR(o_orderdate::DATE) = 1993;
    AND MONTH(o_orderdate::DATE) = 1;


-- 2) What is the total revenue generated by orders in the dataset where the ship date was after the commit date?
SELECT
    SUM(o_totalprice) AS total_revenue
FROM orders
INNER JOIN lineitem
    ON o_orderkey = l_orderkey
WHERE l_shipdate > l_commitdate;

-- 3) What is the average order size (in terms of total price) for customers from each country?
SELECT
    n_name
    , AVG(o_totalprice) AS avg_order_price
FROM orders
INNER JOIN customer
    ON o_custkey = c_custkey
INNER JOIN nation
    ON c_nationkey = n_nationkey
GROUP BY n_name
ORDER BY avg_order_price DESC;

-- 4) What is the average amount of time it takes to ship an order (in days) for each ship mode?

SELECT
    AVG(DATEDIFF('day', o_orderdate::DATE, l_shipdate::DATE )) AS avg_ship_time
FROM orders
INNER JOIN lineitem
    ON o_orderkey = l_orderkey
GROUP BY l_shipmode
ORDER BY avg_ship_time DESC;

-- 5) What is the average discount applied to line items in orders placed by customers from each region?

SELECT
    n_name
    , AVG(l_discount) AS avg_discount
FROM orders
INNER JOIN lineitem
    ON o_orderkey = l_orderkey
INNER JOIN customer
    ON o_custkey = c_custkey
INNER JOIN nation
    ON c_nationkey = n_nationkey
GROUP BY n_name
ORDER BY avg_discount DESC;

-- Answer these questions and explain in your own words :

-- What is the difference between vertical and horizontal scaling in Snowflake?

/* Horizontal scaling, aka scaling out, is the use of multiclustering to dynamically increase parallel compute while keeping warehouse size static. Vertical scaling, or scaling up, means resizing warehouses.
*/
-- How does the size of a virtual warehouse in Snowflake affect query performance?

/*
Increasing warehouse size by one stage doubles computing power and therefore halves compute time.
*/

-- What is the impact of data clustering on query performance in Snowflake?

/*
All data in snowflake is automatically divided into what snoflake calls micropartitions. Each is a contiguous unit of storage containg 50-500MB of compressed data (smaller actual size bc data in SF is always compressed). Snowflake stores metadata on what is inside each micropartition, including ranges of values, cardinality, and other properties helpful to search. This data clustering can improve query performance through a process called micropartition pruning. If a query specifies a predicate to filter data, the metadata on the micropartitions will allow snowflake to prefilter or prune micropartitions that certainly don't contain the pertinent data. This can radically speed up queries.
*/

-- How does Snowflake's automatic query optimization feature help improve performance?

/*
When a query is written to be executed in snowflake, the cloud service layer will automatically rewrite the query to improve its performance. 
*/

-- What is the purpose of Snowflake's query profiling feature and how can it be used to improve query performance?

/*
Query profiling helps identify queries and steps within queries that are inefficient and holding up warehouses. Once identified, these queries can either be rewritten, or more compute can be assigned to them.
*/
