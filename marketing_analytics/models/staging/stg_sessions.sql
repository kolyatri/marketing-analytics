with source as (

    select * 
    from {{ source('raw', 'sessions') }}

),

cleaned as (

    select
        session_id,
        user_id,
        cast(session_date as date) as session_date,
        lower(channel) as channel,
        lower(device) as device

    from source

)

select * from cleaned