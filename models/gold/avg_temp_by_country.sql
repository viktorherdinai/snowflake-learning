{{ config(materialized="view") }}

SELECT
    country,
    ROUND(AVG(temperature), 2) AS avg_temperature
FROM
    {{ ref("fact_weather_enriched") }}
GROUP BY
    1