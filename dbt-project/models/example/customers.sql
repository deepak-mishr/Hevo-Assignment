{{ config(
    materialized='table',
    database=env_var('SNOWFLAKE_DATABASE')
) }}

with customers as (
    -- Reference the source defined in _sources.yml
    select * from {{ source('hevo_source', 'raw_customers') }}
),

orders as (
    select * from {{ source('hevo_source', 'raw_orders') }}
),

payments as (
    select * from {{ source('hevo_source', 'raw_payments') }}
),

customer_orders as (
    select
        user_id as customer_id,
        min(order_date) as first_order_date,
        max(order_date) as most_recent_order_date,
        count(id) as number_of_orders
    from orders
    group by 1
),

customer_payments as (
    select
        orders.user_id as customer_id,
        sum(payments.amount) as lifetime_value
    from payments
    left join orders on payments.order_id = orders.id
    group by 1
)

select
    c.id as customer_id,
    c.first_name,
    c.last_name,
    co.first_order_date,
    co.most_recent_order_date,
    coalesce(co.number_of_orders, 0) as number_of_orders,
    coalesce(cp.lifetime_value, 0) as lifetime_value
from customers c
left join customer_orders co on c.id = co.customer_id
left join customer_payments cp on c.id = cp.customer_id
