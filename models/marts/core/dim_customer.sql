{{ config(materialized='table') }}

with c as (
  select * from {{ ref('stg__customers') }}
),
n as (
  select n_nationkey as nation_key, n_name as nation_name, n_regionkey as region_key
  from {{ source('tpch','NATION') }}
),
r as (
  select r_regionkey as region_key, r_name as region_name
  from {{ source('tpch','REGION') }}
)

select
  {{ surrogate_key(['c.customer_key']) }}       as customer_sk,
  c.customer_key,
  c.customer_name,
  c.market_segment,
  c.account_balance,
  n.nation_name,
  r.region_name
from c
left join n on c.nation_key = n.nation_key
left join r on n.region_key = r.region_key