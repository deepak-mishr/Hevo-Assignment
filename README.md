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
    └── profiles.yml      # Parameterized connection profile


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

# Create the docker group, add your current user to the group and apply the changes to your current session
sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker


# 1. Start the container
docker-compose up -d

# 2. Load environment variables
export $(grep -v '^#' .env | xargs)

#Copy the Data from local to Docker /tmp folder
cd Data
sudo docker cp raw_customers.csv $PG_CONTAINER:/tmp/
sudo docker cp raw_orders.csv $PG_CONTAINER:/tmp/
sudo docker cp raw_payments.csv $PG_CONTAINER:/tmp/

#Copy the source_postgres.sql file from local to Container
cd ..
cd set-up
docker cp source_postgres.sql ${PG_CONTAINER}:/tmp/source_postgres.sql

#Execute the SQL file using -v to pass variables
docker exec -it ${PG_CONTAINER} psql \
  -U ${PG_USER} \
  -d ${PG_DB} \
  -v pub_name=${PG_PUB} \
  -v slot_name=${PG_SLOT} \
  -f /tmp/source_postgres.sql

#Enable Logical Replication:

SHOW wal_level;
ALTER SYSTEM SET wal_level = 'logical'; ( Change only if not Logical already)

    
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

    mkdir -p ~/.dbt
    nano ~/.dbt/profiles.yml

    #Paste the below content in ~/.dbt/profiles.yml

    hevo_interview:
      outputs:
        dev:
          type: snowflake
          account: "{{ env_var('SNOW_ACCOUNT') }}"
          user: "{{ env_var('SNOW_USER') }}"
          password: "{{ env_var('SNOW_PASS') }}"
          role: ACCOUNTADMIN
          warehouse: "{{ env_var('SNOW_WH') }}"
          database: "{{ env_var('SNOW_DB') }}"
          schema: "{{ env_var('SNOW_SCHEMA') }}"
          threads: 1
          client_session_keep_alive: False
      target: dev
    
    cd dbt_project
    dbt build

  

