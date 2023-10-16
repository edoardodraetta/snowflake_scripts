USE DATABASE my_db;
USE WAREHOUSE compute_wh;
SELECT * FROM my_table;

-- SELECT [COLUMN]:[KEY]:[KEY]
SELECT col_1:actor:id::int AS actor_id
FROM json_table
LIMIT 20;

SELECT col_1:type AS actor_type
FROM json_table
LIMIT 20;
-- Create a NEW table with the every piece of data in it’s own column with a correct datatype 

CREATE OR REPLACE TABLE processed_json_table (
    id INT
    , type TEXT
    -- actor
    , actor_id INT
    , actor_login TEXT
    , actor_gravatar_id TEXT
    , actor_url TEXT
    , actor_avatar_url TEXT
    -- -- repo
    , repo_id TEXT
    , repo_name TEXT
    , repo_url TEXT
    -- payload
    , payload_ref TEXT
    , payload_ref_type TEXT
    , payload_master_branch TEXT
    , payload_description TEXT
    , payload_pusher_type TEXT
) AS SELECT 
    col_1:id::int  AS id
    , col_1:type::string AS type
    -- actor
    , col_1:actor:id::int AS actor_id
    , col_1:actor:login::string AS actor_login
    , col_1:actor:gravatar_id::string AS actor_gravatar_id
    , col_1:actor:url::string AS actor_url
    , col_1:actor:avatar_url::string AS actor_avatar_url
    -- -- repo
    , col_1:repo:id::int AS repo_id
    , col_1:repo:name::string AS repo_name
    , col_1:repo:url::string AS repo_url
    -- payload
    , col_1:payload:ref::string AS payload_ref
    , col_1:payload:ref_type::string AS payload_ref_type
    , col_1:payload:master_branch::string AS payload_master_branch
    , col_1:payload:description::string AS payload_description
    , col_1:payload:pusher_type::string AS payload_pusher_type
FROM json_table;

SELECT * FROM processed_json_table;