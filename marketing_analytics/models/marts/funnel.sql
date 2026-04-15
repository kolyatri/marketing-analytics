
with sessions_ranked as (

    select
        user_id,
        channel,
        session_date,
        row_number() over (
            partition by user_id
            order by session_date desc
        ) as rn

    from {{ ref('fact_sessions') }}

),

user_last_channel as (

    select
        user_id,
        channel
    from sessions_ranked
    where rn = 1

),

orders as (

    select
        o.order_date as date,
        uc.channel,
        count(o.order_id) as orders

    from {{ ref('fact_orders') }} o
    left join user_last_channel uc
        on o.user_id = uc.user_id

    group by 1, 2

),

marketing as (

    select
        date,
        channel,
        sum(impressions) as impressions,
        sum(clicks) as clicks

    from {{ ref('fact_marketing') }}
    group by 1, 2

),

sessions as (

    select
        session_date as date,
        channel,
        count(session_id) as sessions

    from {{ ref('fact_sessions') }}
    group by 1, 2

)

select
    coalesce(m.date, s.date, o.date) as date,
    coalesce(m.channel, s.channel, o.channel) as channel,

    m.impressions,
    m.clicks,
    s.sessions,
    o.orders

from marketing m
full join sessions s on m.date = s.date and m.channel = s.channel
full join orders o on coalesce(m.date, s.date) = o.date and coalesce(m.channel, s.channel) = o.channel