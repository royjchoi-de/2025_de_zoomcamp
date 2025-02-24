{{ config(materialized='table') }}

WITH valid_trips AS (
    SELECT *,
    TIMESTAMP_DIFF(dropoff_datetime, pickup_datetime, SECOND) AS seconds_difference
    FROM {{ ref('dim_fhv_trips') }}
),

percentiles AS (
    SELECT 
        pickup_year,
        pickup_month,
        pickup_zone,
        dropoff_zone,
        PERCENTILE_CONT(seconds_difference, .90) OVER (PARTITION BY pickup_year, pickup_month, PU_locationid, DO_locationid) AS p90,
    FROM valid_trips
)

SELECT distinct pickup_year as year, pickup_month as month, pickup_zone, dropoff_zone, p90 as trip_duration
FROM percentiles
WHERE pickup_month = 11 AND pickup_year = 2019 and pickup_zone in ('Newark Airport', 'SoHo', 'Yorkville East')
order by 5 desc