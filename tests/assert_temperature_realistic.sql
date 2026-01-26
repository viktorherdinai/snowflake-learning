-- Test: Ensure temperature values are within realistic bounds
-- Temperatures should be between -100°C and +60°C

SELECT
    temperature,
    city,
    time,
    filename
FROM {{ ref('fact_weather_enriched') }}
WHERE temperature < -100 OR temperature > 60

