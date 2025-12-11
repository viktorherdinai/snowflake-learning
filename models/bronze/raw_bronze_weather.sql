{{ config(materialized='table', alias='hourly_weather') }}

SELECT
$1 AS raw_json
FROM
@SNOWFLAKE_LEARNING_DB.PUBLIC.WEATHER_RAW (FILE_FORMAT => 'JSON')
