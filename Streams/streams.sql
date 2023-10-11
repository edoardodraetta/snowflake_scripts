
CREATE OR REPLACE STREAM raw.files_from_mike.raw_stream ON TABLE raw.files_from_mike.mockdata_table;
CREATE OR REPLACE STREAM stg.public.customers_stream ON TABLE stg.public.cleaned_data;
CREATE OR REPLACE STREAM stg.public.internet_stream ON TABLE stg.public.cleaned_data;

-- RAW -> STAGING
CREATE OR REPLACE TASK populate_staging_table 
WAREHOUSE = compute_wh 
SCHEDULE = '1 minute' WHEN system$stream_has_data('raw.files_from_mike.raw_stream')
AS  
MERGE INTO stg.public.cleaned_data USING raw.files_from_mike.raw_stream ON cleaned_data.ID = raw_stream.ID
  WHEN MATCHED AND metadata$action = 'DELETE' AND metadata$isupdate = 'FALSE' 
    THEN DELETE
  WHEN MATCHED AND metadata$action = 'INSERT' AND metadata$isupdate = 'TRUE' 
    THEN UPDATE SET cleaned_data.id = raw_stream.id,
        cleaned_data.name = CONCAT(raw_stream.first_name, ' ', raw_stream.first_name),
        cleaned_data.email= raw_stream.email,
        cleaned_data.gender= raw_stream.gender,
        cleaned_data.ip_address = raw_stream.ip_address,
        cleaned_data.date = TO_DATE(raw_stream.date, 'dd.mm.yyyy') 
  WHEN NOT MATCHED AND metadata$action = 'INSERT' AND metadata$isupdate = 'FALSE'
    THEN INSERT (id, name, email, gender, ip_address, date) VALUES (
            raw_stream.id, 
            CONCAT(raw_stream.first_name, ' ', raw_stream.last_name),
            raw_stream.email,
            raw_stream.gender,
            raw_stream.ip_address,
            TO_DATE(raw_stream.date, 'dd.mm.yyyy')
)
;

-- STG -> PROD

-- Create the task to automate
CREATE OR REPLACE TASK populate_customers_table 
WAREHOUSE = compute_wh 
SCHEDULE = '1 minute' WHEN system$stream_has_data('stg.public.customers_stream')
AS  
MERGE INTO prd.public.customers USING stg.public.customers_stream ON customer_ID = customers_stream.ID
  WHEN MATCHED AND metadata$action = 'DELETE' AND metadata$isupdate = 'FALSE' 
    THEN DELETE
  WHEN MATCHED AND metadata$action = 'INSERT' AND metadata$isupdate = 'TRUE' 
    THEN UPDATE SET 
        customers.customer_id = customers_stream.id,
        customers.name = customers_stream.name,
        customers.email= customers_stream.email,
        customers.gender= customers_stream.gender,
        customers.ip_address = customers_stream.ip_address,
        customers.date = customers_stream.date
  WHEN NOT MATCHED AND metadata$action = 'INSERT' AND metadata$isupdate = 'FALSE'
    THEN INSERT (customer_id, name, email, gender, ip_address, date) VALUES (
customers_stream.id, 
customers_stream.name, 
customers_stream.email,
customers_stream.gender, 
customers_stream.ip_address,
customers_stream.date
)
;

-- STG -> PROD (SECOND)

-- Create the task to automate
CREATE OR REPLACE TASK populate_internet_table 
WAREHOUSE = compute_wh 
SCHEDULE = '1 minute' WHEN system$stream_has_data('stg.public.internet_stream')
AS  
MERGE INTO prd.public.internet_connection_for_customers USING stg.public.internet_stream ON customer_ID = internet_stream.ID
  WHEN MATCHED AND metadata$action = 'DELETE' AND metadata$isupdate = 'FALSE' 
    THEN DELETE
  WHEN MATCHED AND metadata$action = 'INSERT' AND metadata$isupdate = 'TRUE' 
    THEN UPDATE SET 
        internet_connection_for_customers.customer_id = internet_stream.id,
        internet_connection_for_customers.ip_address = internet_stream.ip_address
  WHEN NOT MATCHED AND metadata$action = 'INSERT' AND metadata$isupdate = 'FALSE'
    THEN INSERT (customer_id, ip_address) VALUES (
internet_stream.id, 
internet_stream.ip_address
)
;

ALTER TASK populate_staging_table RESUME;
ALTER TASK populate_customers_table RESUME;
ALTER TASK populate_internet_table RESUME;
SHOW TASKS;