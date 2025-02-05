-- Creating external table referring to gcs path
CREATE OR REPLACE EXTERNAL TABLE data-warehouse-rc.ny_taxi.external_yellow_tripdata
OPTIONS (
  format = 'PARQUET',
  uris = ['gs://ny_taxi_rc/yellow_tripdata_2024-*.parquet']
);

-- Check yellow trip data
SELECT * FROM data-warehouse-rc.ny_taxi.external_yellow_tripdata limit 10;

-- Create a non partitioned table from external table
CREATE OR REPLACE TABLE data-warehouse-rc.ny_taxi.yellow_tripdata_non_partitioned AS
SELECT * FROM data-warehouse-rc.ny_taxi.external_yellow_tripdata;

-- Create a partitioned table from external table
CREATE OR REPLACE TABLE data-warehouse-rc.ny_taxi.yellow_tripdata_partitioned
PARTITION BY
  DATE(tpep_pickup_datetime) AS
SELECT * FROM data-warehouse-rc.ny_taxi.external_yellow_tripdata;

-- Impact of partition
-- Scanning 310.24 MB ofdata
SELECT DISTINCT(VendorID)
FROM data-warehouse-rc.ny_taxi.yellow_tripdata_non_partitioned
WHERE DATE(tpep_pickup_datetime) BETWEEN '2024-01-01' AND '2024-06-30';

-- Scanning ~310.24 MB of DATA - partitioned data is still same size as nonpartitioned
SELECT DISTINCT(VendorID)
FROM data-warehouse-rc.ny_taxi.yellow_tripdata_partitioned
WHERE DATE(tpep_pickup_datetime) BETWEEN '2024-01-01' AND '2024-06-30';

--get no data to display // fix partiton to partition
SELECT table_name, partition_id, total_rows
FROM `ny_taxi.INFORMATION_SCHEMA.PARTITIONS`
WHERE table_name = 'yellow_tripdata_partitioned'
ORDER BY total_rows DESC;

-- Creating a partition and cluster table
CREATE OR REPLACE TABLE data-warehouse-rc.ny_taxi.yellow_tripdata_partitoned_clustered
PARTITION BY DATE(tpep_pickup_datetime)
CLUSTER BY VendorID AS
SELECT * FROM data-warehouse-rc.ny_taxi.external_yellow_tripdata;

--Query scans 310.24 MB
SELECT count(*) as trips
FROM data-warehouse-rc.ny_taxi.yellow_tripdata_partitioned
WHERE DATE(tpep_pickup_datetime) BETWEEN '2024-01-01' AND '2024-06-30'
  AND VendorID=1;

-- Query scans 251.74 MB
SELECT count(*) as trips
FROM data-warehouse-rc.ny_taxi.yellow_tripdata_partitoned_clustered
WHERE DATE(tpep_pickup_datetime) BETWEEN '2024-01-01' AND '2024-06-30'
  AND VendorID=1;
