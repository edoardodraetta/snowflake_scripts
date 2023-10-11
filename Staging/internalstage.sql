----------------------
-- CREATE DB AND WH --
----------------------

CREATE OR REPLACE DATABASE my_db;
USE DATABASE my_db;

CREATE OR REPLACE WAREHOUSE loading_wh 
    WAREHOUSE_SIZE='X-SMALL' 
    INITIALLY_SUSPENDED=TRUE
    AUTO_SUSPEND = 60
    COMMENT = 'Virtual warehouse for loading data into snowflake'
    ;

USE WAREHOUSE loading_wh;

------------------------
-- CREATE FILE FORMAT --
------------------------

CREATE OR REPLACE FILE FORMAT my_csv_format
  TYPE = CSV
  SKIP_HEADER = 1 
  RECORD_DELIMITER = '*' 
  FIELD_DELIMITER = ';' 
  ;

---------------------------
-- CREATE INTERNAL STAGE --
---------------------------

CREATE STAGE my_int_stage
  FILE_FORMAT = my_csv_format
  ;

--------------------
-- LOG ON AND PUT --
--------------------

-- snowsql -a [ACCOUNT LOCATOR] -u [USERNAME]
-- PUT file://[PATH] @[STAGE]


LIST @my_int_stage;


------------------
-- CREATE TABLE --
------------------

CREATE OR REPLACE TABLE my_table 
(
    id INT
    , column_1 
    
    , column_2 INT
    , column_3 INT
);

---------------------
-- COPY INTO TABLE --
---------------------

COPY INTO my_table
  FROM @my_int_stage
  PATTERN='.*'
  FILE_FORMAT = my_csv_format
  FORCE = TRUE;


SELECT * FROM my_table;

-----------
-- RESET --
-----------

DROP WAREHOUSE loading_wh;
DROP DATABASE my_db;
