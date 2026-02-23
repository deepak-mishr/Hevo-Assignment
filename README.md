# E2E Data Pipeline: Hevo + Snowflake + dbt

## 1. Prerequisites
- Docker & Docker Compose
- ngrok (for local tunneling)
- Snowflake Trial Account

## 2. Environment Configuration
1. Fill in your specific credentials in `.env`. These variables are used by Docker and dbt to prevent hardcoding sensitive info.

## 3. Source Setup (PostgreSQL)
- Start the database: `docker-compose up -d`.
- Enable the tunnel: `ngrok tcp 5432`.
- Run `setup/source_postgres.sql` to initialize schema.
- Import the provided CSVs into the tables.

## 4. Pipeline Setup (Hevo)
- Connect Hevo to the ngrok Host/Port.
- Set Ingestion Mode to **Logical Replication**.
- Map the tables to Snowflake.

## 5. Transformation (dbt)
- Navigate to `/dbt_project`.
- Export your env vars: `source ../.env` (or use a tool like `direnv`).
- Run the pipeline:
  ```bash
  dbt deps
  dbt run
  dbt test
