-- models/marts/mart_amenity_review_day.sql
-- MATERIALIZE AS TABLE for performance (amenities + aligned reviews)
{{ config(materialized='table', unique_key=['listing_id','date']) }}

with amen as (
  select * from {{ ref('int__amenities_daily') }}
),
-- Temporal approximation:
-- Link each review to the amenity *state on the review date* (correlational, not causal)
reviews_aligned as (
  select
    r.listing_id,
    r.review_id,
    r.review_date,
    r.review_score,
    a.has_air_conditioning,
    a.has_lockbox,
    a.has_first_aid_kit
  from {{ ref('stg__generated_reviews') }} r
  left join amen a
    on a.listing_id = r.listing_id
   and a.date       = r.review_date
),
-- Expand to daily grain so this mart can be joined on (listing_id, date)
at_day_grain as (
  select
    s.listing_id,
    s.date,
    a.has_air_conditioning,
    a.has_lockbox,
    a.has_first_aid_kit,
    -- keep review metrics only on the review date; null otherwise
    case when s.date = ra.review_date then ra.review_score end as review_score_on_date
  from {{ ref('int__listings_day_spine') }} s
  left join amen a
    on a.listing_id = s.listing_id
   and a.date       = s.date
  left join reviews_aligned ra
    on ra.listing_id = s.listing_id
   and ra.review_date = s.date
)
select * from at_day_grain
