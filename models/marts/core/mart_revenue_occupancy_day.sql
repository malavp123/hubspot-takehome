-- models/marts/mart_revenue_occupancy_day.sql
-- MATERIALIZE AS TABLE for performance (override project default)
{{ config(materialized='table', unique_key=['listing_id','date']) }}

select
  c.listing_id,
  c.date,
  l.neighborhood,
  l.property_type,
  l.room_type,
  c.is_available,
  c.is_booked,
  c.price_usd,
  c.revenue,
  c.min_nights,
  c.max_nights
from {{ ref('int__revenue_occupancy') }} c
left join {{ ref('stg__listings') }} l using (listing_id)
