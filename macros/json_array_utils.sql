-- macros/json_array_utils.sql
{% macro json_array_to_list(colname) %}
    -- Adapter-agnostic: try to coerce a JSON-like string to an array of text
    -- For Snowflake: parse_json + flatten; for Postgres/BigQuery you can adapt.
    {{ return(adapter.dispatch('json_array_to_list', 'rental_takehome')(colname)) }}
{% endmacro %}

{% macro default__json_array_to_list(colname) %}
    -- Fallback: treat as a delimiter-separated string (", ") and split
    -- Replace quotes and brackets first.
    split(regexp_replace(regexp_replace(regexp_replace({{ colname }}, '\\[|\\]', ''), '\"', ''), '\\s*,\\s*', ','), ',')
{% endmacro %}

{% macro array_contains(array_expr, value) %}
    {{ return(adapter.dispatch('array_contains', 'rental_takehome')(array_expr, value)) }}
{% endmacro %}

{% macro default__array_contains(array_expr, value) %}
    -- Naive fallback: join array back to string and use ilike; adapters can override
    lower(array_to_string({{ array_expr }}, ',')) like '%' || lower({{ value }}) || '%'
{% endmacro %}
