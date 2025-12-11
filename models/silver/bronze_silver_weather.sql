{{ config(materialized='table') }}


WITH weather AS (
    SELECT PARSE_JSON(raw_json) AS data FROM {{ ref("raw_bronze_weather") }}
)

SELECT
    CAST(data:elevation AS INT) AS elevation,
    CAST(data:hourly_units.temperature_2m AS STRING) AS unit,
    CAST(data:latitude AS FLOAT) AS latitude,
    CAST(data:longitude AS FLOAT) AS longitude,
    CAST(hourly.value AS FLOAT) AS temperature,
    CAST(times.value AS datetime) AS time 
FROM weather,
LATERAL FLATTEN(input => data:hourly.temperature_2m) as hourly,
LATERAL FLATTEN(input => data:hourly.time) as times
WHERE hourly.index = times.index
ORDER BY time;
