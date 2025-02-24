{{ config(materialized="table") }}

with
    fhv_tripdata as (select *, from {{ ref("stg_fhv_filtered") }}),
    dim_zones as (select * from {{ ref("dim_zones") }} where borough != 'Unknown')
select
    fhv_tripdata.tripid,
    fhv_tripdata.pu_locationid,
    fhv_tripdata.do_locationid,
    fhv_tripdata.pickup_datetime,
    fhv_tripdata.dropoff_datetime,
    extract(year from fhv_tripdata.pickup_datetime) as pickup_year,
    extract(month from fhv_tripdata.pickup_datetime) as pickup_month,
    pickup_zone.zone as pickup_zone,
    dropoff_zone.zone as dropoff_zone

from fhv_tripdata
inner join
    dim_zones as pickup_zone on fhv_tripdata.PU_locationid = pickup_zone.locationid
inner join
    dim_zones as dropoff_zone
    on fhv_tripdata.DO_locationid = dropoff_zone.locationid
