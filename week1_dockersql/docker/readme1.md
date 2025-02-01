###
Question 3. Trip Segmentation Count
During the period of October 1st 2019 (inclusive) and November 1st 2019 (exclusive), how many trips, respectively, happened:

    Up to 1 mile
    In between 1 (exclusive) and 3 miles (inclusive),
    In between 3 (exclusive) and 7 miles (inclusive),
    In between 7 (exclusive) and 10 miles (inclusive),
    Over 10 miles

Answers:

    104,802; 197,670; 110,612; 27,831; 35,281
    104,802; 198,924; 109,603; 27,678; 35,189
    104,793; 201,407; 110,612; 27,831; 35,281
    104,793; 202,661; 109,603; 27,678; 35,189
    104,838; 199,013; 109,645; 27,688; 35,202

SELECT 
    COUNT(CASE WHEN trip_distance <= 1 THEN 1 END) AS trips_up_to_1_mile,
    COUNT(CASE WHEN trip_distance > 1 AND trip_distance <= 3 THEN 1 END) AS trips_between_1_and_3_miles,
    COUNT(CASE WHEN trip_distance > 3 AND trip_distance <= 7 THEN 1 END) AS trips_between_3_and_7_miles,
    COUNT(CASE WHEN trip_distance > 7 AND trip_distance <= 10 THEN 1 END) AS trips_between_7_and_10_miles,
    COUNT(CASE WHEN trip_distance > 10 THEN 1 END) AS trips_over_10_miles
FROM 
    green_taxi_data g;

trips_up_to_1_mile              104838
trips_between_1_and_3_miles     199013
trips_between_3_and_7_miles     109645
trips_between_7_and_10_miles    27688    
trips_over_10_miles             35202

** When I input lpep_pickup_dates between the dates 10/1/19 and 11/1/19, I get missing data (just using trips up to 1 mile as an example). I'm missing about 8 trips split up between lpep pickupdate date 10/1/19 and 11/1/19. Need to look further into this.

###
Question 4. Longest trip for each day

Which was the pick up day with the longest trip distance? Use the pick up time for your calculations.

Tip: For every day, we only care about one single trip with the longest distance.

    2019-10-11
    2019-10-24
    2019-10-26
    2019-10-31

WITH daily_max_distance AS (
    SELECT
        DATE(lpep_pickup_datetime) AS pickup_date,
        MAX(trip_distance) AS max_trip_distance
    FROM
        green_taxi_data
    GROUP BY
        DATE(lpep_pickup_datetime)
)
SELECT
    d.pickup_date,
    d.max_trip_distance,
    t.lpep_pickup_datetime,
    t.lpep_dropoff_datetime,
    t.trip_distance
FROM
    daily_max_distance d
JOIN
    green_taxi_data t
ON
    DATE(t.lpep_pickup_datetime) = d.pickup_date
    AND t.trip_distance = d.max_trip_distance
ORDER BY
    d.pickup_date;

2019-10-11      95.78
2019-10-24      90.75
2019-10-26      91.56
2019-10-31      515.89
###
Question 5. Three biggest pickup zones

Which were the top pickup locations with over 13,000 in total_amount (across all trips) for 2019-10-18?

Consider only lpep_pickup_datetime when filtering by date.

    East Harlem North, East Harlem South, Morningside Heights
    East Harlem North, Morningside Heights
    Morningside Heights, Astoria Park, East Harlem South
    Bedford, East Harlem North, Astoria Park

SELECT
    t."PULocationID" AS pickup_loc,
    SUM(t.total_amount) AS total_amount
FROM
    green_taxi_data t
WHERE
    DATE(t.lpep_pickup_datetime) = '2019-10-18'
GROUP BY
    t."PULocationID"
HAVING
    SUM(t.total_amount) > 13000
ORDER BY
    total_amount DESC;


###
Question 6. Largest tip

For the passengers picked up in October 2019 in the zone named "East Harlem North" which was the drop off zone that had the largest tip?

Note: it's tip , not trip

We need the name of the zone, not the ID.

    Yorkville West
    JFK Airport
    East Harlem North
    East Harlem South

SELECT
    zdo."Zone" AS dropoff_zone,
    MAX(t.tip_amount) AS largest_tip
FROM
    green_taxi_data t
INNER JOIN
    taxi_zones zpu ON t."PULocationID" = zpu."LocationID"
INNER JOIN
    taxi_zones zdo ON t."DOLocationID" = zdo."LocationID"
WHERE
    zpu."Zone" = 'East Harlem North'
    AND t.lpep_pickup_datetime >= '2019-10-01'
    AND t.lpep_pickup_datetime < '2019-11-01'
GROUP BY
    zdo."Zone"
ORDER BY
    largest_tip DESC
LIMIT 1;



"JFK Airport"	87.3