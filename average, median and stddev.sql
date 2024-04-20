WITH trips_by_day AS (
  SELECT
    EXTRACT(DAYOFWEEK FROM trip_start_timestamp) AS weekday,  
    AVG(trip_seconds) AS avg_seconds,
    STDDEV(trip_seconds) AS stddev_seconds,
    APPROX_QUANTILES(trip_seconds, 1001)[OFFSET(501)] AS median_seconds
  FROM bigquery-public-data.chicago_taxi_trips.taxi_trips
  GROUP BY EXTRACT(DAYOFWEEK FROM trip_start_timestamp)
)

SELECT
  CASE
    WHEN weekday = 1 THEN "Monday"
    WHEN weekday = 6 THEN "Saturday"
  END AS weekday,
  avg_seconds,
  median_seconds,
  stddev_seconds
FROM trips_by_day
WHERE weekday IN (1, 6)
ORDER BY weekday;