-- models/marts/mart_listing_day.sql
-- Public analyst surface (join the two internal marts on the spine)
{{ config(materialized='view') }}

select
  r.listing_id,
  r.date,
  r.neighborhood,
  r.property_type,
  r.room_type,
  r.is_available,
  r.is_booked,
  r.price_usd,
  r.revenue,
  r.min_nights,
  r.max_nights,
  a.has_air_conditioning,
  a.has_lockbox,
  a.has_first_aid_kit,
  a.review_score_on_date
from {{ ref('mart_revenue_occupancy_day') }} r
left join {{ ref('mart_amenity_review_day') }} a
  on a.listing_id = r.listing_id
 and a.date       = r.date
