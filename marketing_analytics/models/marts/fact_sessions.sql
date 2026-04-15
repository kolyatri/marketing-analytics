-- models/marts/fact_sessions.sql

select
    session_id,
    user_id,
    session_date,
    channel,
    device

from {{ ref('stg_sessions') }}