SELECT
    t.*,
    city.city,
    city.country,
    country.* EXCLUDE (country)
FROM
    {{ ref("silver_weather")}} t
    LEFT JOIN {{ ref("dim_city") }} city ON t.latitude = city.latitude  AND t.longitude = city.longitude
    LEFT JOIN {{ ref("dim_country") }} country ON city.country = country.country

-- seeds can be referenced by ref, no need for source