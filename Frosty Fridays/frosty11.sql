-- Set the database and schema
CREATE database frosty_database;
use database frosty_database;
use schema public;

-- Create a file format.
CREATE OR REPLACE FILE FORMAT my_csv_format
  TYPE = CSV
  SKIP_HEADER = 1;
  
-- Create the stage that points at the data.
create or replace stage week_11_frosty_stage
    url = 's3://frostyfridaychallenges/challenge_11/'
    file_format = my_csv_format;

-- LIST @week_11_frosty_stage;

-- Create the table as a CTAS statement.
create or replace table frosty_database.public.week11 as
select m.$1 as milking_datetime,
        m.$2 as cow_number,
        m.$3 as fat_percentage,
        m.$4 as farm_code,
        m.$5 as centrifuge_start_time,
        m.$6 as centrifuge_end_time,
        m.$7 as centrifuge_kwph,
        m.$8 as centrifuge_electricity_used,
        m.$9 as centrifuge_processing_time,
        m.$10 as task_used
from @week_11_frosty_stage (file_format => my_csv_format, pattern => '.*milk_data.*[.]csv') m;

-- Check the table.
 SELECT * FROM week11 LIMIT 10;

-- SELECT * FROM week11 WHERE fat_percentage = 3;

-- SELECT 
--     *
--     , DATEDIFF(second, centrifuge_start_time::TIMESTAMP, centrifuge_end_time::TIMESTAMP) AS "Time_diff"
-- FROM week11
-- WHERE fat_percentage != 3;

-- TASK 1: Remove all the centrifuge dates and centrifuge kwph and replace them with NULLs WHERE fat = 3. 
-- Add note to task_used.
create or replace task whole_milk_updates
    schedule = '1400 minutes'
as
    UPDATE week11 
    SET 
        centrifuge_kwph = NULL
        , task_used = 'whole milk' 
    WHERE fat_percentage = 3;

-- TASK 2: Calculate centrifuge processing time (difference between start and end time) WHERE fat != 3. 
-- Add note to task_used.
create or replace task skim_milk_updates
    after frosty_database.public.whole_milk_updates
as
    UPDATE week11 
    SET 
        centrifuge_processing_time = DATEDIFF(second, centrifuge_start_time::TIMESTAMP, centrifuge_end_time::TIMESTAMP)
        , task_used = 'skim milk'  
    WHERE fat_percentage != 3;

-- Manually execute the task.
alter task skim_milk_updates resume;
alter task whole_milk_updates suspend;

execute task whole_milk_updates;

-- Check that the data looks as it should.
select * from week11;

-- Check that the numbers are correct.
select task_used, count(*) as row_count from week11 group by task_used;


USE database database_1;
DROP database frosty_database;