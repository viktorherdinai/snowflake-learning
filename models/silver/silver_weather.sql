SELECT
    parsed_json:elevation::int AS elevation,
    {{ round_coordinates('parsed_json:latitude') }} AS latitude,
    {{ round_coordinates('parsed_json:longitude') }} AS longitude,
    hourly.value::float AS temperature,
    parsed_json:hourly_units.temperature_2m::string AS unit,
    times.value::datetime AS time,
    filename
FROM
    {{ ref("bronze_weather") }},
    LATERAL FLATTEN(input => parsed_json:hourly.temperature_2m) as hourly,
    LATERAL FLATTEN(input => parsed_json:hourly.time) as times
WHERE
    hourly.index = times.index

