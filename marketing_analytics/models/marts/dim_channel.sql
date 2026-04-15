-- models/marts/dim_channel.sql

select distinct
    channel

from {{ ref('stg_sessions') }}

union

select distinct
    channel

from {{ ref('stg_ads') }}