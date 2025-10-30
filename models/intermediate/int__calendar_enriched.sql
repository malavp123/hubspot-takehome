-- models/int/int__calendar_enriched.sql
{{ config(materialized='view') }}
select
  c.listing_id,
  c.dt,
  c.price_usd,
  c.min_nights,
  c.max_nights,
  (c.reservation_id is not null)::int as is_occupied,                 
  case when c.reservation_id is not null then c.price_usd else 0 end as revenue_usd
from {{ ref('stg__calendar') }} c
