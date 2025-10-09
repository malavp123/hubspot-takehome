{{ config(materialized='view') }}

with src as (
  select * from {{ source('tpch','ORDERS') }}
)

select
  o_orderkey                   as order_key,
  o_custkey                    as customer_key,
  o_orderstatus                as order_status,
  o_totalprice::number(38,2)   as order_total_price,
  o_orderdate::date            as order_date,
  o_orderpriority              as order_priority,
  o_clerk                      as clerk,
  o_shippriority               as ship_priority,
  o_comment                    as comment
from src
