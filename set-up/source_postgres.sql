-- source_postgres.sql

-- 1. Create Tables
CREATE TABLE IF NOT EXISTS raw_customers (id INT PRIMARY KEY, first_name VARCHAR(255), last_name VARCHAR(255));
CREATE TABLE IF NOT EXISTS raw_orders (id INT PRIMARY KEY, user_id INT, order_date DATE, status VARCHAR(50));
CREATE TABLE IF NOT EXISTS raw_payments (id INT PRIMARY KEY, order_id INT, payment_method VARCHAR(100), amount INT);

COPY raw_customers(id, first_name, last_name) 
FROM '/tmp/raw_customers.csv' DELIMITER ',' CSV HEADER;

COPY raw_orders(id, user_id, order_date, status) 
FROM '/tmp/raw_orders.csv' DELIMITER ',' CSV HEADER;

COPY raw_payments(id, order_id, payment_method, amount) 
FROM '/tmp/raw_payments.csv' DELIMITER ',' CSV HEADER;


-- 2. Create the Publication using a variable
-- We wrap in a DO block or use standard syntax with :variable
DROP PUBLICATION IF EXISTS :pub_name;
CREATE PUBLICATION :pub_name FOR ALL TABLES;

-- 3. Create the Logical Replication Slot
-- We use a DO block to ensure we don't error out if it already exists
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_replication_slots WHERE slot_name = ':slot_name') THEN
        PERFORM pg_create_logical_replication_slot(':slot_name', 'pgoutput');
    END IF;
END $$;
