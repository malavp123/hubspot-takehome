{% macro as_of_join(left_tbl, right_tbl, key_cols, left_date_col, right_valid_from='dbt_valid_from', right_valid_to='dbt_valid_to') %}
    {{ left_tbl }} l
    left join {{ right_tbl }} r
      on {% for k in key_cols %}
           l.{{ k }} = r.{{ k }}{% if not loop.last %} and {% endif %}
         {% endfor %}
     and l.{{ left_date_col }} >= r.{{ right_valid_from }}
     and (r.{{ right_valid_to }} is null or l.{{ left_date_col }} < r.{{ right_valid_to }})
{% endmacro %}