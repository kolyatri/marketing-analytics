with source as (

    select * 
    from {{ source('raw', 'ads_data') }}

),

cleaned as (

    select
        cast(date as date) as date,
        lower(channel) as channel,
        campaign_id,
        impressions,
        clicks,
        cast(ad_spend as numeric) as ad_spend

    from source

)

select * from cleaned