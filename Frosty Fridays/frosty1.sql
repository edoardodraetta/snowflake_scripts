-- FROSTY CHALLENGE 1
-- CREATE AN EXTERNAL STAGE 

CREATE WAREHOUSE frosty_wh WAREHOUSE_SIZE = 'X-SMALL';
USE DATABASE FROSTY_DATABASE;

CREATE OR REPLACE STAGE frosty_s3_stage
  URL = 's3://frostyfridaychallenges/challenge_1/';

CREATE OR REPLACE TABLE frosty_table (
    data TEXT
);

COPY INTO frosty_table
  FROM @frosty_s3_stage
  PATTERN='.*.csv'
  FORCE = TRUE;

SELECT * FROM frosty_table;