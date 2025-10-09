{{ config(materialized='view') }}

with src as (
  select * from {{ source('tpch','CUSTOMER') }}
)

select
  c_custkey        as customer_key,
  c_name           as customer_name,
  c_nationkey      as nation_key,
  c_acctbal::number(38,2) as account_balance,
  c_mktsegment     as market_segment,
  c_address        as address,
  c_phone          as phone,
  c_comment        as comment
from src