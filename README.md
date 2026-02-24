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
### Install the Docker an dSetup the Postgres Conatiner

# Pull and start the container
sudo docker run --name Hevo-Postgres -p 5432:5432 -e POSTGRES_PASSWORD='your_password' -d postgres

# Enable Logical Replication 
sudo docker exec -it Hevo-Postgres psql -U postgres -c "ALTER SYSTEM SET wal_level = 'logical';"

# Restart to apply changes
sudo docker restart Hevo-Postgres

```
```
###  Clone and Prepare Environment
First, clone the repository and set up your credentials.
```bash
# Clone the repository
git clone https://github.com/deepak-mishr/Hevo-Assignment.git

# Move into the project directory
cd Hevo-Assignment

## Update the .env file and assign the value to the defined parameters

    ## Infrastructure Setup (Docker & Postgres)

    Spin up the database and load the data using parameterized scripts:

    # 1. Start the container
    docker-compose up -d

    # 2. Load environment variables
    export $(grep -v '^#' .env | xargs)

    # 3. Connect to Postgres
    docker exec -it $PG_CONTAINER

    #Enable Logical Replication:

    SHOW wal_level;
    ALTER SYSTEM SET wal_level = 'logical';


    #Create DB and Load Data

    CREATE DATABASE name_of_database;
    \c name_of_database;

    #Create table using the source_postgres.sql file and load the data available within Data Folder

    #Copy the Data from local to Docker /tmp folder
    cd Data
    sudo docker cp raw_customers.csv $PG_CONTAINER:/tmp/
    sudo docker cp raw_orders.csv $PG_CONTAINER:/tmp/
    sudo docker cp raw_payments.csv $PG_CONTAINER:/tmp/

    #Load Data to Postgres from Docker:

    COPY raw_customers(id, first_name, last_name) 
    FROM '/tmp/raw_customers.csv' DELIMITER ',' CSV HEADER;

    COPY raw_orders(id, user_id, order_date, status) 
    FROM '/tmp/raw_orders.csv' DELIMITER ',' CSV HEADER;

    COPY raw_payments(id, order_id, payment_method, amount) 
    FROM '/tmp/raw_payments.csv' DELIMITER ',' CSV HEADER;


    
## Ngrok Networking Setup

    # 1. Authenticate (Only once)
    ngrok config add-authtoken $NGROK_AUTHTOKEN

    # 2. Start the TCP Tunnel
    ngrok tcp 5432

    Note the forwarding address (e.g., 0.tcp.in.ngrok.io:15653). Use 0.tcp.in.ngrok.io as the Host and 15653 as the Port in the Hevo UI.

    # 3. Map the Host and Port in Hevo's Source Config.

## Snowflake and DBT Setup
    Ensure Snowflake destination is ready.

    Run dbt:
    
    cd dbt_project
    dbt build

  

