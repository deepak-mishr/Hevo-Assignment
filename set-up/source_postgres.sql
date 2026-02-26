-- source_postgres.sql

-- 1. Create Tables
-- 1. Raw Customers Table
CREATE TABLE raw_customers (
    id INT PRIMARY KEY,
    first_name VARCHAR(255),
    last_name VARCHAR(255)
);

-- 2. Raw Orders Table
CREATE TABLE raw_orders (
    id INT PRIMARY KEY,
    user_id INT,
    order_date DATE,
    status VARCHAR(50)
);

-- 3. Raw Payments Table
CREATE TABLE raw_payments (
    id INT PRIMARY KEY,
    order_id INT,
    payment_method VARCHAR(100),
    amount INT
);


COPY raw_customers(id, first_name, last_name) 
FROM '/tmp/raw_customers.csv' DELIMITER ',' CSV HEADER;

COPY raw_orders(id, user_id, order_date, status) 
FROM '/tmp/raw_orders.csv' DELIMITER ',' CSV HEADER;

COPY raw_payments(id, order_id, payment_method, amount) 
FROM '/tmp/raw_payments.csv' DELIMITER ',' CSV HEADER;


-- 2. Create the Publication using a variable

DROP PUBLICATION IF EXISTS :pub_name;
CREATE PUBLICATION :pub_name FOR ALL TABLES;

-- 3. Create the Logical Replication Slot
SELECT pg_create_logical_replication_slot(:'slot_name','pgoutput');


