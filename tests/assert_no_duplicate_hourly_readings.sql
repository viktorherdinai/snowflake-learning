-- Test: Check for duplicate hourly records per city
-- Each city should have only one temperature reading per hour

SELECT
    city,
    time,
    COUNT(*) as duplicate_count
FROM {{ ref('fact_weather_enriched') }}
GROUP BY city, time
HAVING COUNT(*) > 1

