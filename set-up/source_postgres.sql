-- Create Tables
CREATE TABLE raw_customers (id INT PRIMARY KEY, first_name VARCHAR(255), last_name VARCHAR(255));
CREATE TABLE raw_orders (id INT PRIMARY KEY, user_id INT, order_date DATE, status VARCHAR(50));
CREATE TABLE raw_payments (id INT PRIMARY KEY, order_id INT, payment_method VARCHAR(100), amount INT);


-- Setup Replication
CREATE PUBLICATION name_of_publication FOR ALL TABLES;
SELECT pg_create_logical_replication_slot('Your_slot_name', 'pgoutput');
