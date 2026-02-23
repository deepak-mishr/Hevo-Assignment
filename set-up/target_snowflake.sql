-- 1. Create a dedicated Database
CREATE DATABASE HEVO_DESTINATION;

-- 2. Create a Warehouse (Compute) for dbt to use later
CREATE WAREHOUSE HEVO_WH WITH WAREHOUSE_SIZE = 'XSMALL' AUTO_SUSPEND = 60;
