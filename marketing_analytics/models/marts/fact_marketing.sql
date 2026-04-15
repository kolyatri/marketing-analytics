-- models/marts/fact_marketing.sql

select
    date,
    channel,
    campaign_id,
    sum(impressions) as impressions,
    sum(clicks) as clicks,
    sum(ad_spend) as ad_spend

from {{ ref('stg_ads') }}

group by 1, 2, 3