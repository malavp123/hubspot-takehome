-- macros/as_currency.sql
{% macro as_currency(colname) %}
    cast(replace(replace({{ colname }}, '$', ''), ',', '') as numeric)
{% endmacro %}
