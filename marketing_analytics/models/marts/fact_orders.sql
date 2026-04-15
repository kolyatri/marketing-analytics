-- models/marts/fact_orders.sql

select
    order_id,
    user_id,
    order_date,
    revenue

from {{ ref('stg_orders') }}