-- 1. Create the schema for raw data
CREATE TABLE raw_customers (id INT PRIMARY KEY, first_name VARCHAR(255), last_name VARCHAR(255));
CREATE TABLE raw_orders (id INT PRIMARY KEY, user_id INT, order_date DATE, status VARCHAR(50));
CREATE TABLE raw_payments (id INT PRIMARY KEY, order_id INT, payment_method VARCHAR(100), amount INT);

-- 2. Create the Logical Replication Slot for this specific database
SELECT * FROM pg_create_logical_replication_slot('Name_of_the_Slot', 'pgoutput');

-- 3. Create the Publication for your tables
CREATE PUBLICATION name_of_the_publication FOR ALL TABLES;
