-- Create Tables
CREATE TABLE raw_customers (id INT PRIMARY KEY, first_name VARCHAR(255), last_name VARCHAR(255));
CREATE TABLE raw_orders (id INT PRIMARY KEY, user_id INT, order_date DATE, status VARCHAR(50));
CREATE TABLE raw_payments (id INT PRIMARY KEY, order_id INT, payment_method VARCHAR(100), amount INT);


-- 1. Drop the slot if it exists elsewhere to avoid "already exists" errors
SELECT pg_drop_replication_slot('hevo_slot') WHERE EXISTS (SELECT 1 FROM pg_replication_slots WHERE slot_name = 'hevo_slot');

-- 2. Create the Logical Replication Slot for this specific database
SELECT * FROM pg_create_logical_replication_slot('hevo_slot', 'pgoutput');

-- 3. Create the Publication for your tables
CREATE PUBLICATION hevo_publication FOR ALL TABLES;

