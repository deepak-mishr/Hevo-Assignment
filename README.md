# Hevo Data Engineer Assignment: End-to-End MDS Pipeline

## 📖 Overview
This repository contains the complete implementation of a Modern Data Stack (MDS) pipeline. The project synchronizes data from a local, Dockerized PostgreSQL database to a Snowflake Data Warehouse using **Hevo Data** and performs downstream transformations using **dbt**.

The pipeline utilizes **Change Data Capture (CDC)** via Logical Replication to ensure efficient, real-time data synchronization.

---

## 🏗 Architecture
* **Source:** PostgreSQL (Docker) with `wal_level = logical`.
* **Network:** Secure TCP Tunneling via **ngrok**.
* **Ingestion:** **Hevo Data** (Logical Replication mode).
* **Warehouse:** **Snowflake**.
* **Transformation:** **dbt Cloud/Core** (Parameterized SQL modeling).



---

## 🛠 Project Structure
```text
.
├── .env                  # Environment variables (Not in Version Control)
├── .gitignore            # Security: Excludes sensitive files
├── docker-compose.yml    # Orchestrates PostgreSQL container
├── setup_postgres.sql    # Parameterized DDL and Data Load script
├── data/                 # Raw source CSV files
│   ├── raw_customers.csv
│   ├── raw_orders.csv
│   └── raw_payments.csv
└── dbt_project/          # dbt Transformation layer
    ├── models/           # SQL Models and Schema Tests
    └── profiles.yml      # Parameterized connection profiles

```
## Update the .env file and assign the value to the defined parameters

## Infrastructure Setup (Docker & Postgres)

Spin up the database and load the data using parameterized scripts:

# 1. Start the container
docker-compose up -d

# 2. Load environment variables
export $(grep -v '^#' .env | xargs)

# 3. Initialize DB and Load Data
docker exec -it $PG_CONTAINER psql -U postgres -c "CREATE DATABASE $PG_DB;"
docker cp ./data/ $PG_CONTAINER:/tmp/
docker cp setup_postgres.sql $PG_CONTAINER:/tmp/
docker exec -it $PG_CONTAINER psql -U postgres -d $PG_DB \
  -v pub_name=$PG_PUB -v slot_name=$PG_SLOT -f /tmp/setup_postgres.sql

