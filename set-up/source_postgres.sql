-- Create Tables
CREATE TABLE raw_customers (id INT PRIMARY KEY, first_name VARCHAR(255), last_name VARCHAR(255));
CREATE TABLE raw_orders (id INT PRIMARY KEY, user_id INT, order_date DATE, status VARCHAR(50));
CREATE TABLE raw_payments (id INT PRIMARY KEY, order_id INT, payment_method VARCHAR(100), amount INT);

-- Load CSVs (Path inside container)
COPY raw_customers FROM '/tmp/raw_customers.csv' DELIMITER ',' CSV HEADER;
COPY raw_orders FROM '/tmp/raw_orders.csv' DELIMITER ',' CSV HEADER;
COPY raw_payments FROM '/tmp/raw_payments.csv' DELIMITER ',' CSV HEADER;

-- Setup Replication
CREATE PUBLICATION :pub_name FOR ALL TABLES;
SELECT pg_create_logical_replication_slot(':slot_name', 'pgoutput');
