-- 1. Create a dedicated Database
CREATE DATABASE {{ env_var('SNOW_DB') }};

-- 2. Create a Warehouse (Compute) for dbt to use later
CREATE WAREHOUSE {{ env_var('SNOW_WH') }} WITH WAREHOUSE_SIZE = 'XSMALL' AUTO_SUSPEND = 60;
