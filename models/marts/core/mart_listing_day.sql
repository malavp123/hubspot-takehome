-- models/marts/mart_listing_daily.sql
{{ config(materialized='table', unique_key=['listing_id','dt']) }}
/* Final reporting mart at (listing_id, dt)
   - amenity flags as-of date
   - daily review rollup
   - neighborhood for #2
*/
with rev as (
  select * from {{ ref('mart_revenue_listing_date') }}
),
amen_scd as (
  select * from {{ ref('int__amenities_scd') }}
),
listings as (
  select listing_id, neighborhood from {{ ref('stg__listings') }}
),
amen_asof as (
  /* As-of join (non-equi) without a macro for clarity */
  select
    r.listing_id,
    r.dt,
    a.amenity_air_conditioning,
    a.amenity_lockbox,
    a.amenity_first_aid_kit
  from {{ ref('mart_revenue_listing_date') }} r
  left join amen_scd a
    on r.listing_id = a.listing_id
   and r.dt >= a.valid_from
   and (a.valid_to is null or r.dt < a.valid_to)
),
rv_1d as (
  select * from {{ ref('int__reviews_daily') }}
)
select
  r.listing_id,
  r.dt,
  l.neighborhood,
  r.revenue_usd,
  r.is_occupied,
  r.price_usd,
  r.min_nights,
  r.max_nights,
  a.amenity_air_conditioning,
  a.amenity_lockbox,
  a.amenity_first_aid_kit,
  rv.review_count_1d,
  rv.avg_review_score_1d
from rev r
left join listings l
  on r.listing_id = l.listing_id
left join amen_asof a
  on r.listing_id = a.listing_id and r.dt = a.dt
left join rv_1d rv
  on r.listing_id = rv.listing_id and r.dt = rv.dt
