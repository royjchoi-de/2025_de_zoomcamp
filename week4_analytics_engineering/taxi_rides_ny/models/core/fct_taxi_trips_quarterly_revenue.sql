{{ config(materialized="table") }}

with
    q_revenue as (
        select
            service_type,
            extract(year from pickup_datetime) as year,
            extract(quarter from pickup_datetime) as quarter,
            sum(total_amount) as revenue

        from {{ ref("fact_trips") }}
        where extract(year from pickup_datetime) in (2019, 2020)
        group by service_type, year, quarter
    ),

    q_growth as (
        select
            year,
            quarter,
            service_type,
            revenue,
            lag(revenue) over (
                partition by service_type, quarter order by year
            ) as prev_year_revenue,
            (
                revenue
                - lag(revenue) over (partition by service_type, quarter order by year)
            ) / nullif(
                lag(revenue) over (partition by service_type, quarter order by year), 0
            ) as yoy_growth
        from q_revenue
    )
select *
from q_growth
