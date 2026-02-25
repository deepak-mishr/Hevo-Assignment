-- 1. Create a dedicated Database
CREATE DATABASE your_sf_database_name;

-- 2. Create a Warehouse (Compute) for dbt to use later
CREATE WAREHOUSE your_sf_warehouse_name WITH WAREHOUSE_SIZE = 'XSMALL' AUTO_SUSPEND = 60;
