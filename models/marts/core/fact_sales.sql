{{ config(materialized='table') }}

with orders as (
  select * from {{ ref('int__orders_enriched') }}
),
items as (
  select * from {{ ref('int__order_items_agg') }}
)

select
  o.order_key,
  {{ surrogate_key(['o.customer_key']) }}      as customer_sk,
  o.customer_key,
  o.order_date,
  o.order_status,
  o.order_total_price,
  i.line_count,
  i.total_quantity,
  i.net_sales,
  i.gross_sales,
  i.extended_price_sum,
  i.avg_discount,
  i.avg_tax,
  o.nation_name,
  o.region_name,
  o.market_segment
from orders o
left join items i using (order_key)