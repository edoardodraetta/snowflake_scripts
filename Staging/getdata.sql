-- Get all the data from a table called test_download , to a local csv file that uses ';' 
-- as a separator between columns.

USE DATABASE my_db;
USE WAREHOUSE loading_wh;

REMOVE @%my_table;

CREATE OR REPLACE FILE FORMAT my_export_csv_format
  TYPE = CSV
  FIELD_DELIMITER = 'THISISANEWCOLUMN'
  COMPRESSION = NONE
  ;
  
COPY INTO @%my_table/file_out
  FROM my_table
  PARTITION BY (id)
  FILE_FORMAT = my_export_csv_format
  -- OVERWRITE = TRUE
  HEADER = TRUE
  ;

LIST @%my_table;