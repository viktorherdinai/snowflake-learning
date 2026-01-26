-- Analysis: Temperature anomaly detection
-- Find cities with temperature changes > 10°C in 1 hour
-- This could indicate data quality issues or extreme weather events

WITH hourly_temp AS (
    SELECT
        city,
        time,
        temperature,
        LAG(temperature) OVER (PARTITION BY city ORDER BY time) AS prev_temperature,
        LAG(time) OVER (PARTITION BY city ORDER BY time) AS prev_time
    FROM {{ ref('fact_weather_enriched') }}
)
SELECT
    city,
    time,
    temperature AS current_temp,
    prev_temperature,
    temperature - prev_temperature AS temp_change,
    DATEDIFF('minute', prev_time, time) AS minutes_between
FROM hourly_temp
WHERE ABS(temperature - prev_temperature) > 10
    AND prev_temperature IS NOT NULL
ORDER BY ABS(temperature - prev_temperature) DESC

