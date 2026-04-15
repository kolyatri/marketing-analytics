with source as (

    select * 
    from {{ source('raw', 'orders') }}

),

cleaned as (

    select
        order_id,
        user_id,
        cast(order_date as date) as order_date,
        cast(revenue as numeric) as revenue

    from source

)

select * from cleaned