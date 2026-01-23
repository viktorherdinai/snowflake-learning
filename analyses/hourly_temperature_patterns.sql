-- Analysis: Hourly temperature distribution across all cities
-- Find the warmest and coldest hours of the day on average
-- Useful for understanding daily temperature patterns

SELECT
    HOUR(time) AS hour_of_day,
    COUNT(*) AS readings,
    ROUND(AVG(temperature), 2) AS avg_temp,
    ROUND(MIN(temperature), 2) AS min_temp,
    ROUND(MAX(temperature), 2) AS max_temp,
    -- Show which cities are warmest/coldest at this hour
    MAX(CASE WHEN temperature = MAX(temperature) OVER (PARTITION BY HOUR(time))
        THEN city END) AS warmest_city,
    MIN(CASE WHEN temperature = MIN(temperature) OVER (PARTITION BY HOUR(time))
        THEN city END) AS coldest_city
FROM {{ ref('fact_weather_enriched') }}
GROUP BY HOUR(time)
ORDER BY hour_of_day

