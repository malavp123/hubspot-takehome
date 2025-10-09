{{ config(materialized='view') }}

with src as (
  select * from {{ source('tpch','LINEITEM') }}
)

select
  l_orderkey                           as order_key,
  l_linenumber                         as line_number,
  l_partkey                            as part_key,
  l_suppkey                            as supplier_key,
  l_quantity::number(38,3)             as quantity,
  l_extendedprice::number(38,2)        as extended_price,
  l_discount::number(10,6)             as discount,
  l_tax::number(10,6)                  as tax,
  (l_extendedprice * (1 - l_discount))::number(38,2) as net_item_sales,
  (l_extendedprice * (1 - l_discount) * (1 + l_tax))::number(38,2) as gross_item_sales,
  l_returnflag                         as return_flag,
  l_linestatus                         as line_status,
  l_shipdate::date                     as ship_date,
  l_commitdate::date                   as commit_date,
  l_receiptdate::date                  as receipt_date,
  l_shipmode                           as ship_mode,
  l_comment                            as comment
from src