SELECT
    PARSE_JSON(raw_json)::VARIANT AS parsed_json,
    * EXCLUDE RAW_JSON
FROM
    {{ source('raw', 'weather') }}