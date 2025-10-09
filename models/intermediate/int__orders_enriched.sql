{{ config(materialized='view') }}

with
orders as (
  select * from {{ ref('stg__orders') }}
),
customers as (
  select * from {{ ref('stg__customers') }}
),
nation as (
  select n_nationkey as nation_key, n_name as nation_name, n_regionkey as region_key
  from {{ source('tpch','NATION') }}
),
region as (
  select r_regionkey as region_key, r_name as region_name
  from {{ source('tpch','REGION') }}
)

select
  o.order_key,
  o.customer_key,
  o.order_status,
  o.order_total_price,
  o.order_date,
  o.order_priority,
  o.clerk,
  o.ship_priority,
  c.customer_name,
  c.account_balance,
  c.market_segment,
  n.nation_name,
  r.region_name
from orders o
left join customers c on o.customer_key = c.customer_key
left join nation n     on c.nation_key   = n.nation_key
left join region r     on n.region_key   = r.region_key
