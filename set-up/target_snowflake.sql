-- 1. Create a dedicated Database
CREATE DATABASE {{ env_var('SNOWFLAKE_DATABASE') }};

-- 2. Create a Warehouse (Compute) for dbt to use later
CREATE WAREHOUSE {{ env_var('SNOWFLAKE_WAREHOUSE') }} WITH WAREHOUSE_SIZE = 'XSMALL' AUTO_SUSPEND = 60;
