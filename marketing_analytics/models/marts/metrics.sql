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
        sum(o.revenue) as revenue,
        count(o.order_id) as orders

    from {{ ref('fact_orders') }} o
    left join user_last_channel uc
        on o.user_id = uc.user_id

    group by 1, 2

),

sessions as (

    select
        session_date as date,
        channel,
        count(session_id) as sessions

    from {{ ref('fact_sessions') }}
    group by 1, 2

),

marketing as (

    select
        date,
        channel,
        sum(impressions) as impressions,
        sum(clicks) as clicks,
        sum(ad_spend) as ad_spend

    from {{ ref('fact_marketing') }}
    group by 1, 2

),

joined as (

    select
        coalesce(m.date, s.date, o.date) as date,
        coalesce(m.channel, s.channel, o.channel) as channel,

        m.impressions,
        m.clicks,
        m.ad_spend,
        s.sessions,
        o.orders,
        o.revenue

    from marketing m
    full join sessions s
        on m.date = s.date and m.channel = s.channel
    full join orders o
        on coalesce(m.date, s.date) = o.date
       and coalesce(m.channel, s.channel) = o.channel

)

select
    date,
    channel,

    -- базові
    revenue,
    ad_spend,
    clicks,
    impressions,
    sessions,
    orders,

    -- метрики
    clicks * 1.0 / nullif(impressions, 0) as ctr,
    orders * 1.0 / nullif(sessions, 0) as conversion_rate,
    ad_spend * 1.0 / nullif(orders, 0) as cpa,
    revenue * 1.0 / nullif(ad_spend, 0) as roas

from joined