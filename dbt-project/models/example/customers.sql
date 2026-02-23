{{ config(materialized='table') }}

with customers as (
    select 
        id as customer_id, 
        first_name, 
        last_name 
    from {{ source('hevo_source', 'raw_customers') }}
),

orders as (
    select 
        id as order_id, 
        user_id as customer_id, 
        order_date, 
        status 
    from {{ source('hevo_source', 'raw_orders') }}
),

payments as (
    select 
        order_id, 
        amount 
    from {{ source('hevo_source', 'raw_payments') }}
),

customer_orders as (
    select
        customer_id,
        min(order_date) as first_order_date,
        max(order_date) as most_recent_order_date,
        count(order_id) as number_of_orders
    from orders
    group by 1
),

customer_payments as (
    select
        o.customer_id,
        sum(p.amount) as lifetime_value
    from payments p
    join orders o on p.order_id = o.order_id
    group by 1
)

select
    c.customer_id,
    c.first_name,
    c.last_name,
    co.first_order_date,
    co.most_recent_order_date,
    coalesce(co.number_of_orders, 0) as number_of_orders,
    coalesce(cp.lifetime_value, 0) as lifetime_value
from customers c
left join customer_orders co on c.customer_id = co.customer_id
left join customer_payments cp on c.customer_id = cp.customer_id