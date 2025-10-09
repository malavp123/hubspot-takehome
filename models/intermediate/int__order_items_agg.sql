{{ config(materialized='view') }}

with li as (
  select * from {{ ref('stg__line_items') }}
)

select
  order_key,
  count(*)                               as line_count,
  sum(quantity)                          as total_quantity,
  sum(net_item_sales)                    as net_sales,
  sum(gross_item_sales)                  as gross_sales,
  sum(extended_price)                    as extended_price_sum,
  avg(discount)                          as avg_discount,
  avg(tax)                               as avg_tax
from li
group by 1
