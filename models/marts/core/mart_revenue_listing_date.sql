-- models/marts/mart_revenue_listing_date.sql
{{ config(materialized='table', unique_key=['listing_id','dt']) }}
/* Daily revenue & occupancy at listing×day */
select
  listing_id,
  dt,
  revenue_usd,
  is_occupied,
  price_usd,
  min_nights,
  max_nights
from {{ ref('int__calendar_enriched') }}
