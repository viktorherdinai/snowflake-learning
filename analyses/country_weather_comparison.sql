-- Analysis: Compare weather patterns between countries
-- Shows temperature variance, extremes, and averages by country

SELECT
    country,
    region,
    COUNT(DISTINCT city) AS num_cities,
    COUNT(*) AS total_readings,
    ROUND(AVG(temperature), 2) AS avg_temp,
    ROUND(MIN(temperature), 2) AS min_temp,
    ROUND(MAX(temperature), 2) AS max_temp,
    ROUND(STDDEV(temperature), 2) AS temp_variance,
    ROUND(MAX(temperature) - MIN(temperature), 2) AS temp_range
FROM {{ ref('fact_weather_enriched') }}
GROUP BY country, region
ORDER BY avg_temp DESC

