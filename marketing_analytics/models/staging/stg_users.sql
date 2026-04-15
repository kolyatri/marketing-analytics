with source as (

    select * 
    from {{ source('raw', 'users') }}

),

cleaned as (

    select
        user_id,
        cast(signup_date as date) as signup_date,
        upper(country) as country

    from source

)

select * from cleaned