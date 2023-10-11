CREATE OR REPLACE DYNAMIC TABLE stg.public.dynamic_cleaned_data 
  TARGET_LAG = '20 minutes'
  WAREHOUSE = compute_wh
  AS
    SELECT 
    id 
    , CONCAT(first_name, ' ', last_name) AS name
    , email 
    , gender 
    , ip_address 
    , TO_DATE(date, 'dd.mm.yyyy') AS date
FROM  raw.files_from_mike.mockdata_table;


CREATE OR REPLACE DYNAMIC TABLE prd.public.dynamic_internet_connection_for_customers (
    customer_id INT
    , ip_address TEXT
) TARGET_LAG = '20 minutes'
  WAREHOUSE = compute_wh 
  AS SELECT
    id
    , ip_address
FROM stg.public.dynamic_cleaned_data;

CREATE OR REPLACE DYNAMIC TABLE prd.public.dynamic_customers (
    customer_id INT
    , name TEXT
    , email TEXT
    , gender TEXT
    , ip_address TEXT
    , date DATE
) TARGET_LAG = '20 minutes'
  WAREHOUSE = compute_wh 
  AS SELECT
    id
    , name 
    , email 
    , gender 
    , ip_address 
    , date 
FROM stg.public.dynamic_cleaned_data;

ALTER DYNAMIC TABLE stg.public.dynamic_cleaned_data REFRESH;
ALTER DYNAMIC TABLE prd.public.dynamic_customers REFRESH;
ALTER DYNAMIC TABLE prd.public.dynamic_internet_connection_for_customers REFRESH;

SELECT COUNT(*) FROM stg.public.dynamic_cleaned_data;
SELECT COUNT(*) FROM prd.public.dynamic_customers;
SELECT COUNT(*) FROM prd.public.dynamic_internet_connection_for_customers;