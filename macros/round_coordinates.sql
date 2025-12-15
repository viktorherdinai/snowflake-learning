{% macro round_coordinates(column_name) %}
    ROUND({{ column_name }}, 2)
{% endmacro %}