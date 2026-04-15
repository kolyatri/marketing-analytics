-- models/marts/dim_date.sql

with dates as (

    select generate_series(
        '2024-01-01'::date,
        '2024-12-31'::date,
        interval '1 day'
    )::date as date

)

select
    date,

    extract(year from date) as year,
    to_char(date, 'Mon') as month,
    extract(month from date) as month_number

from dates