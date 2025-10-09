{% macro surrogate_key(cols) %}
  {# Snowflake: create stable deterministic surrogate keys #}
  md5(
    concat_ws(
      '||',
      {% for c in cols -%}
        coalesce(cast({{ c }} as varchar), '')
        {%- if not loop.last %}, {% endif -%}
      {%- endfor %}
    )
  )
{% endmacro %}
